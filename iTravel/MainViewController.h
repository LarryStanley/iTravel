//
//  MainViewController.h
//  iTravel
//
//  Created by LarryStanley on 2014/7/17.
//  Copyright (c) 2014年 LarryStanley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "GetDataController.h"

@interface MainViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, GetDataControllerDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSString *searchType;
    
    MKMapView *mainMap;
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    UISearchBar *topSearchBar;
    
    UITableView *searchResultTableView;
    NSMutableArray *searchResults;
    
    UIButton *menuButton;
    NSMutableArray *categoryButtons;
}

- (void)changeMapCenter:(CLLocationCoordinate2D)location;

- (void)showSearchTableView;
- (void)hideSearchTableView;

- (void)showCategoryButton;
- (void)menuButtonPressed;

- (void)showCategoryResult:(UIButton *)button;

@end
