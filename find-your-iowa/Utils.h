//
//  Utils.h
//  Iowa Counties
//
//  Created by Thomas Hansen on 10/9/13.
//  Copyright (c) 2013 fresk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface NSDictionary (NSURL)
- (NSString*) getAsQueryParams;
+ (NSDictionary *)URLQueryParameters:(NSURL *)URL;
@end

@interface NSURL (QueryParams)
+ (NSURL*) URLWithPath: (NSString*) path andParams: (NSDictionary*) params;
@end

@interface UIColor (UIColor_PXExtensions)
+ (UIColor*)pxColorWithHexValue:(NSString*)hexValue;
@end



