//
//  FilterViewController.m
//  find-your-iowa
//
//  Created by Thomas Hansen on 12/12/13.
//  Copyright (c) 2013 Thomas Hansen. All rights reserved.
//

#import "FilterViewController.h"
#import "Location.h"
#import "DetailViewController.h"

@interface FilterViewController ()
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tabelView;

@end

@implementation FilterViewController {

    NSArray* _searchResults;
    NSArray* _defaultOptions;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _defaultOptions = @[
                        @"Museums",
                        @"Public Art",
                        @"Zoos",
                        @"Historic Landmarks"
    ];
    _searchResults = [[NSArray alloc] init];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //do search
     NSString *q = [NSString stringWithFormat:@"SELECT * FROM locations WHERE name LIKE '%@%@%@' ", @"%", self.searchBar.text, @"%"];
    _searchResults = queryLocations(q);
    NSLog(@"%@\nsearch results: %d", q, [_searchResults count]);
    [self.tabelView reloadData];
    
}



-(void)viewWillAppear:(BOOL)animated {
    
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
}






-(NSInteger)tableView: (UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    return [_searchResults count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Location* location = [_searchResults objectAtIndex:[indexPath row]];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell" forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    //NSLog(@"IMAGE: #%@#", [location.images objectAtIndex:0]);
    cell.textLabel.text = location.name;
    
    return cell;
}



-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Location* location = [_searchResults objectAtIndex:[indexPath row]];
    

    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *detail_view = [sb instantiateViewControllerWithIdentifier:@"DetailView"];
    [detail_view setLocationID: location.uid];
    [self.navigationController pushViewController:detail_view animated:TRUE];
}





@end
