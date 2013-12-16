//
//  SingleCollectionViewController.m
//  find-your-iowa
//
//  Created by Thomas Hansen on 12/16/13.
//  Copyright (c) 2013 Thomas Hansen. All rights reserved.
//

#import "SingleCollectionViewController.h"
#import <objc/runtime.h>
#import "Location.h"
#import "DetailViewController.h"
@interface SingleCollectionViewController ()

@end

@implementation SingleCollectionViewController{
    __strong IBOutlet UITableView *_tableView;
    NSArray* _items;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;

    
}

-(void)viewWillAppear:(BOOL)animated{
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:NO];
    NSString* collection_name = objc_getAssociatedObject(self, "collection");
    _items = FYIApp.userData[collection_name];
    self.navigationItem.title = collection_name;
    [_tableView reloadData ];
}




-(NSInteger)tableView: (UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    return [_items count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* location_uid = [_items objectAtIndex:[indexPath row]];

    NSString* q = [NSString stringWithFormat:@"SELECT * FROM locations WHERE id == '%@'", location_uid];
    Location* loc = queryLocations(q)[0];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"singlecollectioncell" forIndexPath:indexPath];
    cell.textLabel.text = loc.name;
    objc_setAssociatedObject(cell, "location", loc, OBJC_ASSOCIATION_RETAIN);
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Location* location = objc_getAssociatedObject(self, "location");
    UITableViewCell* cell = [_tableView.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"Locations: %@", cell.textLabel.text);
    
    Location* location = objc_getAssociatedObject(cell, "location");
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *detail_view = [sb instantiateViewControllerWithIdentifier:@"DetailView"];
    [detail_view setLocationID: location.uid];
    [self.navigationController pushViewController:detail_view animated:TRUE];
}
@end
