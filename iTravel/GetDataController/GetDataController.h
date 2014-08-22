//
//  GetDataController.h
//  iTravel
//
//  Created by LarryStanley on 2014/7/30.
//  Copyright (c) 2014年 LarryStanley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import <CoreLocation/CoreLocation.h>

@class GetDataController;
@protocol GetDataControllerDelegate <NSObject>

@optional
- (void) getDataController:(GetDataController *)controller didFinishReceiveData:(NSDictionary *)receiveData;

@end

@interface GetDataController : NSObject
{
    NSString *baseURL;
    NSString *serverLocation;
    NSMutableArray *finalData;
}

@property (nonatomic, weak) id <GetDataControllerDelegate> delegate;
@property (nonatomic, strong) NSString *serverLocation;

- (id) initWithDirectQuery:(CLLocation *)queryLocation;
- (id) initWithDirectQueryFromNCU:(CLLocation *)queryLocation;
- (id) initWithSearchNearby:(CLLocation *)queryLocation;
- (id) initWithSearchPlaceDetail:(NSString *)placeID;

- (void) getData:(NSURL *)URL;
- (void) searchFromKeyword:(NSString *)keyword;
- (void) searchFromKeyWordWithNCU:(NSString *)keyword;
- (void) searchNearby:(NSString *)type;
- (void) getPlaceDetail;

@end
