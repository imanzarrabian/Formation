//
//  GenericObject+AddOn.m
//  VelibApp
//
//  Created by Iman Zarrabian on 25/11/14.
//  Copyright (c) 2014 Iman Zarrabian. All rights reserved.
//

#import "GenericObject+AddOn.h"
#import "AppDelegate.h"
@implementation GenericObject (AddOn)

+ (GenericObject *)createOrGetObjectWithUniqueIdentifier:(NSNumber *)uniqueIdentifier {
    NSString *className = NSStringFromClass(self);
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:className];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"unique_id == %@",uniqueIdentifier];
    request.predicate = predicate;
    AppDelegate *myApp = [[UIApplication sharedApplication] delegate];
    
    NSError *error = nil;
    NSArray *results = [myApp.managedObjectContext executeFetchRequest:request error:&error];
    
    if (results) {
        if ([results count] == 0) {
            GenericObject *go = [[self alloc] initWithEntity:[NSEntityDescription entityForName:className inManagedObjectContext:myApp.managedObjectContext]
                              insertIntoManagedObjectContext:myApp.managedObjectContext];
            
            go.unique_id = uniqueIdentifier;
            return go;
        }
        if ([results count] == 1) {
            return [results firstObject];
        }
        NSLog(@"WOW WOW WOW MORE THAN ONE STATION!!!");
        return nil;
    }
    NSLog(@"WOW WOW WOW NO RESULTS!!!");
    return nil;
}

@end
