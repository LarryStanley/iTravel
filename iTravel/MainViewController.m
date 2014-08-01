//
//  MainViewController.m
//  iTravel
//
//  Created by LarryStanley on 2014/7/17.
//  Copyright (c) 2014年 LarryStanley. All rights reserved.
//

#import "MainViewController.h"
#import "MapAnnotation.h"

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
    topSearchBar.placeholder = @"搜尋附近地區";
    // Set Search Bar Interface
    UITextField *searchBarTextField = [topSearchBar valueForKey:@"_searchField"];
    searchBarTextField.backgroundColor = [UIColor redColor];
    topSearchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    [mainMap addSubview:topSearchBar];
    
    // Init location manager
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
    
    menuButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 54, self.view.frame.size.height - 54, 44, 44)];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"menuButton.png"] forState:UIControlStateNormal];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"menuButtonSelected.png"] forState:UIControlStateSelected];
    [menuButton addTarget:self action:@selector(menuButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menuButton];
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
        [self changeMapCenter:newLocation.coordinate];
        
        [locationManager stopUpdatingLocation];
        currentLocation = newLocation;
    }
}

#pragma mark - All about map method

- (void)changeMapCenter:(CLLocationCoordinate2D)location
{
    MKCoordinateRegion region;
    region.center.latitude = location.latitude;
    region.center.longitude = location.longitude;
    region.span.latitudeDelta = 0.01;
    region.span.longitudeDelta = 0.01;
    
    [mainMap setRegion:region animated:YES];
}

#pragma mark - All about get data controller delegate

- (void)getDataController:(GetDataController *)controller didFinishReceiveData:(NSDictionary *)receiveData
{
    [mainMap removeAnnotations:mainMap.annotations];
    
    if ([searchType isEqualToString:@"nearby"]) {
        
        NSMutableArray *data = [receiveData objectForKey:@"results"];
        for (int i = 0; i < [data count]; i++) {
            NSDictionary *placeData = [data objectAtIndex:i];
            
            MapAnnotation *mapAnnotation = [[MapAnnotation alloc] init];
            mapAnnotation.title = [placeData objectForKey:@"name"];
            mapAnnotation.subtitle = [placeData objectForKey:@"vicinity"];
            mapAnnotation.coordinate = CLLocationCoordinate2DMake([[[[placeData objectForKey:@"geometry"]
                                                                     objectForKey:@"location"]
                                                                    objectForKey:@"lat"] floatValue],
                                                                  [[[[placeData objectForKey:@"geometry"]
                                                                     objectForKey:@"location"]
                                                                    objectForKey:@"lng"] floatValue]);
            [mainMap addAnnotation:mapAnnotation];
        }
        
    }else{
        searchResults = [receiveData objectForKey:@"results"];
        [searchResultTableView reloadData];
        [self showSearchTableView];
    
        [self.view addSubview:searchResultTableView];
    }
}

#pragma mark - All about UISearchBar delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
    searchResultTableView = [[UITableView alloc] initWithFrame:CGRectMake( 10, 84, 300, self.view.frame.size.height - 84)];
    searchResultTableView.delegate = self;
    searchResultTableView.dataSource = self;
    searchResultTableView.alpha = 0;
    
    searchResults = [[NSMutableArray alloc] init];
    
    if (searchBar.text.length > 0)
        [self showSearchTableView];
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length > 0) {
        GetDataController *getDataController = [[GetDataController alloc] initWithDirectQuery:currentLocation];
        getDataController.delegate = self;
        [getDataController searchFromKeyword:searchText];
    }else{
        [self hideSearchTableView];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    [self hideSearchTableView];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    [self hideSearchTableView];
}

- (void)showSearchTableView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    searchResultTableView.alpha = 1;
    [UIView commitAnimations];
}

- (void)hideSearchTableView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    searchResultTableView.alpha = 0;
    [UIView commitAnimations];
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

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hideSearchTableView];
    [self.view endEditing:YES];
    
    NSDictionary *selectData = [searchResults objectAtIndex:indexPath.row];
    CLLocationCoordinate2D selectCoordinate = CLLocationCoordinate2DMake( [[[[selectData objectForKey:@"geometry"]
                                                                             objectForKey:@"location"]
                                                                            objectForKey:@"lat"] floatValue],
                                                                         [[[[selectData objectForKey:@"geometry"]
                                                                            objectForKey:@"location"]
                                                                           objectForKey:@"lng"] floatValue]);
    [self changeMapCenter:selectCoordinate];
    
    MapAnnotation *mapAnnotation = [[MapAnnotation alloc] init];
    mapAnnotation.title = [selectData objectForKey:@"name"];
    mapAnnotation.subtitle = [selectData objectForKey:@"vicinity"];
    mapAnnotation.coordinate = selectCoordinate;
    [mainMap addAnnotation:mapAnnotation];
    
}

#pragma mark - All about menu button press

- (void)menuButtonPressed
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(showCategoryButton)];
    menuButton.frame = CGRectMake(menuButton.frame.origin.x + 54, menuButton.frame.origin.y, 44, 44);
    [UIView commitAnimations];
}

- (void)showCategoryButton
{
    categoryButtons = [[NSMutableArray alloc] init];
    NSMutableArray *buttonImageName = [[NSMutableArray alloc] initWithObjects:@"restaurantIcon.png", @"coffee.png", nil];
    for (int i = 0; i < 2; i++) {
        UIButton *singleButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width + (i * 54) + 10 , self.view.frame.size.height - 54, 44, 44)];
        [singleButton setBackgroundImage:[UIImage imageNamed:[buttonImageName objectAtIndex:i]] forState:UIControlStateNormal];
        [singleButton addTarget:self action:@selector(showCategoryResult:) forControlEvents:UIControlEventTouchUpInside];
        singleButton.tag = i;
        [categoryButtons addObject:singleButton];
        
        [self.view addSubview:(UIButton *)[categoryButtons objectAtIndex:i]];
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    for (int i = 0; i < 2; i++) {
        UIButton *singleButton = (UIButton *)[categoryButtons objectAtIndex:i];
        singleButton.frame = CGRectMake(10 + i * 54, singleButton.frame.origin.y, 44, 44);
    }
    [UIView commitAnimations];
}

#pragma mark - Show category result

- (void)showCategoryResult:(UIButton *)button
{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    for (int i = 0; i < 2; i++) {
        UIButton *singleButton = (UIButton *)[categoryButtons objectAtIndex:i];
        singleButton.frame = CGRectMake(self.view.frame.size.width + (i * 54) + 10, singleButton.frame.origin.y, 44, 44);
    }
    menuButton.frame = CGRectMake(self.view.frame.size.width - 54, self.view.frame.size.height - 54, 44, 44);
    [UIView commitAnimations];
    
    
    NSMutableArray *categoryType = [[NSMutableArray alloc] initWithObjects:@"food", @"cafe",nil];
    searchType = @"nearby";
    
    GetDataController *getDataController = [[GetDataController alloc] initWithSearchNearby:currentLocation];
    getDataController.delegate = self;
    [getDataController searchNearby:[categoryType objectAtIndex:button.tag]];
}

@end
