//
//  NearbyViewController.m
//  iTravel
//
//  Created by LarryStanley on 2015/5/1.
//  Copyright (c) 2015年 LarryStanley. All rights reserved.
//

#import "NearbyViewController.h"

@interface NearbyViewController ()

@end

@implementation NearbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:scrollView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    int lastX = 10;
    int lastY = 10;
    
    NSMutableArray *items = [[NSMutableArray alloc] initWithObjects:@"吃的", @"便利商店", @"加油站", @"停車場", @"超級市場", @"咖啡館", @"飯店", @"醫院", @"圖書館", @"郵局",@"酒吧" @"花店", @"機場",nil];
    
    for (int i = 0; i < [items count]; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(lastX, lastY, (self.view.frame.size.width - 40 )/3, 100)];
        button.backgroundColor = [UIColor colorWithRed:200/255.f green:36/255.f blue:97/255.f alpha:1];
        [button setTitle:[items objectAtIndex:i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(showResult:) forControlEvents:UIControlEventTouchDown];
        button.tag = i;
        [scrollView addSubview:button];
        
        if ((i+1)%3 == 0)
            lastY = lastY + 110;
        
        if ((i+1)%3 == 0)
            lastX = 10;
        else
            lastX = lastX + (self.view.frame.size.width - 40 )/3 + 10;
    }
    
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, lastY + 10);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)showResult:(id)sender
{
    NSMutableArray *itmes = [[NSMutableArray alloc] initWithObjects:@"food", @"convenience_store", @"gas_station", @"parking", @"grocery_or_supermarket", @"cafe", @"hotel", @"hospital", @"library", @"post_office", @"bar", @"florist", @"airport",nil];
    [_delegate nearbyViewController:self searchCategory:[itmes objectAtIndex:[(UIButton *)sender tag]]];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
