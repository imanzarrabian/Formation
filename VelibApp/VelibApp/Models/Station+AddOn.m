//
//  Station+AddOn.m
//  VelibApp
//
//  Created by Iman Zarrabian on 24/11/14.
//  Copyright (c) 2014 Iman Zarrabian. All rights reserved.
//

#import "Station+AddOn.h"
#import "AppDelegate.h"
@implementation Station (AddOn)

- (void)fillWithHash:(NSDictionary *)station {
    NSArray *decomposedName;
    if (station[@"name"]) {
        decomposedName = [station[@"name"] componentsSeparatedByString:@" - "];
    }
    self.name = [[decomposedName lastObject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    self.number = station[@"number"];
    self.address = station[@"address"];
    self.nbBikeAvailable = station[@"available_bikes"];
    self.nbStandAvailable = station[@"available_bike_stands"];
    self.lat = station[@"position"][@"lat"];
    self.lng = station[@"position"][@"lng"];
}

+ (NSArray *)fetchStationsWithSortDescriptors:(NSArray *)sortDescriptors {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Station"];
    if (sortDescriptors) {
        request.sortDescriptors = sortDescriptors;
    }
    AppDelegate *myApp = [[UIApplication sharedApplication] delegate];
    NSError *error = nil;

    return [myApp.managedObjectContext executeFetchRequest:request error:&error];
}
@end
