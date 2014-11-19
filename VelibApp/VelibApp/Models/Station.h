//
//  Station.h
//  VelibApp
//
//  Created by Iman Zarrabian on 18/11/14.
//  Copyright (c) 2014 Iman Zarrabian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Station : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSNumber *lat;
@property (nonatomic, strong) NSNumber *lng;
@property (nonatomic, strong) NSNumber *nbBikeAvailable;
@property (nonatomic, strong) NSNumber *nbStandAvailable;


- (void)fillWithHash:(NSDictionary *)station;

@end
