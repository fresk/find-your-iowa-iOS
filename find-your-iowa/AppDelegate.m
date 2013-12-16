//
//  AppDelegate.m
//  find-your-iowa
//
//  Created by Thomas Hansen on 12/9/13.
//  Copyright (c) 2013 Thomas Hansen. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate



+ (NSDictionary*) loadJsonFile: (NSString*)filename {
    NSError *err;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"json"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&err];
    NSLog(@"read Error: %@", err ) ;
    if (err)
        return nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&err];
    NSLog(@"json Error: %@", err ) ;
    if (err)
        return nil;
    return json;
}


+ (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}


-(void) initUserData {
    NSString *docs_path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* userData_fname = [docs_path stringByAppendingPathComponent:@"userData.plist"];

    self.userData = [NSMutableDictionary dictionaryWithContentsOfFile:userData_fname];
    if (self.userData == nil){
        //first start
        //NSLog(@"creating blank favorites list");
        self.userData = [[NSMutableDictionary alloc] init];
        self.userData[@"collections"] = [[NSMutableArray alloc ] initWithArray:@[
                                                                                 @"My Favorites",
                                                                                 @"Museums for the Kids",
                                                                                 @"Spring Break Ideas",
                                                                                 @"Civil War Battlefields"
                                                                                 ] copyItems:TRUE];
        
        NSLog(@"collections: %@", self.userData[@"collections"]);
        [self saveUserData];
    }

}



- (BOOL) saveUserData {
    NSString *docs_path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* userData_fname = [docs_path stringByAppendingPathComponent:@"userData.plist"];
    return[self.userData writeToFile:userData_fname atomically:TRUE];
}


// Application Delegate functions /////////////////////////////////////////////////////////////////////////////////

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self initUserData];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self saveUserData];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self saveUserData];
}

@end
