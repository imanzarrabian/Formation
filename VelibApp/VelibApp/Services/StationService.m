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
#import "GenericObject+AddOn.h"
#import "VelibAPIClient.h"

@implementation StationService

- (NSURLSessionDataTask *)getStationsFromAPI {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSDictionary *params = @{@"contract":API_CONTRACT_NAME,@"apiKey":API_KEY};
    
    return [[VelibAPIClient sharedAPIClient] GET:@"/vls/v1/stations" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {

        [self handleGetStationReturn:responseObject];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"WE FAILLED %@",error);
        [VelibAPIClient handleError:error withDisplayBlock:^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ooops" message:@"AIEEE" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
        }];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

        [[NSNotificationCenter defaultCenter] postNotificationName:STATIONS_LIST_RECEIVED object:nil userInfo:@{@"error":@"TO BE HANDLED!!"}];
    }];
}



#pragma mark - private helper methods
- (NSArray *)buildStationsListFromJSONData:(id)stationsArrayFromJSON {
    
    if ([stationsArrayFromJSON isKindOfClass:[NSArray class]]) {
        NSMutableArray *stations = [[NSMutableArray alloc] init];
        
        AppDelegate *myApp = [[UIApplication sharedApplication] delegate];
        for (NSDictionary * station in stationsArrayFromJSON) {
            //Creating station or getting an existing one
            Station *newStation = (Station *)[Station createOrGetObjectWithUniqueIdentifier:station[@"number"]];
            
            //updating station data in all cases
            [newStation fillWithHash:station];
        }
        
        //Finally saving context after the for loop
        [myApp saveContext];
        
        return stations;
    }
    return nil;
}


- (void)handleGetStationReturn:(id)data {
    // init content
    NSArray *stations = [self buildStationsListFromJSONData:data];
    if (stations) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //INFORM VC
            [[NSNotificationCenter defaultCenter] postNotificationName:STATIONS_LIST_RECEIVED object:nil userInfo:nil];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
    }
    else {
        //INFORM VC FOR SPECIAL BEHAVIOUR
        //INFORM VC
        [[NSNotificationCenter defaultCenter] postNotificationName:STATIONS_LIST_RECEIVED object:nil userInfo:@{@"error":@"TO BE HANDLED!!"}];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    }
}




@end
