//
//  WAViewGroupTableViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/27/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WAViewGroupTableViewController.h"

#import "WAViewActivityTableViewController.h"

#import "WAValues.h"
#import "WAServer.h"

@import Firebase;

@interface WAViewGroupTableViewController ()

@end

@implementation WAViewGroupTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"GROUPID: %@", self.viewingGroupID);
    
    self.title = @"Group";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CreateNewEvent"] style:UIBarButtonItemStylePlain target:self action:@selector(openCreateActivity)];
    
    // Set up table view
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WAViewGroupInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"infoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WAViewGroupDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"detailsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WAActivityTableViewCell" bundle:nil] forCellReuseIdentifier:@"activityCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = [[UIColor alloc] initWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
    
    self.tableView.showsVerticalScrollIndicator = false;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 150.0;
    
    self.activitiesDictionary = [[NSMutableDictionary alloc] init];
    self.loadingActivitiesSet = [[NSMutableSet alloc] init];
    
    self.userInfoDictionary = [[NSMutableDictionary alloc] init];
    
    self.userGroups = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [WAServer getGroupWithID:self.viewingGroupID completion:^(WAGroup *group) {
        self.viewingGroup = group;
        [self.tableView reloadData];
    }];
    
    [WAServer getUserGroupsWithID:[FIRAuth auth].currentUser.uid completion:^(NSArray *groups) {
        [self.userGroups removeAllObjects];
        [self.userGroups addObjectsFromArray:groups];
        [self.tableView reloadData];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.viewingGroup) return ([self.viewingGroup.activities count] > 0) ? 2 : 1;
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.viewingGroup) return (section == 0) ? 2 : [self.viewingGroup.activities count];
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            WAViewGroupInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell" forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
            cell.groupTagView.layer.cornerRadius = 8.0;
            cell.groupTagView.clipsToBounds = false;
            
            cell.groupTagViewLabel.text = self.viewingGroup.shortName;
            
            cell.joinView.layer.cornerRadius = 8.0;
            
            cell.joinView.backgroundColor = ([self.userGroups containsObject:self.viewingGroupID]) ? [WAValues buttonGrayColor] : [WAValues buttonBlueColor];
            
            [cell.joinButton setTitle:([self.userGroups containsObject:self.viewingGroupID] ? @"Leave" : @"Join!") forState:UIControlStateNormal];
            
            [cell.joinButton addTarget:self action:@selector(joinLeaveGroup:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.groupTagView.backgroundColor = self.viewingGroup.groupColor;
            
            cell.groupNameLabel.text = self.viewingGroup.name;
            
            cell.infoLabel.text = [NSString stringWithFormat:@"%ld %@", (unsigned long)[self.viewingGroup.members count], ([self.viewingGroup.members count] == 1) ? @"member" : @"members"];
            
            return cell;
        }
        
        WAViewGroupDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailsCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        cell.detailsLabel.text = self.viewingGroup.details;
        
        return cell;
    }
    
    WAActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"activityCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *auid = [self.viewingGroup.activities objectAtIndex:indexPath.row];
    
    WAActivity *activity = [self.activitiesDictionary objectForKey:auid];
    
    if (activity) {
        
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
    else {
        
        cell.timeLabel.text = @"";
        cell.dateLabel.text = @"";
        cell.titleLabel.text = @"";
        cell.interestedCountLabel.text = @"";
        cell.goingCountLabel.text = @"";
        cell.goingNamesLabel.text = @"";
        
        if (![self.loadingActivitiesSet containsObject:auid]) {
            [self.loadingActivitiesSet addObject:auid];
            NSLog(@"load activity: %@", auid);
            [WAServer getActivityWithID:auid completion:^(WAActivity *activity) {
                [self.activitiesDictionary setObject:activity forKey:auid];
                [self.tableView reloadData];
            }];
        }
    }

    
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return [[UIView alloc] init];
    }
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 20)];
    
    headerView.backgroundColor = [[UIColor alloc] initWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 0, self.tableView.frame.size.width-30, 20)];
    
    label.textColor = [UIColor colorWithRed:143./255.0 green:142./255.0 blue:148./255.0 alpha:1.0];
    
    label.text = @"Events Hosted";
    
    label.font = [UIFont systemFontOfSize:14.0];
    
    [headerView addSubview:label];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 0;
    }
    
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        WAViewActivityTableViewController *destinationController = [self.storyboard instantiateViewControllerWithIdentifier:@"WAViewActivityTableViewController"];
        destinationController.viewingActivityID = [self.viewingGroup.activities objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:destinationController animated:YES];
    }
    
}

#pragma mark - Button targets

- (void)joinLeaveGroup:(UIButton *)button {
    
    if ([self.userGroups containsObject:self.viewingGroupID]) {
        [WAServer leaveGroup:self.viewingGroupID completion:nil];
        [self.userGroups removeObject:self.viewingGroupID];
        [self.viewingGroup.members removeObject:self.viewingGroupID];
    }
    else {
        [WAServer joinGroup:self.viewingGroupID completion:nil];
        [self.userGroups addObject:self.viewingGroupID];
        [self.viewingGroup.members addObject:self.viewingGroupID];
    }
    
    [self.tableView reloadData];
}

#pragma mark - Tab header view delegate

- (void)activityTabButtonPressed:(NSString *)groupID {
    
    NSLog(@"Tab pressed: %@", groupID);
    
    WAViewGroupTableViewController *destinationController = [self.storyboard instantiateViewControllerWithIdentifier:@"WAViewGroupTableViewController"];
    destinationController.viewingGroupID = groupID;
    [self.navigationController pushViewController:destinationController animated:YES];
}

#pragma mark - Navigation

- (void)openCreateActivity {
    
    [self performSegueWithIdentifier:@"openCreateActivity" sender:self];
}

@end
