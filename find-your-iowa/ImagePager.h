//
//  ImagePager.h
//  find-your-iowa
//
//  Created by Thomas Hansen on 12/11/13.
//  Copyright (c) 2013 Thomas Hansen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"

@interface ImagePager : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) Location* location;

-(id)initWithLocation: (Location*) location;
-(void) collapseFullScreen;
-(void) makeFullScreen;
@end
