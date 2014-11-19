//
//  MentionsLegalesContentViewController.m
//  VelibApp
//
//  Created by Rémi T'JAMPENS on 19/11/2014.
//  Copyright (c) 2014 Iman Zarrabian. All rights reserved.
//

#import "MentionsLegalesContentViewController.h"

@interface MentionsLegalesContentViewController ()

@end

@implementation MentionsLegalesContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.image = [UIImage imageNamed:self.imageFile];
    NSLog(@"******** %@ *********", self.imageFile);
    self.titleLabel.text = self.titleText;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
