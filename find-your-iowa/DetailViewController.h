//
//  DetailViewController.h
//  find-your-iowa
//
//  Created by Thomas Hansen on 12/11/13.
//  Copyright (c) 2013 Thomas Hansen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UIScrollViewDelegate, UIWebViewDelegate>
-(void)setLocationID: (NSString*) uid;
@end
