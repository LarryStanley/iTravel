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
}

@property (nonatomic, weak) id <GetDataControllerDelegate> delegate;

- (id) init:(CLLocation *)queryLocation;
- (void) getData:(NSURL *)URL;
- (void) searchFromKeyword:(NSString *)keyword;

@end
