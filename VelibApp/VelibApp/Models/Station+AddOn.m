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

+ (NSEntityDescription *)entityObject {
    AppDelegate *myApp = [[UIApplication sharedApplication] delegate];
    return [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:myApp.managedObjectContext];
}

- (void)fillWithHash:(NSDictionary *)station {
    NSArray *decomposedName;
    if (station[@"name"]) {
        decomposedName = [station[@"name"] componentsSeparatedByString:@" - "];
    }
    self.name = [[decomposedName lastObject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    self.unique_id = station[@"number"];
    self.address = station[@"address"];
    self.nbBikeAvailable = station[@"available_bikes"];
    self.nbStandAvailable = station[@"available_bike_stands"];
    self.lat = station[@"position"][@"lat"];
    self.lng = station[@"position"][@"lng"];
}

+ (Station *)createOrGetStationWithUniqueIdentifier:(NSNumber *)uniqueIdentifier {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Station"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"unique_id == %@",uniqueIdentifier];
    request.predicate = predicate;
    AppDelegate *myApp = [[UIApplication sharedApplication] delegate];

    NSError *error = nil;
    NSArray *results = [myApp.managedObjectContext executeFetchRequest:request error:&error];
    
    if (results) {
        if ([results count] == 0) {
            return [[Station alloc] initWithEntity:[NSEntityDescription entityForName:@"Station" inManagedObjectContext:myApp.managedObjectContext]
             insertIntoManagedObjectContext:myApp.managedObjectContext];
        }
        else {
            if ([results count] == 1) {
                return [results firstObject];
            }
            else {
                NSLog(@"WOW WOW WOW MORE THAN ONE STATION!!!");
                return nil;
            }
        }
    }
    else {
        NSLog(@"WOW WOW WOW NO RESULTS!!!");
        return nil;
    }
}

+ (NSArray *)fetchStationsWithSortDescriptors:(NSArray *)sortDescriptors andPredicate:(NSPredicate *)predicate {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Station"];
    if (sortDescriptors) {
        request.sortDescriptors = sortDescriptors;
    }
    if (predicate) {
        request.predicate = predicate;
    }
    AppDelegate *myApp = [[UIApplication sharedApplication] delegate];
    NSError *error = nil;

    return [myApp.managedObjectContext executeFetchRequest:request error:&error];
}
@end
