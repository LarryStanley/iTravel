//
//  MainViewController.m
//  iTravel
//
//  Created by LarryStanley on 2014/7/17.
//  Copyright (c) 2014年 LarryStanley. All rights reserved.
//

#import "MainViewController.h"
#import "MapAnnotation.h"
#import "PlaceDetailViewController.h"

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
    [topSearchBar setBarTintColor:[UIColor colorWithRed:47/255.f green:52/255.f blue:60/255.f alpha:1]];
    for (UIView *subView in topSearchBar.subviews) {
        for (UIView *subSubView in subView.subviews) {
            if ([subSubView isKindOfClass:[UITextField class]]) {
                UITextField *textField = (UITextField *)subSubView;
                textField.backgroundColor = [UIColor clearColor];
                textField.textColor = [UIColor whiteColor];
                break;
            }
            
        }
    }

    // Init current location button
    currentLocationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [currentLocationButton setBackgroundImage:[UIImage imageNamed:@"currentLocationButton.png"]
                                     forState:UIControlStateNormal];
    currentLocationButton.frame = CGRectMake(10, self.view.frame.size.height - 40, 30, 30);
    [currentLocationButton addTarget:self
                              action:@selector(showCurrentLocation)
                    forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:currentLocationButton];
    
    
    [self.view addSubview:topSearchBar];
    
    // Init location manager
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
}

- (void)viewDidAppear:(BOOL)animated
{
    [topSearchBar removeFromSuperview];
    
    topSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 30, 300, 44)];
    topSearchBar.delegate = self;
    topSearchBar.placeholder = @"搜尋附近地區";
    // Set Search Bar Interface
    [topSearchBar setBarTintColor:[UIColor colorWithRed:47/255.f green:52/255.f blue:60/255.f alpha:1]];
    for (UIView *subView in topSearchBar.subviews) {
        for (UIView *subSubView in subView.subviews) {
            if ([subSubView isKindOfClass:[UITextField class]]) {
                UITextField *textField = (UITextField *)subSubView;
                textField.backgroundColor = [UIColor clearColor];
                textField.textColor = [UIColor whiteColor];
                break;
            }
            
        }
    }

    [self.view addSubview:topSearchBar];
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
    currentLocation = [[CLLocation alloc] initWithLatitude:25.052027 longitude:121.539594];
    [self changeMapCenter:currentLocation.coordinate];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (newLocation != oldLocation) {
        if (!currentLocation)
            [self changeMapCenter:newLocation.coordinate];
        NSLog(@"yes");
        //[locationManager stopUpdatingLocation];
        currentLocation = newLocation;
    }
}

- (void)showCurrentLocation
{
    [self changeMapCenter:currentLocation.coordinate];
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

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (![annotation isKindOfClass:[MKUserLocation class]]) {
        MKPinAnnotationView *newAnnotation;
        newAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                        reuseIdentifier:@"pinLocation"];
        newAnnotation.canShowCallout = YES;
        newAnnotation.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        return newAnnotation;
    } else {
        return nil;
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    MapAnnotation *mapAnnotation = view.annotation;
    PlaceDetailViewController *placeDetailViewController = [[PlaceDetailViewController alloc] init];
    placeDetailViewController.title = view.annotation.title;
    placeDetailViewController.placeData = [searchResults objectAtIndex:mapAnnotation.tag];
    [self.navigationController pushViewController:placeDetailViewController animated:YES];
}

#pragma mark - All about get data controller delegate

