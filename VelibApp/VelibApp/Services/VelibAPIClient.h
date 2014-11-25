//
//  VelibAPIClient.h
//  VelibApp
//
//  Created by Iman Zarrabian on 25/11/14.
//  Copyright (c) 2014 Iman Zarrabian. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface VelibAPIClient : AFHTTPSessionManager

+ (instancetype)sharedAPIClient;
+ (void)handleError:(NSError *)error withDisplayBlock:(void (^)())displayBlock;
@end
