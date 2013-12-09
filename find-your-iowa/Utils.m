#import "Utils.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>


// helper function: get the url encoded string form of any object
static NSString *urlEncode(id object) {
    return [[NSString stringWithFormat: @"%@", object] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
}




@implementation NSDictionary (NSURL)

- (NSString*) getAsQueryParams {
    NSMutableArray *parts = [NSMutableArray array];
    for (id key in self) {
        id value = [self objectForKey: key];
        NSString *part = [NSString stringWithFormat: @"%@=%@", urlEncode(key), urlEncode(value)];
        [parts addObject: part];
    }
    return [parts componentsJoinedByString: @"&"];
}

+ (NSDictionary *)withURLQueryParameters:(NSURL *)URL {
    NSString *queryString = [URL query];
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    NSArray *parameters = [queryString componentsSeparatedByString:@"&"];
    for (NSString *parameter in parameters)
    {
        NSArray *parts = [parameter componentsSeparatedByString:@"="];
        NSString *key = [[parts objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if ([parts count] > 1)
        {
            id value = [[parts objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [result setObject:value forKey:key];
        }
    }
    return result;
}

@end



@implementation NSURL (QueryParams)

+ (NSURL*) URLWithPath: (NSString*) path andParams: (NSDictionary*) params {
    return (params != nil) ? [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", path, [params getAsQueryParams]]] : [NSURL URLWithString:path];
}

@end



@implementation UIColor (UIColor_PXExtensions)

+ (UIColor*)pxColorWithHexValue:(NSString*)hexValue
{
    //Default
    UIColor *defaultResult = [UIColor blackColor];
    
    //Strip prefixed # hash
    if ([hexValue hasPrefix:@"#"] && [hexValue length] > 1) {
        hexValue = [hexValue substringFromIndex:1];
    }
    
    //Determine if 3 or 6 digits
    NSUInteger componentLength = 0;
    if ([hexValue length] == 3)
    {
        componentLength = 1;
    }
    else if ([hexValue length] == 6)
    {
        componentLength = 2;
    }
    else
    {
        return defaultResult;
    }
    
    BOOL isValid = YES;
    CGFloat components[3];
    
    //Seperate the R,G,B values
    for (NSUInteger i = 0; i < 3; i++) {
        NSString *component = [hexValue substringWithRange:NSMakeRange(componentLength * i, componentLength)];
        if (componentLength == 1) {
            component = [component stringByAppendingString:component];
        }
        
        NSScanner *scanner = [NSScanner scannerWithString:component];
        unsigned int value;
        isValid &= [scanner scanHexInt:&value];
        components[i] = (CGFloat)value / 255.0f;
    }
    
    if (!isValid) {
        return defaultResult;
    }
    
    return [UIColor colorWithRed:components[0]
                           green:components[1]
                            blue:components[2]
                           alpha:1.0];
}

@end