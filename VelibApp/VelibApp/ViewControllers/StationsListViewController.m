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
#import "StationManager.h"
#import "ServicesDefines.h"
#import "StationService.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"

@interface StationsListViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray *stationArray;

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation StationsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stationsReceived:) name:STATIONS_LIST_RECEIVED object:nil];

    [self createPullToRefreshControl];
}

- (void)stationsReceived:(NSNotification *)notification {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.refreshControl endRefreshing];
    });
    
    /*if (!notification.userInfo[@"error"]) {
        if (notification.userInfo[@"stations_list"]) {
     
            self.stationArray = notification.userInfo[@"stations_list"];
            NSLog(@"STATION count %ld ",[self.stationArray count]);
        }
    }
    else {
      //Handle error
    }*/
    
    [self reloadLocalDataAndReloadView];
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
    [self reloadRemoteData];
    [self reloadLocalDataAndReloadView];
}

- (void)reloadLocalDataAndReloadView {
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    self.stationArray = [Station fetchStationsWithSortDescriptors:@[sortDescriptor]];
    
    [self.tableView reloadData];
}

- (void)reloadRemoteData {
    [[[StationService alloc] init] getStationsFromAPI];
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
    
    cell.stationName.text = currentStation.name;
    
    cell.stationNbBikes.text = [NSString stringWithFormat:@"%ld bikes available",[currentStation.nbBikeAvailable integerValue]];
    
    cell.stationNbStands.text = [NSString stringWithFormat:@"%ld stands available",[currentStation.nbStandAvailable integerValue]];
    
    NSURL *urlImage = [NSURL URLWithString:@"http://img0.gtsstatic.com/wallpapers/aa7f4b52bbf9277c032e91be4ca5ed1b_large.jpeg"];
      [cell.bikeImage sd_setImageWithURL:urlImage
                        placeholderImage:[UIImage imageNamed:@"image_large"]];
    
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
                
                UITableViewCell *selectedCell = (UITableViewCell *)sender;
                NSIndexPath *indexPath = [self.tableView indexPathForCell:selectedCell];
                stationDetailVC.station = self.stationArray[indexPath.row];
            }
        }
    }
}

@end