//
//  PlaceDetailViewController.m
//  iTravel
//
//  Created by LarryStanley on 2014/8/15.
//  Copyright (c) 2014年 LarryStanley. All rights reserved.
//

#import "PlaceDetailViewController.h"
#import "MapAnnotation.h"
#import "theGrayButton.h"

@interface PlaceDetailViewController ()

@end

@implementation PlaceDetailViewController
@synthesize placeData, placeReference;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set intergace
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.view.backgroundColor = [UIColor colorWithRed:47/255.f green:52/255.f blue:60/255.f alpha:1];
    
    // Init map view
    topMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    topMapView.delegate = self;
    topMapView.showsUserLocation = YES;
    [self.view addSubview:topMapView];
    placeCoordinate = CLLocationCoordinate2DMake([[[[placeData objectForKey:@"geometry"]
                                                                          objectForKey:@"location"]
                                                                         objectForKey:@"lat"] floatValue],
                                                                       [[[[placeData objectForKey:@"geometry"]
                                                                          objectForKey:@"location"]
                                                                         objectForKey:@"lng"] floatValue]);
    [self changeMapCenter:placeCoordinate];
    MapAnnotation *mapAnnotation = [[MapAnnotation alloc] init];
    mapAnnotation.title = [placeData objectForKey:@"name"];
    mapAnnotation.coordinate = placeCoordinate;
    mapAnnotation.subtitle = [placeData objectForKey:@"vicinity"];
    [topMapView addAnnotation:mapAnnotation];
    
    // Set UIScrollView
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, self.view.frame.size.height - 200)];
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    
    // Get place detail
    detailData = placeData;
    NSArray *displayInfo = [[NSArray alloc] initWithObjects:[placeData objectForKey:@"name"],
                                                            [placeData objectForKey:@"formatted_address"],
                                                            [placeData objectForKey:@"formatted_phone_number"], nil];
    int lastPosition = 10;
    
    for (int i = 0; i < [displayInfo count]; i++) {
        UILabel *lable = [[UILabel alloc] init];
        lable.text = [displayInfo objectAtIndex:i];
        lable.backgroundColor = [UIColor clearColor];
        if (!i)
            lable.font = [UIFont systemFontOfSize:24];
        else
            lable.font = [UIFont systemFontOfSize:16];
        [lable sizeToFit];
        if (!i)
            lable.textColor = [UIColor colorWithRed:34/255.f green:153/255.f blue:253/255.f alpha:1];
        else
            lable.textColor = [UIColor whiteColor];
        lable.frame = CGRectMake(0, lastPosition, self.view.frame.size.width, lable.frame.size.height);
        lable.textAlignment = NSTextAlignmentCenter;
        [scrollView addSubview:lable];
        lastPosition = lable.frame.origin.y + lable.frame.size.height + 10;
    }
    
    NSArray *displayButton = @[@"撥打電話", @"路線規劃"];
    for (int i = 0; i < [displayButton count]; i++) {
        int xPosition = self.view.frame.size.width/2 - 108;
        if (i%2) {
            xPosition += 118;
        }
        theGrayButton *button = [[theGrayButton alloc] initWithFrame:CGRectMake(xPosition, lastPosition, 98, 33)
                                                       AndButtonText:[displayButton objectAtIndex:i]];
        button.tag = i;
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:button];
        
        //lastPosition = button.frame.origin.y + 43;
    }
    
    imageWebView = [[UIWebView alloc] initWithFrame:CGRectMake(20, lastPosition + 43, 280, 280)];
    imageWebView.backgroundColor = [UIColor clearColor];
    imageWebView.scalesPageToFit = NO;
    imageWebView.scrollView.scrollEnabled = NO;
    imageWebView.scrollView.bounces = NO;
    [imageWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:
                                                            [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=%@&sensor=true&key=AIzaSyC19nuMyJzGByx56Fsw-LQmOUSyjCVnBnI",
                                                             [[[detailData objectForKey:@"photos"] objectAtIndex:0] objectForKey:@"photo_reference"]]]]];
    [scrollView addSubview:imageWebView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - All about Get Data Controller delegate

- (void)getDataController:(GetDataController *)controller didFinishReceiveData:(NSDictionary *)receiveData
{
    detailData = [receiveData objectForKey:@"result"];
    NSArray *displayInfo = @[[placeData objectForKey:@"name"],
                             [detailData objectForKey:@"formatted_address"],
                             [detailData objectForKey:@"formatted_phone_number"]];
    int lastPosition = 10;
    
    for (int i = 0; i < [displayInfo count]; i++) {
        UILabel *lable = [[UILabel alloc] init];
        lable.text = [displayInfo objectAtIndex:i];
        lable.backgroundColor = [UIColor clearColor];
        if (!i)
            lable.font = [UIFont systemFontOfSize:24];
        else
            lable.font = [UIFont systemFontOfSize:16];
        [lable sizeToFit];
        if (!i)
            lable.textColor = [UIColor colorWithRed:34/255.f green:153/255.f blue:253/255.f alpha:1];
        else
            lable.textColor = [UIColor whiteColor];
        lable.frame = CGRectMake(0, lastPosition, self.view.frame.size.width, lable.frame.size.height);
        lable.textAlignment = NSTextAlignmentCenter;
        [scrollView addSubview:lable];
        lastPosition = lable.frame.origin.y + lable.frame.size.height + 10;
    }
    
    NSArray *displayButton = @[@"撥打電話", @"路線規劃"];
    for (int i = 0; i < [displayButton count]; i++) {
        int xPosition = self.view.frame.size.width/2 - 108;
        if (i%2) {
            xPosition += 118;
        }
        theGrayButton *button = [[theGrayButton alloc] initWithFrame:CGRectMake(xPosition, lastPosition, 98, 33)
                                                       AndButtonText:[displayButton objectAtIndex:i]];
        button.tag = i;
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:button];
        
        //lastPosition = button.frame.origin.y + 43;
    }
    
    imageWebView = [[UIWebView alloc] initWithFrame:CGRectMake(20, lastPosition + 43, 280, 280)];
    imageWebView.backgroundColor = [UIColor clearColor];
    imageWebView.scalesPageToFit = NO;
    imageWebView.scrollView.scrollEnabled = NO;
    imageWebView.scrollView.bounces = NO;
    [imageWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:
                                                            [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=%@&sensor=true&key=AIzaSyC19nuMyJzGByx56Fsw-LQmOUSyjCVnBnI",
                                                            [[[detailData objectForKey:@"photos"] objectAtIndex:0] objectForKey:@"photo_reference"]]]]];
    [scrollView addSubview:imageWebView];
    //scrollView.contentSize = CGSizeMake(self.view.frame.size.width, lastPosition + 360);
}

#pragma mark - All about map view delegate

- (void)changeMapCenter:(CLLocationCoordinate2D)location
{
    MKCoordinateRegion region;
    region.center.latitude = location.latitude;
    region.center.longitude = location.longitude;
    region.span.latitudeDelta = 0.005;
    region.span.longitudeDelta = 0.005;
    
    [topMapView setRegion:region animated:YES];
}

#pragma mark - All about butto method

- (void)buttonPressed:(UIButton *)button
{
    switch (button.tag) {
        case 1:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/?q=%f,%f", placeCoordinate.latitude, placeCoordinate.longitude]]];
            break;
            
        default:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[detailData objectForKey:@"formatted_phone_number"]]];
            break;
    }
}

@end
