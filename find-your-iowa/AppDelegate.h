//
//  AppDelegate.h
//  find-your-iowa
//
//  Created by Thomas Hansen on 12/9/13.
//  Copyright (c) 2013 Thomas Hansen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (NSDictionary*) loadJsonFile: (NSString*)filename ;
+ (UIImage *) imageWithView:(UIView *)view;

@end
