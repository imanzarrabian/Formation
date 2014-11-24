//
//  Station.h
//  VelibApp
//
//  Created by Iman Zarrabian on 24/11/14.
//  Copyright (c) 2014 Iman Zarrabian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "GenericObject.h"


@interface Station : GenericObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lng;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * nbBikeAvailable;
@property (nonatomic, retain) NSNumber * nbStandAvailable;

@end
