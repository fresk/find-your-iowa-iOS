//
//  ViewController.m
//  find-your-iowa
//
//  Created by Thomas Hansen on 12/9/13.
//  Copyright (c) 2013 Thomas Hansen. All rights reserved.
//

#import "DiscoverViewController.h"

@interface DiscoverViewController ()

@end

@implementation DiscoverViewController {
    __weak IBOutlet UITableView *_tableView;
    NSArray* _locations;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _locations = queryLocations(@"SELECT * FROM locations LIMIT 100");
    _tableView.delegate = self;
    _tableView.dataSource = self;
}


-(NSInteger)tableView: (UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    return [_locations count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* location = [_locations objectAtIndex:[indexPath row]];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiscoverViewCell" forIndexPath:indexPath];
    
    UIWebView* web_view = (UIWebView*)[cell.contentView viewWithTag:1];
    NSString* urlString = [NSString stringWithFormat:@"http://findyouriowa.com/render/location/%@", [location objectForKey:@"id"]];
    [web_view loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    web_view.userInteractionEnabled = NO;
    
    //cell.titleField.text = [location objectForKey:@"name"];
    //cell.markerImage.image = [ctx markerForCategoryID:[cat objectForKey:@"id"]];
    //cell.countLabel.text = [NSString stringWithFormat:@"(%@)", [cat objectForKey:@"num_entries"]];
    
    // Configure the cell...
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
