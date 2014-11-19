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

#define API_KEY @"cd982b2f6008d5560b48a2d31cb6d3ad44f11fca"
#define API_BASE_URL @"https://api.jcdecaux.com"
#define API_CONTRACT_NAME @"paris"

@interface StationsListViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *stationArray;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation StationsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // API call
    [self getStationsFromAPI];
    
    [self createFakeData];
}

- (void)createFakeData {
    for (NSInteger i=0; i<10; i++) {
        Station *station = [[Station alloc] init];
        station.name = [NSString stringWithFormat:@"STATION %ld",i];
        station.nbBikeAvailable = @(i+2);
        station.nbStandAvailable = @(i*3);
        [self.stationArray addObject:station];
        station.lat = @(50.63);
        station.lng = @(3.02);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


#pragma mark - Lazy loader
- (NSMutableArray *)stationArray {
    if (!_stationArray) {
        _stationArray = [NSMutableArray new];
    }
    return _stationArray;
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

- (void)getStationsFromAPI {
    NSString *stationsListURL = [NSString stringWithFormat:@"%@/vls/v1/stations?contrat=%@&apiKey=%@", API_BASE_URL, API_CONTRACT_NAME, API_KEY];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:stationsListURL]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                // handle response
                NSLog(@"%@", data);
            }] resume];
}


@end