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

@interface StationDetailViewController () <CLLocationManagerDelegate>
@property (nonatomic, weak) IBOutlet UILabel *bikeAvailableLabel;
@property (nonatomic, weak) IBOutlet UILabel *standsAvailableLabel;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, weak) IBOutlet UIView *locationWarningView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *warningViewBottomConstraint;
@end

@implementation StationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
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

- (void)setZoomOnMapAoundStationCoord {
    CLLocationCoordinate2D locationCoord = CLLocationCoordinate2DMake([self.station.lat doubleValue], [self.station.lng doubleValue]);
    MKCoordinateSpan span =  MKCoordinateSpanMake(10.005, 10.005);
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
