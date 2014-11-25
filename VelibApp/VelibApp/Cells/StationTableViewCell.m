//
//  StationTableViewCell.m
//  VelibApp
//
//  Created by Iman Zarrabian on 17/11/14.
//  Copyright (c) 2014 Iman Zarrabian. All rights reserved.
//

#import "StationTableViewCell.h"

@implementation StationTableViewCell

- (void)awakeFromNib {
    self.bikeImage.layer.borderWidth = 1.0;
    self.bikeImage.layer.borderColor = [UIColor blueColor].CGColor;
    self.bikeImage.layer.cornerRadius = 5.0;
}

- (void)prepareForReuse {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
