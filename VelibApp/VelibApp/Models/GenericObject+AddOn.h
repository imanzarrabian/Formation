//
//  GenericObject+AddOn.h
//  VelibApp
//
//  Created by Iman Zarrabian on 25/11/14.
//  Copyright (c) 2014 Iman Zarrabian. All rights reserved.
//

#import "GenericObject.h"

@interface GenericObject (AddOn)


+ (GenericObject *)createOrGetObjectWithUniqueIdentifier:(NSNumber *)uniqueIdentifier;

@end
