//
//  ViewController.h
//  find-your-iowa
//
//  Created by Thomas Hansen on 12/9/13.
//  Copyright (c) 2013 Thomas Hansen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
-(void) headerTapped: (id) sender;
-(void) setResults: (NSArray*) locations;
@end
