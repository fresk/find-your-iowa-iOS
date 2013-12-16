//
//  CollectionsViewController.m
//  find-your-iowa
//
//  Created by Thomas Hansen on 12/16/13.
//  Copyright (c) 2013 Thomas Hansen. All rights reserved.
//

#import "CollectionsViewController.h"
#import "SingleCollectionViewController.h"
#import <objc/runtime.h>

@interface CollectionsViewController ()

@end

@implementation CollectionsViewController {
    __weak IBOutlet UITableView *_tableView;
    NSArray* _collections;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _collections = FYIApp.userData[@"collections"];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [_tableView reloadData ];
}




-(NSInteger)tableView: (UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    return [_collections count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* item = [_collections objectAtIndex:[indexPath row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"collectioncell" forIndexPath:indexPath];
    cell.textLabel.text = item;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Location* location = objc_getAssociatedObject(self, "location");
    UITableViewCell* cell = [_tableView.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"Collection: %@", cell.textLabel.text);
    
    
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     SingleCollectionViewController *detail_view = [sb instantiateViewControllerWithIdentifier:@"SingleCollectionViewController"];
    objc_setAssociatedObject(detail_view, "collection", cell.textLabel.text, OBJC_ASSOCIATION_ASSIGN);
    [self.navigationController pushViewController:detail_view animated:TRUE];
}

@end

