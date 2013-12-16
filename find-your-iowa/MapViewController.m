//
//  MapViewController.m
//  find-your-iowa
//
//  Created by Thomas Hansen on 12/11/13.
//  Copyright (c) 2013 Thomas Hansen. All rights reserved.
//

#import "MapViewController.h"
#import "ContextMenuViewController.h"
#import "Location.h"
#import "DetailViewController.h"

@interface MapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController {
    NSArray* _locations;
    __weak IBOutlet UINavigationItem *navBar;
    
    ContextMenuViewController* _context_menu;


}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.mapView.delegate = self;
    self.mapView.showsUserLocation = TRUE;
    
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _context_menu = [sb instantiateViewControllerWithIdentifier:@"ContextMenuView"];
    [self addChildViewController:_context_menu];
    [self.view addSubview: _context_menu.view];

    
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectZero];
    [button addTarget:self action:@selector(headerTapped:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Featured" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0 green:0 blue:1 alpha:1] forState:UIControlStateNormal];
    [button sizeToFit];
    self.navigationItem.titleView = button;
    
    [self setResults:queryLocations(@"SELECT * FROM locations WHERE length(images) > 0")];


}



-(void) setResults: (NSArray*) locations {


    
    NSLog(@"HIDE CONTEXT");
    _locations = locations;
    _context_menu.view.hidden = TRUE;
    
    NSLog(@"SET RESULTS");
    [self removeAllAnnotations];
    [self addLocationMarkers];
}

-(void)removeAllAnnotations
{
    //Get the current user location annotation.
    id userAnnotation=self.mapView.userLocation;
    
    //Remove all added annotations
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    // Add the current user location annotation again.
    if(userAnnotation!=nil)
        [self.mapView addAnnotation:userAnnotation];
}


-(void) addLocationMarkers {
    for (Location* loc in _locations) {
        NSLog(@"add location: %@", loc);
        [self.mapView addAnnotation: [loc makeLocationPin]];
    }
}



-(void) headerTapped: (id) sender {
    NSLog(@"Header Tapped!");
    [_context_menu show];
    _context_menu.view.hidden = FALSE;
}



-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion mapRegion;
    mapRegion.center = mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.2;
    mapRegion.span.longitudeDelta = 0.2;
    
    [mapView setRegion:mapRegion animated: YES];
}



- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    
    LocationPin* pin = (LocationPin*) annotation;
    NSString* category = [pin.locationData objectForKey:@"categories"];
    NSString* image_name = [NSString stringWithFormat:@"marker-%@.png", category];
    NSLog(@"image_name:%@", image_name);
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.image = [UIImage imageNamed:image_name];
    return annotationView;
}



- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    LocationPin* pin = (LocationPin*) view.annotation;
    NSString* uid = [pin.locationData objectForKey:@"id"];
    
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *detail_view = [sb instantiateViewControllerWithIdentifier:@"DetailView"];
    [detail_view setLocationID: uid];
    [self.navigationController pushViewController:detail_view animated:TRUE];
}






@end
