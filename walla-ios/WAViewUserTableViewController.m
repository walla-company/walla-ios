//
//  WAViewUserTableViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/27/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WAViewUserTableViewController.h"

#import "WAViewActivityTableViewController.h"
#import "WAViewGroupTableViewController.h"

#import "WAServer.h"
#import "WAActivity.h"
#import "WAValues.h"

@import Firebase;

@interface WAViewUserTableViewController ()

@end

@implementation WAViewUserTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"USERID: %@", self.viewingUserID);
    
    self.title = @"Profile";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CreateNewEvent"] style:UIBarButtonItemStylePlain target:self action:@selector(openCreateActivity)];
    
    // Set up table view
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WAViewUserProfileTableViewCell" bundle:nil] forCellReuseIdentifier:@"profileCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WAViewUserDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"detailsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WAActivityTableViewCell" bundle:nil] forCellReuseIdentifier:@"activityCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = [[UIColor alloc] initWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
    
    self.tableView.showsVerticalScrollIndicator = false;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 170.0;
    
    // Set up colors
    
    self.tabColorLightGray = [[UIColor alloc] initWithRed:97.0/255.0 green:97.0/255.0 blue:97.0/255.0 alpha:1.0];
    self.tabColorOffwhite = [[UIColor alloc] initWithRed:251.0/255.0 green:251.0/255.0 blue:251.0/255.0 alpha:1.0];
    self.tabColorOrange = [[UIColor alloc] initWithRed:244.0/255.0 green:201.0/255.0 blue:146.0/255.0 alpha:1.0];
    
    self.viewingUserProfileImage = [UIImage imageNamed:@"BlankCircle"];
    
    self.groupInfoDictionary = [[NSMutableDictionary alloc] init];
    
    self.activitiesDictionary = [[NSMutableDictionary alloc] init];
    self.loadingActivitiesSet = [[NSMutableSet alloc] init];
    
    self.userInfoDictionary = [[NSMutableDictionary alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [WAServer getUserWithID:self.viewingUserID completion:^(WAUser *user) {
        self.viewingUser = user;
        
        [self loadProfileImage:self.viewingUser.profileImageURL];
        
        [self.tableView reloadData];
    }];
    
    [WAServer getUserFriendsWithID:[FIRAuth auth].currentUser.uid completion:^(NSArray *friends) {
        self.userFriendsArray = friends;
        
        [self.tableView reloadData];
    }];
    
    [WAServer getSentFriendRequests:^(NSArray *sentRequest) {
        self.userSentFriendRequestsArray = sentRequest;
        
        [self.tableView reloadData];
    }];
    
    [WAServer getRecievedFriendRequests:^(NSArray *recievedRequests) {
        self.userReceivedFriendRequestsArray = recievedRequests;
        
        [self.tableView reloadData];
    }];
}

- (void)loadProfileImage:(NSString *)profileImageURL {
    
    NSLog(@"loadProfileImage: %@", profileImageURL);
    
    if (![profileImageURL isEqualToString:@""]) {
        
        FIRStorage *storage = [FIRStorage storage];
        
        FIRStorageReference *imageRef = [storage referenceForURL:profileImageURL];
        
        [imageRef dataWithMaxSize:10 * 1024 * 1024 completion:^(NSData *data, NSError *error) {
            if (error != nil) {
                
                NSLog(@"Error downloading profile image: %@", error);
                
            } else {
                
                self.viewingUserProfileImage = [UIImage imageWithData:data];
                [self.tableView reloadData];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return (self.viewingUser) ? 2 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        if (self.viewingUser) return ([self.viewingUser.details isEqualToString:@""]) ? 1 : 2;
        return 0;
    }
    
    return (self.viewingUser) ? [self.viewingUser.activities count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            WAViewUserProfileTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"profileCell" forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
            cell.delegate = self;
            
            cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", self.viewingUser.firstName, self.viewingUser.lastName];
            
            cell.infoLabel.text = [NSString stringWithFormat:@"%@ Class of %@", ([self.viewingUser.academicLevel isEqualToString:@"undergrad"]) ? @"Undergraduate" : @"Graduate", self.viewingUser.graduationYear];
            
            cell.locationLabel.text = self.viewingUser.hometown;
            
            cell.profileImageView.image = self.viewingUserProfileImage;
            
            cell.profileImageView.clipsToBounds = true;
            cell.profileImageView.layer.cornerRadius = 32.5;
            
            [cell.addFriendButton addTarget:self action:@selector(addFriendButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([self.userFriendsArray containsObject:self.viewingUserID]) {
                cell.addFriendButton.userInteractionEnabled = false;
                
                [cell.addFriendButton setTitle:@"You are friends!" forState:UIControlStateNormal];
                
                cell.addFriendView.backgroundColor = [WAValues buttonGrayColor];
            }
            else if ([self.userSentFriendRequestsArray containsObject:self.viewingUserID]) {
                cell.addFriendButton.userInteractionEnabled = false;
                
                [cell.addFriendButton setTitle:@"Friend request sent" forState:UIControlStateNormal];
                
                cell.addFriendView.backgroundColor = [WAValues buttonGrayColor];
            }
            else if ([self.userReceivedFriendRequestsArray containsObject:self.viewingUserID]) {
                cell.addFriendButton.userInteractionEnabled = false;
                
                [cell.addFriendButton setTitle:@"Friend request received" forState:UIControlStateNormal];
                
                cell.addFriendView.backgroundColor = [WAValues buttonGrayColor];
            }
            else {
                cell.addFriendButton.userInteractionEnabled = true;
                
                [cell.addFriendButton setTitle:@"Add friend!" forState:UIControlStateNormal];
                
                cell.addFriendView.backgroundColor = [WAValues buttonBlueColor];
            }
            
            BOOL canShowGroups = true;
            
            for (NSString *guid in self.viewingUser.groups) {
                if (![self.groupInfoDictionary objectForKey:guid]) {
                    canShowGroups = false;
                    [self.groupInfoDictionary setObject:@{@"name": @"", @"short_name": @"", @"color": @"#ffffff", @"group_id": guid} forKey:guid];
                    [WAServer getGroupBasicInfoWithID:guid completion:^(NSDictionary *group) {
                        [self.groupInfoDictionary setObject:group forKey:guid];
                        [self.tableView reloadData];
                    }];
                }
            }
            
            if (canShowGroups) {
                NSMutableArray *groupsArray = [[NSMutableArray alloc] initWithArray:[self.groupInfoDictionary allValues]];
                [groupsArray sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:true]]];
                cell.grouspArray = groupsArray;
                [cell.groupsTableView reloadData];
            }
            
            return cell;
        }
        
        WAViewUserDetailsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"detailsCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        cell.detailsLabel.text = self.viewingUser.details;
        
        return cell;
    }
    
    WAActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"activityCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    NSString *auid = [self.viewingUser.activities objectAtIndex:indexPath.row];
    
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
        destinationController.viewingActivityID = [self.viewingUser.activities objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:destinationController animated:YES];
    }
    
}

#pragma mark - Button targets

- (void)addFriendButtonPressed:(UIButton *)button {
    
    [WAServer requestFriendRequestWithUID:self.viewingUserID completion:nil];
    
    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:self.userSentFriendRequestsArray];
    [temp addObject:self.viewingUserID];
    self.userSentFriendRequestsArray = temp;
    
    [self.tableView reloadData];
}

#pragma mark - Tab header view delegate

- (void)activityTabButtonPressed:(NSString *)groupID {
    
    NSLog(@"Tab pressed: %@", groupID);
    
    WAViewGroupTableViewController *destinationController = [self.storyboard instantiateViewControllerWithIdentifier:@"WAViewGroupTableViewController"];
    destinationController.viewingGroupID = groupID;
    [self.navigationController pushViewController:destinationController animated:YES];
}

#pragma mark - User profile cell delegate

- (void)showMoreLessButtonPressed {
    
    NSLog(@"showMoreLessButtonPressed");
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void)userGroupSelected:(NSString *)groupID {
    
    NSLog(@"Group selected: %@", groupID);
    
    WAViewGroupTableViewController *destinationController = [self.storyboard instantiateViewControllerWithIdentifier:@"WAViewGroupTableViewController"];
    destinationController.viewingGroupID = groupID;
    [self.navigationController pushViewController:destinationController animated:YES];
}

#pragma mark - Navigation

- (void)openCreateActivity {
    
    [self performSegueWithIdentifier:@"openCreateActivity" sender:self];
}

@end
