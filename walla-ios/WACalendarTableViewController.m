//
//  WACalendarTableViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 1/18/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import "WACalendarTableViewController.h"

#import "WAViewGroupTableViewController.h"
#import "WAViewActivityViewController.h"

#import "WAValues.h"

#import "WAServer.h"

@import  Firebase;

@interface WACalendarTableViewController ()

@end

@implementation WACalendarTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Calendar";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CreateNewEvent"] style:UIBarButtonItemStylePlain target:self action:@selector(openCreateActivity)];
    
    // Set up activities table view
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WAActivityTableViewCell" bundle:nil] forCellReuseIdentifier:@"activityCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = [WAValues defaultTableViewBackgroundColor];
    
    self.tableView.showsVerticalScrollIndicator = false;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 170.0;
    
    // Initialize default values
    
    self.activitiesDictionary = [[NSMutableDictionary alloc] init];
    
    self.userInfoDictionary = [[NSMutableDictionary alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [WAServer getUserCalendarWithID:[FIRAuth auth].currentUser.uid completion:^(NSArray *calendar) {
        self.calendarItemsArrays = calendar;
        
        [self processCalendarItems];
    }];
}

- (void)processCalendarItems {
    
    for (WAActivity *activity in self.activitiesArray) {
        if (![self.calendarItemsArrays containsObject:activity.activityID]) {
            [self.activitiesDictionary removeObjectForKey:activity.activityID];
        }
    }
    
    for (NSString *auid in self.calendarItemsArrays) {
        [WAServer getActivityWithID:auid completion:^(WAActivity *activity) {
            [self.activitiesDictionary setObject:activity forKey:auid];
            
            self.activitiesArray = [[self.activitiesDictionary allValues] sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                NSTimeInterval first = [((WAActivity *)a).startTime timeIntervalSince1970];
                NSTimeInterval second = [((WAActivity *)b).startTime timeIntervalSince1970];
                return first <= second;
            }];
            
            [self.tableView reloadData];
        }];
    }
    
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
    [formatter1 setDateFormat:@"h:mm aa"];
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"h:mm aa"];
    NSDateFormatter *formatter3 = [[NSDateFormatter alloc] init];
    [formatter3 setDateFormat:@"MM/dd"];
    
    NSString *startTimeString = [formatter1 stringFromDate:activity.startTime];
    NSString *endTimeString = [formatter2 stringFromDate:activity.endTime];
    
    cell.timeLabel.text = [NSString stringWithFormat:@"%@\nto %@", startTimeString, endTimeString];
    
    cell.dateLabel.text = [formatter3 stringFromDate:activity.startTime];
    
    cell.interestedCountLabel.text = [NSString stringWithFormat:@"%ld", (long)activity.numberInterested];
    cell.goingCountLabel.text = [NSString stringWithFormat:@"%ld", (long)activity.numberGoing];
    
    cell.audienceImageView.image = (activity.activityPublic) ? [UIImage imageNamed:@"Lit"] : [UIImage imageNamed:@"Chill"];
    
    if ([activity.goingUserIDs count] > 0) {
        if ([[self.userInfoDictionary allKeys] containsObject:[activity.goingUserIDs objectAtIndex:0]]) {
            NSDictionary *userInfo = [self.userInfoDictionary objectForKey:[activity.goingUserIDs objectAtIndex:0]];
            if ([activity.goingUserIDs count] == 1) {
                cell.goingNamesLabel.text = [NSString stringWithFormat:@"%@ is going", userInfo[@"name"]];
            }
            else {
                if (activity.numberGoing == 2) cell.goingNamesLabel.text = [NSString stringWithFormat:@"%@ and %ld other are going", userInfo[@"name"], (long)(activity.numberGoing-1)];
                else cell.goingNamesLabel.text = [NSString stringWithFormat:@"%@ and %ld others are going", userInfo[@"name"], (long)(activity.numberGoing-1)];
            }
        }
        else {
            cell.goingNamesLabel.text = @"";
            [self.userInfoDictionary setObject:@{@"name": @""} forKey:[activity.goingUserIDs objectAtIndex:0]];
            [WAServer getUserBasicInfoWithID:[activity.goingUserIDs objectAtIndex:0] completion:^(NSDictionary *user) {
                [self.userInfoDictionary setObject:user forKey:user[@"user_id"]];
                [self.tableView reloadData];
            }];
        }
    }
    
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
