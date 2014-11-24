//
//  Station+AddOn.h
//  VelibApp
//
//  Created by Iman Zarrabian on 24/11/14.
//  Copyright (c) 2014 Iman Zarrabian. All rights reserved.
//

#import "Station.h"

@interface Station (AddOn)

- (void)fillWithHash:(NSDictionary *)station;
+ (NSArray *)fetchStationsWithSortDescriptors:(NSArray *)sortDescriptors andPredicate:(NSPredicate *)predicate;

@end