- (void)getDataController:(GetDataController *)controller didFinishReceiveData:(NSDictionary *)receiveData
{
    [mainMap removeAnnotations:mainMap.annotations];
    if ([searchType isEqualToString:@"nearby"]) {
        
        searchResults = [receiveData objectForKey:@"results"];
        for (int i = 0; i < [searchResults count]; i++) {
            NSDictionary *placeData = [searchResults objectAtIndex:i];
            
            MapAnnotation *mapAnnotation = [[MapAnnotation alloc] init];
            mapAnnotation.title = [placeData objectForKey:@"name"];
            mapAnnotation.subtitle = [placeData objectForKey:@"vicinity"];
            mapAnnotation.tag = i;
            mapAnnotation.coordinate = CLLocationCoordinate2DMake([[[[placeData objectForKey:@"geometry"]
                                                                     objectForKey:@"location"]
                                                                    objectForKey:@"lat"] floatValue],
                                                                  [[[[placeData objectForKey:@"geometry"]
                                                                     objectForKey:@"location"]
                                                                    objectForKey:@"lng"] floatValue]);
            [mainMap addAnnotation:mapAnnotation];
            
            if (!showAllNearbyButton){
                showAllNearbyButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 84, 300, 44)];
                showAllNearbyButton.backgroundColor = [UIColor colorWithRed:47/255.f green:52/255.f blue:60/255.f alpha:1];
                [showAllNearbyButton setTitle:@"列出所有結果" forState:UIControlStateNormal];
                [showAllNearbyButton addTarget:self action:@selector(showAllResultFromNearby) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:showAllNearbyButton];
            } else {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.2];
                showAllNearbyButton.alpha = 1;
                [UIView commitAnimations];
            }
            
            
            /*[nearbyIllustratorView removeFromSuperview];
            nearbyIllustratorView = [[UIView alloc] initWithFrame:CGRectMake(50, self.view.frame.size.height - 64, self.view.frame.size.width - 100, 54)];
            nearbyIllustratorView.backgroundColor = [UIColor colorWithRed:47/255.f green:52/255.f blue:60/255.f alpha:1];
            nearbyIllustratorView.alpha = 0;
            
            UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 220 * [searchResults count], 54)];
            [scrollView setPagingEnabled:YES];
            [scrollView setShowsHorizontalScrollIndicator:NO];
            [scrollView setShowsVerticalScrollIndicator:NO];
            [scrollView setScrollsToTop:NO];
            [scrollView setDelegate:self];
            
            
            
            UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 24, 220, 30)];
            [pageControl setNumberOfPages:[searchResults count]];
            [pageControl setCurrentPage:0];
            
            [self.view addSubview:nearbyIllustratorView];
            [nearbyIllustratorView addSubview:scrollView];
            [nearbyIllustratorView addSubview:pageControl];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.2];
            nearbyIllustratorView.alpha = 1;
            [UIView commitAnimations];*/
            
        }
        
    }else{
        if ([controller.serverLocation isEqualToString:@"NCU"]) {
            NSMutableArray *allData = [receiveData objectForKey:@"response"];
            for (int i = 0 ; i < [allData count]; i++) {
                NSDictionary *tempData = [allData objectAtIndex:i];
                NSMutableDictionary *placeData = [[NSMutableDictionary alloc] init];
                [placeData setObject:[tempData objectForKey:@"title"] forKey:@"name"];
                [placeData setObject:[tempData objectForKey:@"address"] forKey:@"vicinity"];
                [placeData setObject:[[NSDictionary alloc] initWithObjectsAndKeys:[tempData objectForKey:@"longitude"], @"lng", @"latitude", @"lat",nil]
                              forKey:@"geometry"];
                
                [searchResults addObject:placeData];
            }
        }else{
            
            searchResults = [receiveData objectForKey:@"GoogleMapSuggestion"];
            NSLog(@"%@",searchResults);
            
            /*GetDataController *getDataController = [[GetDataController alloc] initWithDirectQueryFromNCU:currentLocation];
            getDataController.delegate = self;
            [getDataController searchFromKeyWordWithNCU:topSearchBar.text];*/
            
            if (![searchResults count]) {
                searchResults = [[NSMutableArray alloc] initWithObjects:[[NSDictionary alloc] initWithObjectsAndKeys:@"查無資料，新增地點", @"name",nil], nil];
            }
            
            [searchResultTableView reloadData];
            [self showSearchTableView];
            
            [self.view addSubview:searchResultTableView];
    
        }
    }
}

- (void)showAllResultFromNearby
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    showAllNearbyButton.alpha  = 0;
    [UIView commitAnimations];
    
    [searchResultTableView reloadData];
    [self showSearchTableView];
    
    [self.view addSubview:searchResultTableView];
}

