//
//  StationService.m
//  VelibApp
//
//  Created by Iman Zarrabian on 19/11/14.
//  Copyright (c) 2014 Iman Zarrabian. All rights reserved.
//

#import "StationService.h"
#import "Station.h"
#import "ServicesDefines.h"
#import "Station+AddOn.h"
#import "AppDelegate.h"

@implementation StationService

- (void)getStationsFromAPI {
    NSString *stationsListURL = [NSString stringWithFormat:@"%@/vls/v1/stations?contract=%@&apiKey=%@", API_BASE_URL, API_CONTRACT_NAME, API_KEY];
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:stationsListURL]
                                        completionHandler:^(NSData *data,
                                                            NSURLResponse *response,
                                                            NSError *error) {
                                            [self handleGetStationReturn:data];
                                        }];
    [task resume];
}



#pragma mark - private helper methods
- (NSArray *)buildStationsListFromJSONData:(NSData*)data {
    NSArray *stationsArrayFromJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    if (!stationsArrayFromJSON) {
        [NSException raise:@"JSON parsing error" format:@"Impossible to parse %@", data.description];
    }
    
    if ([stationsArrayFromJSON isKindOfClass:[NSArray class]]) {
        NSMutableArray *stations = [[NSMutableArray alloc] init];
        
        AppDelegate *myApp = [[UIApplication sharedApplication] delegate];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Station" inManagedObjectContext:myApp.managedObjectContext];

        dispatch_sync(dispatch_get_main_queue(), ^{
            for (NSDictionary * station in stationsArrayFromJSON) {

                Station *newStation =  [[Station alloc] initWithEntity:entity
                                        insertIntoManagedObjectContext:myApp.managedObjectContext];
                
                [newStation fillWithHash:station];
            }
            [myApp saveContext];
        });

        return stations;
    }
    return nil;
}


- (void)handleGetStationReturn:(NSData *)data {
    // init content
    NSArray *stations = [self buildStationsListFromJSONData:data];
    if (stations) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //INFORM VC
            [[NSNotificationCenter defaultCenter] postNotificationName:STATIONS_LIST_RECEIVED object:nil userInfo:nil];
        });
    }
    else {
        //INFORM VC FOR SPECIAL BEHAVIOUR
        //INFORM VC
        [[NSNotificationCenter defaultCenter] postNotificationName:STATIONS_LIST_RECEIVED object:nil userInfo:@{@"error":@"TO BE HANDLED!!"}];
    }
}




@end
