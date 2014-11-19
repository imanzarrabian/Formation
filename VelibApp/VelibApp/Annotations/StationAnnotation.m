//
//  StationAnnotation.m
//  VelibApp
//
//  Created by Iman Zarrabian on 18/11/14.
//  Copyright (c) 2014 Iman Zarrabian. All rights reserved.
//

#import "StationAnnotation.h"

@implementation StationAnnotation

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title andSubtitle:(NSString *)subtitle andStation:(Station*)station {
    if (self = [super init]) {
        self.coordinate = coordinate;
        self.title = title;
        self.subtitle = subtitle;
        self.station = station;
    }
    return self;
}

@end
