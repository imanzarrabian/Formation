//
//  CameraVC.m
//  CameraTest
//
//  Created by Iman Zarrabian on 26/11/14.
//  Copyright (c) 2014 Iman Zarrabian. All rights reserved.
//

#import "CameraVC.h"
@interface CameraVC()
@property (nonatomic, weak) IBOutlet UIView *cameraVew;
@end

@implementation CameraVC


- (IBAction)dismissVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
