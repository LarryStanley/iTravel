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
    }
    NSLog(@"%f %f",newLocation.coordinate.latitude, newLocation.coordinate.longitude);
}

@end
