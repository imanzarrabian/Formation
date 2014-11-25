//
//  StationTableViewCell.h
//  VelibApp
//
//  Created by Iman Zarrabian on 17/11/14.
//  Copyright (c) 2014 Iman Zarrabian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StationTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *stationName;
@property (nonatomic, weak) IBOutlet UILabel *stationNbBikes;
@property (nonatomic, weak) IBOutlet UILabel *stationNbStands;
@property (nonatomic, weak) IBOutlet UIImageView *bikeImage;
@property (nonatomic, weak) IBOutlet UIView *favView;

@end
