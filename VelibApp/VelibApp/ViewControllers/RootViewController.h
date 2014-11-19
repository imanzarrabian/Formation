//
//  RootViewController.h
//  VelibApp
//
//  Created by Rémi T'JAMPENS on 19/11/2014.
//  Copyright (c) 2014 Iman Zarrabian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;

@end
