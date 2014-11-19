//
//  MapViewController.m
//  VelibApp
//
//  Created by Iman Zarrabian on 17/11/14.
//  Copyright (c) 2014 Iman Zarrabian. All rights reserved.
//

#import "MapViewController.h"
#import "StationManager.h"
#import <MapKit/MapKit.h>
#import "StationAnnotation.h"
#import "Station.h"
#import "StationDetailViewController.h"


#define MINIMUM_ZOOM_ARC 0.014 //approximately 1 miles (1 degree of arc ~= 69 miles)
#define ANNOTATION_REGION_PAD_FACTOR 1.15
#define MAX_DEGREES_ARC 360

@interface MapViewController () <CLLocationManagerDelegate,MKMapViewDelegate>

@property(nonatomic, strong) NSArray *stationArray;
@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, weak) IBOutlet MKMapView *mapView;
@property(nonatomic, strong) Station *stationSelected;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createFakeData];
    
    //Delay en utilisant GCD
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
        self.locationManager = [[CLLocationManager alloc] init];
        
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
            //to be determined
            /*NSLog(@"I SAID FUCK NO !!!");
            self.warningViewBottomConstraint.constant = 0.0;
            [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:3 options:0 animations:^{
                [self.view layoutIfNeeded];
            } completion:nil];*/
        }
        else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                //Means we are iOS8
                self.locationManager.delegate = self;
                [self.locationManager requestWhenInUseAuthorization];
            }
            else {
                self.mapView.showsUserLocation = YES;
                self.locationManager = nil;
            }
        }
        else {
            self.mapView.showsUserLocation = YES;
        }
        
        [self setStationAnnotationOnMap];
        [self setZoomOnMapAoundStationCoord];
    });
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.mapView.showsUserLocation = YES;
        /*if (self.warningViewBottomConstraint.constant == 0.0) {
            self.warningViewBottomConstraint.constant = -self.locationWarningView.frame.size.height;
            
            [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:3 options:0 animations:^{
                [self.view layoutIfNeeded];
            } completion:nil];
            
        }*/
    }
    else if (status == kCLAuthorizationStatusDenied) {
        NSLog(@"NO THX !!!");
        /*self.warningViewBottomConstraint.constant = 0.0;
        [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:3 options:0 animations:^{
            [self.view layoutIfNeeded];
        } completion:nil];*/
    }
}

- (void)setZoomOnMapAoundStationCoord{
    NSArray *annotations = self.mapView.annotations;
    NSUInteger count = [self.mapView.annotations count];
    if ( count == 0) { return; } //bail if no annotations
    
    //convert NSArray of id <MKAnnotation> into an MKCoordinateRegion that can be used to set the map size
    //can't use NSArray with MKMapPoint because MKMapPoint is not an id
    MKMapPoint points[count]; //C array of MKMapPoint struct
    for( int i=0; i<count; i++ ) //load points C array by converting coordinates to points
    {
        CLLocationCoordinate2D coordinate = [(id <MKAnnotation>)[annotations objectAtIndex:i] coordinate];
        points[i] = MKMapPointForCoordinate(coordinate);
    }
    //create MKMapRect from array of MKMapPoint
    MKMapRect mapRect = [[MKPolygon polygonWithPoints:points count:count] boundingMapRect];
    //convert MKCoordinateRegion from MKMapRect
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);
    
    //add padding so pins aren't scrunched on the edges
    region.span.latitudeDelta  *= ANNOTATION_REGION_PAD_FACTOR;
    region.span.longitudeDelta *= ANNOTATION_REGION_PAD_FACTOR;
    //but padding can't be bigger than the world
    if( region.span.latitudeDelta > MAX_DEGREES_ARC ) {region.span.latitudeDelta  = MAX_DEGREES_ARC; }
    if( region.span.longitudeDelta > MAX_DEGREES_ARC ){ region.span.longitudeDelta = MAX_DEGREES_ARC; }
    
    //and don't zoom in stupid-close on small samples
    if( region.span.latitudeDelta  < MINIMUM_ZOOM_ARC ) { region.span.latitudeDelta  = MINIMUM_ZOOM_ARC; }
    if( region.span.longitudeDelta < MINIMUM_ZOOM_ARC ) { region.span.longitudeDelta = MINIMUM_ZOOM_ARC; }
    //and if there is a sample of 1 we want the max zoom-in instead of max zoom-out
    if( count == 1 )
    {
        region.span.latitudeDelta = MINIMUM_ZOOM_ARC;
        region.span.longitudeDelta = MINIMUM_ZOOM_ARC;
    }
    [self.mapView setRegion:region animated:YES];
}

- (void)setStationAnnotationOnMap {
    NSMutableArray *annotations =[NSMutableArray new];
    
    for (Station *station in self.stationArray) {
        CLLocationCoordinate2D locationCoord = CLLocationCoordinate2DMake([station.lat doubleValue], [station.lng doubleValue]);
        
        StationAnnotation *annotation = [[StationAnnotation alloc] initWithCoordinate:locationCoord title:station.name andSubtitle:[NSString stringWithFormat:@"%ld bikes available",[station.nbBikeAvailable integerValue]] andStation:station];
        
        [annotations addObject:annotation];
    }

    [self.mapView addAnnotations:annotations];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    StationAnnotation *annotation = (StationAnnotation*)view.annotation;
    self.stationSelected = annotation.station;
    [self performSegueWithIdentifier:@"DetailsStation" sender:annotation.station];
}

- (void)createFakeData {
    self.stationArray = [StationManager stations];
}

- (IBAction)goToListVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"DetailsStation"]) {
        if ([sender isKindOfClass:[Station class]]) {
            if ([segue.destinationViewController isKindOfClass:[StationDetailViewController class]]) {
                StationDetailViewController *stationDetailVC = (StationDetailViewController *)segue.destinationViewController;
                stationDetailVC.station = (Station *)sender;
            }
        }
    }
}


@end