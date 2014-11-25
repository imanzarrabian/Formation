//
//  StationDetailViewController.m
//  VelibApp
//
//  Created by Iman Zarrabian on 17/11/14.
//  Copyright (c) 2014 Iman Zarrabian. All rights reserved.
//

#import "StationDetailViewController.h"
#import <MapKit/MapKit.h>
#import "StationAnnotation.h"
#import "AppDelegate.h"

@interface StationDetailViewController () <CLLocationManagerDelegate>
@property (nonatomic, weak) IBOutlet UILabel *bikeAvailableLabel;
@property (nonatomic, weak) IBOutlet UILabel *standsAvailableLabel;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, weak) IBOutlet UIView *locationWarningView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *warningViewBottomConstraint;
@property (nonatomic, weak) IBOutlet UIButton *favButton;
@end

@implementation StationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadInitialFavButtonState];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkLocationAuthorization:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    self.title = self.station.name;
    self.bikeAvailableLabel.text = [NSString stringWithFormat:@"%ld bikes available",[self.station.nbBikeAvailable integerValue]];
    
    self.standsAvailableLabel.text = [NSString stringWithFormat:@"%ld stands available",[self.station.nbStandAvailable integerValue]];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openAppSettings:)];
    [self.locationWarningView addGestureRecognizer:tapGesture];
    
    //Delay en utilisant GCD
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
        self.locationManager = [[CLLocationManager alloc] init];
        
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
            //to be determined
            NSLog(@"I SAID FUCK NO !!!");
            self.warningViewBottomConstraint.constant = 0.0;
            [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:3 options:0 animations:^{
                [self.view layoutIfNeeded];
            } completion:nil];
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

- (void)loadInitialFavButtonState {
    BOOL isFavorite = self.station.user ? YES:NO;
    self.favButton.selected = isFavorite;

  /*  [self.favButton setTitle:@"Add to favs" forState:UIControlStateNormal];
    [self.favButton setTitle:@"Remove from favs" forState:UIControlStateSelected];
    [self.favButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.favButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];*/
}

- (IBAction)addOrRemoveToOrFromFavs:(id)sender {
    self.favButton.selected = !self.favButton.selected;
    AppDelegate *myApp = [[UIApplication sharedApplication] delegate];
    if (self.favButton.selected) {
        //self.station.user = myApp.currentUser;
        //EQUIVALENT AU VU DE NOTRE SCHEMA COREDATA
        [myApp.currentUser addFavorisObject:self.station];
    }
    else {
        //self.station.user = nil;
        //EQUIVALENT AU VU DE NOTRE SCHEMA COREDATA
        [myApp.currentUser removeFavorisObject:self.station];
    }
    [self.delegate stationDetailViewController:self didAddOrRemoveToOrFromFavsStation:self.station];
}

- (void)checkLocationAuthorization:(NSNotification *)notification {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        //to be determined
        NSLog(@"I SAID FUCK NO !!!");
        self.warningViewBottomConstraint.constant = 0.0;
        
        [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:3 options:0 animations:^{
            [self.view layoutIfNeeded];
        } completion:nil];
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized ) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.mapView.showsUserLocation = YES;
            self.warningViewBottomConstraint.constant = -self.locationWarningView.frame.size.height;
            
            [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:3 options:0 animations:^{
                [self.view layoutIfNeeded];
            } completion:nil];
        });
    }
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.mapView.showsUserLocation = YES;
        if (self.warningViewBottomConstraint.constant == 0.0) {
            self.warningViewBottomConstraint.constant = -self.locationWarningView.frame.size.height;
            
            [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:3 options:0 animations:^{
                [self.view layoutIfNeeded];
            } completion:nil];

        }
    }
    else if (status == kCLAuthorizationStatusDenied) {
        NSLog(@"NO THX !!!");
        self.warningViewBottomConstraint.constant = 0.0;
        [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:3 options:0 animations:^{
            [self.view layoutIfNeeded];
        } completion:nil];
    }
}

- (IBAction)goToItineraire:(id)sender {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        NSLog(@"Google map");
        //NSString *url = [NSString stringWithFormat:@"comgooglemaps://?center=%f,%f&zoom=14&views=drive", self.station.lat.doubleValue, self.station.lng.doubleValue];
        NSString *schemeUrl = [NSString stringWithFormat:@"comgooglemaps://?saddr=%f,%f&daddr=41,+rue+du+pre+Catelan+59110+la+madeleine&directionsmode=drive", self.station.lat.doubleValue, self.station.lng.doubleValue];
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:schemeUrl]];
    }
    else {
        NSLog(@"Apple map");
        Class mapItemClass = [MKMapItem class];
        if (mapItemClass) {
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.station.lat.doubleValue, self.station.lng.doubleValue);
            MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
            MKMapItem *map = [[MKMapItem alloc] initWithPlacemark:placemark];
            [map setName:self.title];
            
            NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving};
            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
            
            [MKMapItem openMapsWithItems:@[currentLocation, map] launchOptions:launchOptions];
            //[map openInMapsWithLaunchOptions:nil];
        }
    }
    
}

- (void)setZoomOnMapAoundStationCoord {
    CLLocationCoordinate2D locationCoord = CLLocationCoordinate2DMake([self.station.lat doubleValue], [self.station.lng doubleValue]);
    MKCoordinateSpan span =  MKCoordinateSpanMake(0.005, 0.005);
    MKCoordinateRegion region = MKCoordinateRegionMake(locationCoord, span);
    [self.mapView setRegion:region animated:YES];
}

- (void)setStationAnnotationOnMap {
    CLLocationCoordinate2D locationCoord = CLLocationCoordinate2DMake([self.station.lat doubleValue], [self.station.lng doubleValue]);

    StationAnnotation *annotation = [[StationAnnotation alloc] initWithCoordinate:locationCoord title:self.station.name andSubtitle:[NSString stringWithFormat:@"%ld bikes available",[self.station.nbBikeAvailable integerValue]] andStation:self.station];
    
    [self.mapView addAnnotation:annotation];
}


- (void)openAppSettings:(UITapGestureRecognizer *)tapGesture {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

@end
