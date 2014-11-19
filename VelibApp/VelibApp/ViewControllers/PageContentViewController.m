//
//  PageContentViewController.m
//  VelibApp
//
//  Created by Iman Zarrabian on 17/11/14.
//  Copyright (c) 2014 Iman Zarrabian. All rights reserved.
//

#import "PageContentViewController.h"

@interface PageContentViewController ()
@property (nonatomic, weak) IBOutlet UILabel *mainLabel;
@end

@implementation PageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainLabel.text = self.pageText;
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
