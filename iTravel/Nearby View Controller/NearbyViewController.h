//
//  NearbyViewController.h
//  iTravel
//
//  Created by LarryStanley on 2015/5/1.
//  Copyright (c) 2015年 LarryStanley. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NearbyViewController;
@protocol NearbyViewControllerDelegate <NSObject>

@optional
- (void) nearbyViewController:(NearbyViewController *)controller searchCategory:(NSString *)categoryName;

@end

@interface NearbyViewController : UIViewController
{
    UIScrollView *scrollView;
}

@property (nonatomic, weak) id <NearbyViewControllerDelegate> delegate;

- (void)showResult:(id)sender;

@end
