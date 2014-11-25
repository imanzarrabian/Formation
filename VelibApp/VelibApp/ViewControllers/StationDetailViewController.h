//
//  StationDetailViewController.h
//  VelibApp
//
//  Created by Iman Zarrabian on 17/11/14.
//  Copyright (c) 2014 Iman Zarrabian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Station.h"
@class StationDetailViewController;
@protocol StationDetailViewControllerDelegate <NSObject>

- (void)stationDetailViewController:(StationDetailViewController *)stationDetailVC didAddOrRemoveToOrFromFavsStation:(Station *)station;

@end

@interface StationDetailViewController : UIViewController

@property (nonatomic, strong) Station *station;
@property (nonatomic, assign) id <StationDetailViewControllerDelegate> delegate;

@end
