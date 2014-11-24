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
#import "Station.h"
#import "StationManager.h"
#import "ServicesDefines.h"
#import "StationService.h"

@interface StationsListViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray *stationArray;

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation StationsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stationsReceived:) name:STATIONS_LIST_RECEIVED object:nil];
}

- (void)stationsReceived:(NSNotification *)notification {
    if (!notification.userInfo[@"error"]) {
        if (notification.userInfo[@"stations_list"]) {
            self.stationArray = notification.userInfo[@"stations_list"];
            NSLog(@"STATION count %ld ",[self.stationArray count]);
        }
    }
    else {
      //Handle error
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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