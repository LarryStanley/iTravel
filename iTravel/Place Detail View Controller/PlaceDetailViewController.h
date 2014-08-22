//
//  PlaceDetailViewController.h
//  iTravel
//
//  Created by LarryStanley on 2014/8/15.
//  Copyright (c) 2014年 LarryStanley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GetDataController.h"

@interface PlaceDetailViewController : UIViewController <MKMapViewDelegate, GetDataControllerDelegate>
{
    MKMapView *topMapView;
    NSMutableDictionary *placeData, *detailData;
    CLLocationCoordinate2D placeCoordinate;
}

@property (nonatomic, strong) NSDictionary *placeData;

- (void)buttonPressed:(UIButton *)button;

@end
