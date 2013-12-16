//
//  ContextMenuViewController.h
//  find-your-iowa
//
//  Created by Thomas Hansen on 12/12/13.
//  Copyright (c) 2013 Thomas Hansen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContextMenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray* items;
-(void) show;
-(void) hide;
@end
