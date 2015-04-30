//
//  CollectionViewController.m
//  iTravel
//
//  Created by LarryStanley on 2015/4/30.
//  Copyright (c) 2015年 LarryStanley. All rights reserved.
//

#import "CollectionViewController.h"
#import "FMDatabase.h"

@interface CollectionViewController ()

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    NSString *dbPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"userData.db"];
    BOOL needInitTable = ![[NSFileManager defaultManager] fileExistsAtPath:dbPath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    results = [NSMutableArray new];
    resultsReference = [NSMutableArray new];
    if (!needInitTable) {
        if ([db open]) {
            FMResultSet *result = [db executeQuery:@"select * from favorite"];
            while ([result next]) {
                //[results addObject:[result stringForColumn:@"name"]];
                //[resultsReference addObject:[result stringForColumn:@"reference"]];
            }
            [db close];
        }
    }

    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [results count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    //cell.textLabel.text = [results objectAtIndex:indexPath.row];
    
    return cell;
}

@end
