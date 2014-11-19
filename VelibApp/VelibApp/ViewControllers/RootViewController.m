//
//  RootViewController.m
//  VelibApp
//
//  Created by Rémi T'JAMPENS on 19/11/2014.
//  Copyright (c) 2014 Iman Zarrabian. All rights reserved.
//

#import "RootViewController.h"
#import "MentionsLegalesContentViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageTitles = @[@"Les étoiles", @"Beautiful Old Montreal"];
    self.pageImages = @[@"back", @"montreal"];
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    MentionsLegalesContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((MentionsLegalesContentViewController *) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((MentionsLegalesContentViewController *) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (MentionsLegalesContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    MentionsLegalesContentViewController *mentionsLegalesContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    mentionsLegalesContentViewController.imageFile = self.pageImages[index];
    NSLog(@"%@", self.pageImages[index]);
    mentionsLegalesContentViewController.titleText = self.pageTitles[index];
    mentionsLegalesContentViewController.pageIndex = index;
    
    return mentionsLegalesContentViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
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
