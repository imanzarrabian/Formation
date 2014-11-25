//
//  User.h
//  VelibApp
//
//  Created by Iman Zarrabian on 24/11/14.
//  Copyright (c) 2014 Iman Zarrabian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "GenericObject.h"

@class Station;

@interface User : GenericObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *favoris;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addFavorisObject:(Station *)value;
- (void)removeFavorisObject:(Station *)value;
- (void)addFavoris:(NSSet *)values;
- (void)removeFavoris:(NSSet *)values;

@end
