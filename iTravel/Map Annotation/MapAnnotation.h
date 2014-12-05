//
//  MapAnnotation.h
//  iTravel
//
//  Created by LarryStanley on 2014/8/1.
//  Copyright (c) 2014年 LarryStanley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject <MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
    NSDictionary *data;
    int tag;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSDictionary *data;
@property int tag;

@end
