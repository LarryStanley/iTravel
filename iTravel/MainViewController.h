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

@interface MainViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, GetDataControllerDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
{
    NSString *searchType;
    
    MKMapView *mainMap;
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    UISearchBar *topSearchBar;
    
    UITableView *searchResultTableView;
    NSMutableArray *searchResults;
    NSMutableArray *searchResultsReference;
    NSMutableArray *favoriteData;
    
    UIView *categoryView;
    
    UIButton *currentLocationButton;
    UIButton *showAllNearbyButton;
    
    UIView *nearbyIllustratorView;
    
    UIView *placeDetailView;
}
@property (strong, nonatomic) IBOutlet MKMapView *mainMap;

- (void)showCurrentLocation;

- (void)changeMapCenter:(CLLocationCoordinate2D)location;

- (void)showSearchTableView;
- (void)hideSearchTableView;

- (void)showCategoryView;
- (void)dismissCategoryView;

- (void)showFavoriteView;

- (void)showAllResultFromNearby;

- (void)categoryButtonPress:(UIButton *)button;

@end
