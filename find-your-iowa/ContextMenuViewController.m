//
//  ContextMenuViewController.m
//  find-your-iowa
//
//  Created by Thomas Hansen on 12/12/13.
//  Copyright (c) 2013 Thomas Hansen. All rights reserved.
//

#import "ContextMenuViewController.h"
#import "FeedViewController.h"


@interface ContextMenuViewController ()

@end

@implementation ContextMenuViewController

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

    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
	// Do any additional setup after loading the view.
    self.items = @[
                   @"Featured",
                   @"Museums",
                   @"Historic Landmarks",
                   @"Public Art",
                   @"Zoos",
    ];
}


-(void) show{
    [self.parentViewController.view addSubview:self.view];

    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
}


-(void) hide{
    [self.parentViewController.view addSubview:self.view];
}


-(NSInteger)tableView: (UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* item = [self.items objectAtIndex:[indexPath row]];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContextCell" forIndexPath:indexPath];
    cell.textLabel.text = item;

    UIImageView* imgview; //= [[UIImageView alloc] initWithImage:<#(UIImage *)#>];

    if([item isEqualToString:@"Featured"])
        imgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"filterbtn-featured"]];
    
    if([item isEqualToString:@"Museums"])
        imgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"filterbtn-museums"]];
    
    if([item isEqualToString:@"Public Art"])
        imgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"filterbtn-publicart"]];
    
    if([item isEqualToString:@"Historic Landmarks"])
        imgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"filterbtn-historiclandmarks"]];
    
    if([item isEqualToString:@"Zoos"])
        imgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"filterbtn-zoos"]];
    
    
    [cell.contentView addSubview:imgview];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [self.tableView.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"GOTO: %@", cell.textLabel.text);

    NSArray* results;
    
    if([cell.textLabel.text isEqualToString:@"Featured"])
        results = queryLocations(@"SELECT * FROM locations WHERE length(images) > 0");
    
    if([cell.textLabel.text isEqualToString:@"Museums"])
        results = queryLocations(@"SELECT * FROM locations where categories == 'museum'");
    
    if([cell.textLabel.text isEqualToString:@"Historic Landmarks"])
        results = queryLocations(@"SELECT * FROM locations where categories == 'national_historic_landmark'");
                                 
    if([cell.textLabel.text isEqualToString:@"Public Art"])
        results = queryLocations(@"SELECT * FROM locations where categories == 'art'");
    
    if([cell.textLabel.text isEqualToString:@"Zoos"])
        results = queryLocations(@"SELECT * FROM locations where categories == 'zoo'");

    
    FeedViewController* parent = (FeedViewController*) self.parentViewController;
    [parent setResults: results];
    NSString* title_name = [NSString stringWithFormat:@"%@ ▾",cell.textLabel.text ];
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectZero];
    [button addTarget:parent action:@selector(headerTapped:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title_name  forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0 green:0 blue:1 alpha:1] forState:UIControlStateNormal];
    [button sizeToFit];
    parent.navigationItem.titleView = button;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}


@end
