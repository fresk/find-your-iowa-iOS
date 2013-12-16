//
//  Location.m
//  find-your-iowa
//
//  Created by Thomas Hansen on 12/11/13.
//  Copyright (c) 2013 Thomas Hansen. All rights reserved.
//

#import "Location.h"



@implementation LocationPin
- (id)initWithLocation: (CLLocationCoordinate2D) coord {
    self = [super init];
    if (self) {
        self.coordinate = coord;
    }
    return self;
}
@end




@implementation Location

-(id)initWithData: (NSDictionary *)dict_data
{
    if (self = [super init])
    {
        self.data = dict_data;
        self.uid = [self.data objectForKey:@"id"];
        self.name = [self.data objectForKey:@"name"];
        self.city = [self.data objectForKey:@"city"];
        self.images = [[self.data objectForKey:@"images"] componentsSeparatedByString:@","];
        
        self.previewImageURL = [NSURL URLWithString: [self.images objectAtIndex:0]];
    }
    return self;
}


- (UIImageView*) imageViewForPreview  {
    UIImageView* img_view = [[UIImageView alloc] init];
    if ([self.images count]){
        //[img_view setImageWithURL:self.previewImageURL];
        NSString* img_src = [NSString stringWithFormat:@"%@.jpg", self.uid];
        [img_view setImage:[UIImage imageNamed:img_src]];
    }
    return img_view;
    
}

-(CLLocationCoordinate2D) getCoordinate {
    double lat  = [[self.data objectForKey:@"lat"] doubleValue];
    double lng  = [[self.data objectForKey:@"lng"] doubleValue];
    NSLog(@"coords: %f, %f", lat, lng);
    return CLLocationCoordinate2DMake(lat, lng);
}


-(LocationPin*) makeLocationPin {
    // Add an annotation
    LocationPin *point = [[LocationPin alloc] init];
    point.coordinate = [self getCoordinate];
    point.title = self.name;
    point.subtitle = self.city;
    point.locationData = self.data;
    return point;
}




@end
