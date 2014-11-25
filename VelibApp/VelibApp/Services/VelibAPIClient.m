//
//  VelibAPIClient.m
//  VelibApp
//
//  Created by Iman Zarrabian on 25/11/14.
//  Copyright (c) 2014 Iman Zarrabian. All rights reserved.
//

#import "VelibAPIClient.h"
#import "ServicesDefines.h"

@implementation VelibAPIClient

+ (instancetype)sharedAPIClient {
    static dispatch_once_t pred;
    __strong static VelibAPIClient * sharedAPIClient = nil;
    dispatch_once( &pred, ^{
        sharedAPIClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:API_BASE_URL]];
        
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
            dispatch_async(dispatch_get_main_queue(), ^{
                //INFORM VC
                [[NSNotificationCenter defaultCenter] postNotificationName:REACHABILITY_CHANGED object:nil userInfo:@{@"status":@(status)}];
            });
        }];
        
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    });
    return sharedAPIClient;
}


+ (void)handleError:(NSError *)error withDisplayBlock:(void (^)())displayBlock {
    if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorNotConnectedToInternet) {
        NSLog(@"Internet availability error => Silenced");
    }
    else {
        if (displayBlock) {
            //Always run the display block in the UI queue
            dispatch_async(dispatch_get_main_queue(), ^{
                displayBlock();
            });
        }
    }
}



@end
