//
//  MentionsLegalesContentViewController.h
//  VelibApp
//
//  Created by Rémi T'JAMPENS on 19/11/2014.
//  Copyright (c) 2014 Iman Zarrabian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MentionsLegalesContentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic,strong) NSString *titleText;
@property (nonatomic,strong) NSString *imageFile;
@property (nonatomic,assign) NSUInteger pageIndex;

@end
