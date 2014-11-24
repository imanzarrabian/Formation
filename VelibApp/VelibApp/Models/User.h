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


@interface User : GenericObject

@property (nonatomic, retain) NSString * email;

@end
