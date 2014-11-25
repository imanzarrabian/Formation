//
//  ViewController.m
//  VelibApp
//
//  Created by Iman Zarrabian on 17/11/14.
//  Copyright (c) 2014 Iman Zarrabian. All rights reserved.
//

#import "StationsListViewController.h"
#import "StationDetailViewController.h"
#import "StationTableViewCell.h"
#import "Station+AddOn.h"
#import "ServicesDefines.h"
#import "StationService.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"

@interface StationsListViewController () <UITableViewDataSource,UITableViewDelegate,StationDetailViewControllerDelegate>
@property (nonatomic, strong) NSArray *stationArray;

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSURLSessionDataTask *currentTask;

@end

@implementation StationsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stationsReceived:) name:STATIONS_LIST_RECEIVED object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:REACHABILITY_CHANGED object:nil];

    [self reloadRemoteData];
    [self reloadLocalDataAndReloadView];
    
    [self createPullToRefreshControl];
}

- (void)stationsReceived:(NSNotification *)notification {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.refreshControl endRefreshing];
    });
    
    [self reloadLocalDataAndReloadView];
}


- (void)reachabilityChanged:(NSNotification *)notification {
    NSString *message = [NSString stringWithFormat:@"%ld",[notification.userInfo[@"status"] integerValue]];
   /* UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"CHANGED" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];*/
}

- (void)createPullToRefreshControl {
    UITableViewController *tableVC = [[UITableViewController alloc] init];
    tableVC.tableView = self.tableView;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull To Refresh"];
    [self.refreshControl addTarget:self action:@selector(reloadRemoteData) forControlEvents:UIControlEventValueChanged];
    tableVC.refreshControl = self.refreshControl;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self.tableView reloadData];
}

- (void)reloadLocalDataAndReloadView {
    //Sorting
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
   
    //Adding predicate to filter data on name containing 'Alexandre'
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[c] %@",@"Alexandre"];
    
    self.stationArray = [Station fetchStationsWithSortDescriptors:@[sortDescriptor] andPredicate:nil];
    
    [self.tableView reloadData];
}

- (void)reloadRemoteData {
    if (self.currentTask.state == NSURLSessionTaskStateRunning) {
        [self.currentTask cancel];
    }
    self.currentTask = [[[StationService alloc] init] getStationsFromAPI];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.stationArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StationTableViewCell *cell = (StationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"stationCell" forIndexPath:indexPath];
    Station *currentStation = self.stationArray[indexPath.row];
    
    //AppDelegate *myApp = [[UIApplication sharedApplication] delegate];
    //[myApp.managedObjectContext refreshObject:currentStation mergeChanges:YES];
    
    cell.stationName.text = currentStation.name;


    
    cell.stationNbBikes.text = [NSString stringWithFormat:@"%ld bikes available",[currentStation.nbBikeAvailable integerValue]];
    
    cell.stationNbStands.text = [NSString stringWithFormat:@"%ld stands available",[currentStation.nbStandAvailable integerValue]];
    
    NSURL *urlImage = [NSURL URLWithString:@"http://img0.gtsstatic.com/wallpapers/aa7f4b52bbf9277c032e91be4ca5ed1b_large.jpeg"];
      [cell.bikeImage sd_setImageWithURL:urlImage
                        placeholderImage:[UIImage imageNamed:@"image_large"]];
    
    if (currentStation.user) {
        cell.favView.hidden = NO;
    }
    else {
        cell.favView.hidden = YES;
    }
    
    //completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                          [UIView animateWithDuration:0.4 animations:^{
//                              cell.bikeImage.alpha = 0.0;
//                              cell.bikeImage.alpha = 1.0;
//                          } completion:^(BOOL finished) {
//                              
//                          }];
                     //}];

    return cell;
}

#pragma mark - UITableViewDelegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detailSegue"]) {
        if ([sender isKindOfClass:[UITableViewCell class]]) {
            if ([segue.destinationViewController isKindOfClass:[StationDetailViewController class]]) {
                StationDetailViewController *stationDetailVC = (StationDetailViewController *)segue.destinationViewController;
                stationDetailVC.delegate = self;
                UITableViewCell *selectedCell = (UITableViewCell *)sender;
                NSIndexPath *indexPath = [self.tableView indexPathForCell:selectedCell];
                stationDetailVC.station = self.stationArray[indexPath.row];
            }
        }
    }
}

#pragma mark - StationDetailViewControllerDelegate methods
- (void)stationDetailViewController:(StationDetailViewController *)stationDetailVC didAddOrRemoveToOrFromFavsStation:(Station *)station {
    NSInteger indexOfStation = [self.stationArray indexOfObject:station];
    NSIndexPath *indexPath;
    if (indexOfStation != NSNotFound) {
        indexPath = [NSIndexPath indexPathForRow:indexOfStation inSection:0];
    }

    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];

}

@end