//
//  StationManager.m
//  VelibApp
//
//  Created by Stephane on 19/11/2014.
//  Copyright (c) 2014 Iman Zarrabian. All rights reserved.
//

#import "StationManager.h"
#import "Station.h"

@implementation StationManager

+(NSArray*)stations{
    NSMutableArray *stations = [NSMutableArray new];
    
    for (NSInteger i=0; i<10; i++) {
        Station *station = [[Station alloc] init];
        station.name = [NSString stringWithFormat:@"STATION %ld",i];
        station.nbBikeAvailable = @(i+2);
        station.nbStandAvailable = @(i*3);
        [stations addObject:station];
        station.lat = [[NSNumber alloc] initWithDouble:50.63 + (0.0047 * i)];
        station.lng = [[NSNumber alloc] initWithDouble:3.02 + (0.0047 * i)];
    }
    
    return stations;
}

@end