#pragma mark - All about UISearchBar delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    for (UIView *subView in searchBar.subviews) {
        for (UIView *subSubView in subView.subviews) {
            if ([subSubView isKindOfClass:[UIButton class]]) {
                UIButton *cancelButton = (UIButton *)subView;
                cancelButton.tintColor = [UIColor colorWithRed:231/255.f green:64/255.f blue:72/255.f alpha:1];
                break;
            }
        }
    }

    searchResultTableView = [[UITableView alloc] initWithFrame:CGRectMake( 10, 84, 300, self.view.frame.size.height - 94)];
    searchResultTableView.delegate = self;
    searchResultTableView.dataSource = self;
    searchResultTableView.alpha = 0;
    
    searchResultTableView.backgroundColor = [UIColor colorWithRed:47/255.f green:52/255.f blue:60/255.f alpha:1];
    searchResultTableView.separatorColor = [UIColor colorWithRed:60/255.f green:67/255.f blue:77/255.f alpha:1];
    
    searchResults = [[NSMutableArray alloc] init];
    
    if (searchBar.text.length > 0){
        [self showSearchTableView];
        [self dismissCategoryView];
    }else
        [self showCategoryView];
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    searchType = @"directly";
    
    if (searchText.length > 0) {
        GetDataController *getDataController = [[GetDataController alloc] initWithAutocomplete:currentLocation];
        [getDataController SearchWithAutoComplete:searchText];
        getDataController.delegate = self;
        
        [self dismissCategoryView];
    }else{
        [self hideSearchTableView];
        [self showCategoryView];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    [self hideSearchTableView];
    [self dismissCategoryView];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    [self hideSearchTableView];
    [self dismissCategoryView];
}

- (void)showSearchTableView
{
    if ([searchResults count] * 44 > self.view.frame.size.height - 94)
        searchResultTableView.frame = CGRectMake(10, 84, 300, self.view.frame.size.height - 94);
    else
        searchResultTableView.frame = CGRectMake(10, 84, 300, 44*[searchResults count]);
    
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

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
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
    cell.textLabel.text = [searchResults objectAtIndex:indexPath.row];
    //cell.detailTextLabel.text = [[searchResults objectAtIndex:indexPath.row] objectForKey:@"formatted_address"];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:34/255.f green:153/255.f blue:240/255.f alpha:1];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
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
    mapAnnotation.tag = (int)indexPath.row;
    [mainMap addAnnotation:mapAnnotation];
    
}

#pragma mark - All about category view

- (void)showCategoryView
{
    if (!categoryView) {
        
        categoryView = [[UIView alloc] initWithFrame:CGRectMake(10, 84, 300, 60)];
        categoryView.backgroundColor = [UIColor colorWithRed:47/255.f green:52/255.f blue:60/255.f alpha:1];
        categoryView.alpha = 0;
        [self.view addSubview:categoryView];
        
        // Set scroll view
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 300, 60)];
        [categoryView addSubview:scrollView];
        
        NSArray *categoryName = @[@"餐廳", @"咖啡廳", @"加油站", @"麵包店", @"電影院",@"ATM提款機"];
        float lastButtonPosition = 0;
        for (int i = 0; i < [categoryName count]; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [button setTag:i];
            [button addTarget:self action:@selector(categoryButtonPress:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:[categoryName objectAtIndex:i] forState:UIControlStateNormal];
            [button sizeToFit];
            button.tintColor = [UIColor whiteColor];
            button.frame = CGRectMake(lastButtonPosition + 20, 0, button.frame.size.width, 60);
            [scrollView addSubview:button];
            
            lastButtonPosition = button.frame.origin.x + button.frame.size.width;
        }
        
        scrollView.contentSize = CGSizeMake(lastButtonPosition + 20, 60);
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    categoryView.alpha = 1;
    showAllNearbyButton.alpha  = 0;
    [UIView commitAnimations];
}

- (void)dismissCategoryView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    categoryView.alpha = 0;
    [UIView commitAnimations];
}


#pragma mark - Show category result

- (void)categoryButtonPress:(UIButton *)button;
{
    //[self.view endEditing:YES];
    [self dismissCategoryView];
    [self.view endEditing:YES];

    NSMutableArray *categoryType = [[NSMutableArray alloc] initWithObjects:@"food", @"cafe", @"gas_station", @"bakery", @"movie_theater",@"atm",nil];
    searchType = @"nearby";
    
    GetDataController *getDataController = [[GetDataController alloc] initWithSearchNearby:currentLocation];
    getDataController.delegate = self;
    [getDataController searchNearby:[categoryType objectAtIndex:button.tag]];
}

@end
