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

@interface MainViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>
{
    MKMapView *mainMap;
    CLLocationManager *locationManager;
}
@end
