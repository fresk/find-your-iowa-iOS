//
//  Location.h
//  find-your-iowa
//
//  Created by Thomas Hansen on 12/11/13.
//  Copyright (c) 2013 Thomas Hansen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface LocationPin : NSObject <MKAnnotation>
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title, *subtitle;
@property (nonatomic, copy) NSDictionary *locationData;
- (id)initWithLocation:(CLLocationCoordinate2D)coord;
@end



@interface Location : NSObject

@property (strong, nonatomic) NSDictionary* data;
@property (strong, nonatomic) NSString* uid;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* city;
@property (strong, nonatomic) NSArray* images;
@property (strong, nonatomic) NSURL* previewImageURL;

-(id)initWithData: (NSDictionary *)data;
-(UIImageView*) imageViewForPreview;
-(CLLocationCoordinate2D) getCoordinate;
-(LocationPin*) makeLocationPin;
@end
