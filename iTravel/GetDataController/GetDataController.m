//
//  GetDataController.m
//  iTravel
//
//  Created by LarryStanley on 2014/7/30.
//  Copyright (c) 2014年 LarryStanley. All rights reserved.
//

#import "GetDataController.h"

@implementation GetDataController
@synthesize serverLocation;

- (id)initWithDirectQuery:(CLLocation *)queryLocation {
    self = [super init];
    if (self) {
        baseURL = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?key=AIzaSyC19nuMyJzGByx56Fsw-LQmOUSyjCVnBnI&sensor=true&location=%f,%f&radius=1000",queryLocation.coordinate.latitude, queryLocation.coordinate.longitude];
        serverLocation  = @"google";
    }
    return self;
}

- (id)initWithDirectQueryFromNCU:(CLLocation *)queryLocation
{
    self = [super init];
    if (self) {
        baseURL = [NSString stringWithFormat:@"http://140.115.156.64:8983/solr/collection1/select?&wt=json&indent=true&pt=%f,%f&d=1&sfield=store&sort=geodist()%%20asc",queryLocation.coordinate.latitude, queryLocation.coordinate.longitude];
        serverLocation = @"NCU";
    }
    return self;

}

- (id)initWithSearchNearby:(CLLocation *)queryLocation
{
    self = [super init];
    if (self) {
        baseURL = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?key=AIzaSyC19nuMyJzGByx56Fsw-LQmOUSyjCVnBnI&sensor=true&location=%f,%f&radius=1000",queryLocation.coordinate.latitude, queryLocation.coordinate.longitude];
        serverLocation  = @"google";
    }
    return self;
}

- (id)initWithSearchPlaceDetail:(NSString *)placeID
{
    self = [super init];
    if (self) {
        baseURL = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&sensor=true&key=AIzaSyC19nuMyJzGByx56Fsw-LQmOUSyjCVnBnI",placeID];
        serverLocation  = @"google";
        NSLog(@"%@",baseURL);
    }
    return self;
}

- (void)getData:(NSURL *)URL{
    __block NSDictionary *results;
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    //operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];

    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        results = [[NSDictionary alloc] initWithDictionary:(NSDictionary *)responseObject];
        [_delegate getDataController:self didFinishReceiveData:results];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_delegate getDataController:self didFinishReceiveData:results];
    }];
    [operation start];
}

- (void) searchFromKeyword:(NSString *)keyword {
    NSString *advancedURL = [baseURL stringByAppendingString:[NSString stringWithFormat:@"&query=%@",keyword]];
    advancedURL = [advancedURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self getData:[NSURL URLWithString:advancedURL]];
}

- (void) searchFromKeyWordWithNCU:(NSString *)keyword
{
    NSString *advancedURL = [baseURL stringByAppendingString:[NSString stringWithFormat:@"&q=%@",keyword]];
    advancedURL = [advancedURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self getData:[NSURL URLWithString:advancedURL]];
}

- (void) searchNearby:(NSString *)type
{
    NSString *advancedURL = [baseURL stringByAppendingString:[NSString stringWithFormat:@"&types=%@",type]];
    advancedURL = [advancedURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self getData:[NSURL URLWithString:advancedURL]];

}

- (void) getPlaceDetail
{
    NSString *advancedURL = baseURL;
    advancedURL = [advancedURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self getData:[NSURL URLWithString:advancedURL]];
}

@end
