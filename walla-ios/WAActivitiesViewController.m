//
//  WAActivitiesViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/15/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WAActivitiesViewController.h"

#import "WAViewGroupTableViewController.h"
#import "WAViewActivityViewController.h"

#import "WAValues.h"

#import "WAServer.h"

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
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        [WAServer getActivitisFromLastHours:72.0 completion:^(NSArray *activities){
            dispatch_async(dispatch_get_main_queue(), ^(void){
                self.activitiesArray = activities;
                [self.activitiesTableView reloadData];
            });
        }];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.activitiesArray count];;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WAActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"activityCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    WAActivity *activity = self.activitiesArray[indexPath.row];
    
    NSMutableArray *headerTabs = [[NSMutableArray alloc] init];
    
    for (int i=0; i<[activity.interests count]; i++) {
        NSString *interest = [activity.interests objectAtIndex:i];
        
        switch (i) {
            case 0:
                [headerTabs addObject:@[interest, [UIColor whiteColor], [WAValues tabTextColorLightGray], @false]];
                break;
            case 1:
                [headerTabs addObject:@[interest, [WAValues tabColorOffWhite], [WAValues tabTextColorLightGray], @false]];
                break;
                
            default:
                break;
        }
    }
    
    if ([activity.hostGroupID length] > 0) {
        [headerTabs addObject:@[activity.hostGroupShortName, [WAValues tabColorOrange], [UIColor whiteColor], @true]];
        cell.headerView.groupID = activity.hostGroupID;
    }
    
    [cell.headerView setTabs:headerTabs];
    
    cell.headerView.delegate = self;
    
    cell.titleLabel.text = activity.title;
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"HH:mm aa"];
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"HH:mm"];
    NSDateFormatter *formatter3 = [[NSDateFormatter alloc] init];
    [formatter3 setDateFormat:@"MM/dd"];
    
    NSString *startTimeString = [formatter1 stringFromDate:activity.startTime];
    NSString *endTimeString = [formatter2 stringFromDate:activity.endTime];
    
    cell.timeLabel.text = [NSString stringWithFormat:@"%@\nto %@", startTimeString, endTimeString];
    
    cell.dateLabel.text = [formatter3 stringFromDate:activity.startTime];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"SELECTED");
    
    self.openActivityID = ((WAActivity *)self.activitiesArray[indexPath.row]).activityID;
    
    [self performSegueWithIdentifier:@"openActivityDetails" sender:self];
    
}

#pragma mark - Tab header view delegate

- (void)activityTabButtonPressed:(NSString *)groupID {
    
    NSLog(@"Tab pressed: %@", groupID);
    
    self.openGroupID = groupID;
    
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
        cell.circleView.backgroundColor = [WAValues wallaOrangeColor];
    }
    else {
        cell.circleView.backgroundColor = [[UIColor alloc] initWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0];
    }
    
    if (indexPath.row == 0) {
        cell.filterLabel.text = @"All";
        cell.filterImageView.image = [[UIImage imageNamed:@"InterestIcon_All"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [cell.filterImageView setTintColor:[UIColor whiteColor]];
    }
    else {
        cell.filterLabel.text = self.interestsArray[indexPath.row-1][0];
        cell.filterImageView.image = [[UIImage imageNamed:self.interestsArray[indexPath.row-1][1]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [cell.filterImageView setTintColor:[UIColor whiteColor]];
    }
    
    return cell;
}

#pragma mark - Navigation

- (void)openCreateActivity {
    
    [self performSegueWithIdentifier:@"openCreateActivity" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"openViewGroup"]) {
        
        WAViewGroupTableViewController *destinationController = (WAViewGroupTableViewController *) [segue destinationViewController];
        destinationController.viewingGroupID = self.openGroupID;
    }
    else if ([segue.identifier isEqualToString:@"openActivityDetails"]) {
        
        WAViewActivityViewController *destinationController = (WAViewActivityViewController *) [segue destinationViewController];
        destinationController.viewingActivityID = self.openActivityID;
    }
}

@end
