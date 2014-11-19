//
//  Station.m
//  VelibApp
//
//  Created by Iman Zarrabian on 18/11/14.
//  Copyright (c) 2014 Iman Zarrabian. All rights reserved.
//

#import "Station.h"

@implementation Station


- (void)fillWithHash:(NSDictionary *)station {
    self.name = station[@"name"];
    self.address = station[@"address"];
    self.nbBikeAvailable = station[@"available_bikes"];
    self.nbStandAvailable = station[@"available_bike_stands"];
    self.lat = station[@"position"][@"lat"];
    self.lng = station[@"position"][@"lng"];
}

@end
