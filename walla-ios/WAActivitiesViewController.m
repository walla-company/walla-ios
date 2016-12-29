//
//  WAActivitiesViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/15/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WAActivitiesViewController.h"

#import "WAValues.h"

@interface WAActivitiesViewController ()

@end

@implementation WAActivitiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CreateNewEvent"] style:UIBarButtonItemStylePlain target:self action:@selector(openCreateActivity)];
    
    // Set up activities table view
    
    self.activitiesTableView.delegate = self;
    self.activitiesTableView.dataSource = self;
    
    self.activitiesTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.activitiesTableView registerNib:[UINib nibWithNibName:@"WAActivityTableViewCell" bundle:nil] forCellReuseIdentifier:@"activityCell"];
    
    self.activitiesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.activitiesTableView.backgroundColor = [[UIColor alloc] initWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
    
    self.activitiesTableView.showsVerticalScrollIndicator = false;
    
    self.activitiesTableView.rowHeight = UITableViewAutomaticDimension;
    self.activitiesTableView.estimatedRowHeight = 170.0;
    
    // Set up filters colleciton view
    
    self.filtersCollectionView.delegate = self;
    self.filtersCollectionView.dataSource = self;
    
    self.currentFilterIndex = 0;
    
    self.interestsArray = [WAValues interestsArray];
    
    // Set up colors
    
    self.tabColorLightGray = [[UIColor alloc] initWithRed:97.0/255.0 green:97.0/255.0 blue:97.0/255.0 alpha:1.0];
    self.tabColorOffwhite = [[UIColor alloc] initWithRed:251.0/255.0 green:251.0/255.0 blue:251.0/255.0 alpha:1.0];
    self.tabColorOrange = [[UIColor alloc] initWithRed:244.0/255.0 green:201.0/255.0 blue:146.0/255.0 alpha:1.0];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)openCreateActivity {
    
    [self performSegueWithIdentifier:@"openCreateActivity" sender:self];
}

#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WAActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"activityCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    [cell.headerView setTabs:@[@[@"Interest", [UIColor whiteColor], self.tabColorLightGray, @false], @[@"Interest", self.tabColorOffwhite, self.tabColorLightGray, @false], @[@"Group", self.tabColorOrange, [UIColor whiteColor], @true]]];
    
    cell.headerView.delegate = self;
    
    cell.headerView.groupID = @"GROUPID";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"SELECTED");
    
    [self performSegueWithIdentifier:@"openActivityDetails" sender:self];
    
}

#pragma mark - Tab header view delegate

- (void)activityTabButtonPressed:(NSString *)groupID {
    
    NSLog(@"Tab pressed: %@", groupID);
    
    [self performSegueWithIdentifier:@"openViewGroup" sender:self];
}

#pragma mark - Collections view

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.interestsArray count] + 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.currentFilterIndex = (int) indexPath.row;
    
    [collectionView reloadData];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WAFilterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"filterCell" forIndexPath:indexPath];
    
    cell.circleView.clipsToBounds = true;
    cell.circleView.layer.cornerRadius = 20.0;
    
    if (indexPath.row == self.currentFilterIndex) {
        cell.circleView.backgroundColor = [[UIColor alloc] initWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0];
    }
    else {
        cell.circleView.backgroundColor = [[UIColor alloc] initWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0];
    }
    
    if (indexPath.row == 0) {
        cell.filterLabel.text = @"All";
        cell.filterImageView.image = [[UIImage alloc] init];
    }
    else {
        cell.filterLabel.text = self.interestsArray[indexPath.row-1][0];
        cell.filterImageView.image = [[UIImage imageNamed:self.interestsArray[indexPath.row-1][1]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [cell.filterImageView setTintColor:[UIColor whiteColor]];
    }
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
