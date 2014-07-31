//
//  MainViewController.m
//  iTravel
//
//  Created by LarryStanley on 2014/7/17.
//  Copyright (c) 2014年 LarryStanley. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Init map view
    mainMap = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mainMap.delegate = self;
    mainMap.showsUserLocation = YES;
    [self.view addSubview:mainMap];
    
    // Init Search Bar
    topSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 30, 300, 44)];
    topSearchBar.delegate = self;
    
    [mainMap addSubview:topSearchBar];
    
    // Init location manager
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"No singal");
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (newLocation != oldLocation) {
        MKCoordinateRegion region;
        region.center.latitude = newLocation.coordinate.latitude;
        region.center.longitude = newLocation.coordinate.longitude;
        region.span.latitudeDelta = 0.001;
        region.span.longitudeDelta = 0.001;
        
        [mainMap setRegion:region animated:YES];
        [locationManager stopUpdatingLocation];
        currentLocation = newLocation;
    }
}

#pragma mark - All about get data controller delegate

- (void)getDataController:(GetDataController *)controller didFinishReceiveData:(NSDictionary *)receiveData
{
    searchResults = [receiveData objectForKey:@"results"];
    [searchResultTableView reloadData];
    [self.view addSubview:searchResultTableView];
}

#pragma mark - All about UISearchBar delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
    searchResultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 84, self.view.frame.size.width, self.view.frame.size.height - 84)];
    searchResultTableView.delegate = self;
    searchResultTableView.dataSource = self;
    searchResults = [[NSMutableArray alloc] init];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length > 0) {
        GetDataController *getDataController = [[GetDataController alloc] init:currentLocation];
        getDataController.delegate = self;
        [getDataController searchFromKeyword:searchText];
    }else{
        [searchResultTableView removeFromSuperview];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - All about search table view delegate and datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [[searchResults objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    return cell;
}


@end
