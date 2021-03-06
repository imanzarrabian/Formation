//
//  StationAnnotation.h
//  VelibApp
//
//  Created by Iman Zarrabian on 18/11/14.
//  Copyright (c) 2014 Iman Zarrabian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface StationAnnotation : NSObject <MKAnnotation>

@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title andSubtitle:(NSString *)subtitle;


@end
