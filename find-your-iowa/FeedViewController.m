//
//  ViewController.m
//  find-your-iowa
//
//  Created by Thomas Hansen on 12/9/13.
//  Copyright (c) 2013 Thomas Hansen. All rights reserved.
//

#import "FeedViewController.h"
#import "DetailViewController.h"
#import "Location.h"
#import "ContextMenuViewController.h"
#import "AddToCollectionOverlay.h"
#import <objc/runtime.h>

@interface FeedViewController ()

@end

@implementation FeedViewController {
    __weak IBOutlet UITableView *_tableView;
    NSArray* _locations;
    __weak IBOutlet UINavigationItem *navBar;
    ContextMenuViewController* _context_menu;
    AddToCollectionOverlay* _add_to_collection_menu;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _tableView.delegate = self;
    _tableView.dataSource = self;

    
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _context_menu = [sb instantiateViewControllerWithIdentifier:@"ContextMenuView"];
    [self addChildViewController:_context_menu];
    [self.view addSubview: _context_menu.view];
    
    _add_to_collection_menu = [sb instantiateViewControllerWithIdentifier:@"AddToCollection"];
    [self addChildViewController:_add_to_collection_menu];
    [self.view addSubview: _add_to_collection_menu.view];
    _add_to_collection_menu.view.hidden = TRUE;
    

    UIButton * button = [[UIButton alloc]initWithFrame:CGRectZero];
    [button addTarget:self action:@selector(headerTapped:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Featured ▾" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0 green:0 blue:1 alpha:1] forState:UIControlStateNormal];
    [button sizeToFit];
    self.navigationItem.titleView = button;
    
    [self setResults:queryLocations(@"SELECT * FROM locations WHERE length(images) > 0")];
}


-(void)viewWillAppear:(BOOL)animated{
    [_tableView reloadData ];

}

-(void) setResults: (NSArray*) locations {
    NSLog(@"HIDE CONTEXT");
    _locations = locations;
    [_tableView reloadData];
    _context_menu.view.hidden = TRUE;
    
    
}


-(void) headerTapped: (id) sender {
    NSLog(@"Header Tapped!");
    [_context_menu show];
    _context_menu.view.hidden = FALSE;
}


-(NSInteger)tableView: (UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    return [_locations count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Location* location = [_locations objectAtIndex:[indexPath row]];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiscoverViewCell" forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    //NSLog(@"IMAGE: #%@#", [location.images objectAtIndex:0]);
    if ([[location.images objectAtIndex:0] isEqualToString:@""]){
        UIImageView* img = [[UIImageView alloc] init];
        [img setImageWithURL: [NSURL URLWithString: @"http://placehold.it/320x144&text=no%20image%20available?.png"]];
        img.frame = CGRectMake(0,0,320,200);
        img.contentMode = UIViewContentModeScaleAspectFill;
        [cell.contentView addSubview: img];
    }
    else {
        UIImageView* img = [location imageViewForPreview];
        img.frame = CGRectMake(0,0,320,200);
        img.contentMode = UIViewContentModeScaleAspectFill;
        [cell.contentView addSubview: img];
    }
    
    UIImageView* img2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-gradient"]];
    [cell.contentView addSubview: img2];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10,140,320,44)];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
    label.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    label.text = location.name;
    [cell.contentView addSubview: label];
    
    UILabel* label2 = [[UILabel alloc] initWithFrame:CGRectMake(10,160,320,44)];
    label2.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    label2.font = [UIFont fontWithName:@"Helvetica" size:14];
    label2.text = location.city;
    //NSLog(@"city: %@", location.city);
    [cell.contentView addSubview: label2];
    
    UIButton* btn_favorite = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([FYIApp.userData[location.uid] isEqualToString:@"starred"]){
        [btn_favorite setImage:[UIImage imageNamed:@"star_yellow"] forState:UIControlStateNormal];
    }
    else{
        [btn_favorite setImage:[UIImage imageNamed:@"star_grey"] forState:UIControlStateNormal];
        [btn_favorite addTarget:self action:@selector(favoriteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        objc_setAssociatedObject(btn_favorite, "location", location, OBJC_ASSOCIATION_ASSIGN);
        btn_favorite.alpha = 0.5;
    }
    btn_favorite.frame = CGRectMake(280, 15, 30, 30);
    [cell.contentView addSubview:btn_favorite];

    return cell;
}



-(void)favoriteBtnPressed:(id)sender {
    Location* location = objc_getAssociatedObject(sender, "location");
    NSLog(@"favorite: %@", location.name);
    objc_setAssociatedObject(_add_to_collection_menu, "location", location, OBJC_ASSOCIATION_ASSIGN);
    [_add_to_collection_menu show];
    _add_to_collection_menu.view.hidden = FALSE;
    
    UIButton* btn = (UIButton*) sender;
    [btn setImage:[UIImage imageNamed:@"star_yellow"] forState:UIControlStateNormal];
    btn.alpha =1.0;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Location* location = [_locations objectAtIndex:[indexPath row]];
    
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *detail_view = [sb instantiateViewControllerWithIdentifier:@"DetailView"];
    [detail_view setLocationID: location.uid];
    [self.navigationController pushViewController:detail_view animated:TRUE];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
