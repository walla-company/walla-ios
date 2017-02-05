//
//  WAViewActivityTableViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 2/4/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import "WAViewActivityTableViewController.h"

#import "WAViewGroupTableViewController.h"
#import "WAViewUserTableViewController.h"

#import "WAShowMapViewController.h"

#import "WAServer.h"

#import "WAValues.h"

@import Firebase;

@interface WAViewActivityTableViewController ()

@end

@implementation WAViewActivityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"ACTIVITYID: %@", self.viewingActivityID);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CreateNewEvent"] style:UIBarButtonItemStylePlain target:self action:@selector(openCreateActivity)];
    
    // Set up view activity table view
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WAViewActivityInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"infoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WAViewActivityLocationTableViewCell" bundle:nil] forCellReuseIdentifier:@"locationCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WAViewActivityAttendeesTableViewCell" bundle:nil] forCellReuseIdentifier:@"attendeesCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WAViewActivityButtonsTableViewCell" bundle:nil] forCellReuseIdentifier:@"buttonsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WAViewActivityHostTableViewCell" bundle:nil] forCellReuseIdentifier:@"hostCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WAViewActivityDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"detailsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WAViewActivityDiscussionTableViewCell" bundle:nil] forCellReuseIdentifier:@"discussionCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WAViewActivityPostDiscussionTableViewCell" bundle:nil] forCellReuseIdentifier:@"postDiscussionCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = [[UIColor alloc] initWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
    
    self.tableView.showsVerticalScrollIndicator = false;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 150.0;
    
    self.userInfoDictionary = [[NSMutableDictionary alloc] init];
    self.profilesImagesDictionary = [[NSMutableDictionary alloc] init];
    self.userInfoDiscussionsDictionary = [[NSMutableDictionary alloc] init];
    
    self.activityHostImage = [UIImage imageNamed:@"BlankCircle"];
    
    self.discussionPostText = @"";
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [WAServer getActivityWithID:self.viewingActivityID completion:^(WAActivity *activity){
        
        self.viewingActivity = activity;
        if (self.viewingActivity.activityPublic) self.title = @"Public";
        else self.title = @"Private";
        [self.tableView reloadData];
        
        [WAServer getUserBasicInfoWithID:self.viewingActivity.host completion:^(NSDictionary *user) {
            
            self.activityHostName = user[@"name"];
            self.activityHostDetails = [NSString stringWithFormat:@"%@ Class of %@", ([user[@"academic_level"] isEqualToString:@"undergrad"]) ? @"Undergraduate" : @"Graduate", user[@"graduation_year"]];
            [self.tableView reloadData];
            
            [self loadProfileImage:user[@"profile_image_url"]];
        }];
    }];
    
    [WAServer getUserFriendsWithID:[FIRAuth auth].currentUser.uid completion:^(NSArray *friends) {
        self.userFriends = friends;
    }];
    
    [WAServer getUserGroupsWithID:[FIRAuth auth].currentUser.uid completion:^(NSArray *groups) {
        self.userGroups = groups;
    }];
    
    [self loadDiscussions];
}

- (void)loadProfileImage:(NSString *)profileImageURL {
    
    if (![profileImageURL isEqualToString:@""]) {
        
        FIRStorage *storage = [FIRStorage storage];
        
        FIRStorageReference *imageRef = [storage referenceForURL:profileImageURL];
        
        [imageRef dataWithMaxSize:10 * 1024 * 1024 completion:^(NSData *data, NSError *error) {
            if (error != nil) {
                
                NSLog(@"Error downloading profile image: %@", error);
                
            } else {
                
                self.activityHostImage = [UIImage imageWithData:data];
                [self.tableView reloadData];
            }
        }];
    }
}

- (void)loadDiscussions {
    
    [WAServer getDiscussions:self.viewingActivityID completion:^(NSArray *discussions) {
        self.discussions = discussions;
        
        self.discussions = [self.discussions sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            double first = [((NSDictionary *)a)[@"time_posted"] doubleValue];
            double second = [((NSDictionary *)b)[@"time_posted"] doubleValue];
            return first >= second;
        }];
        
        [self.tableView reloadData];
    }];
}

- (void)loadProfileImage:(NSString *)profileImageURL uid:(NSString *)uid {
    
    NSLog(@"loadProfileImage: %@ : %@", profileImageURL, uid);
    
    if ([profileImageURL isEqualToString:@""]) {
        
        [self.profilesImagesDictionary setObject:[UIImage imageNamed:@"BlankCircle"] forKey:uid];
        
        [self.tableView reloadData];
        
    }
    else if (![self.profilesImagesDictionary objectForKey:uid]) {
        
        [self.profilesImagesDictionary setObject:[UIImage imageNamed:@"BlankCircle"] forKey:uid];
        
        [self.tableView reloadData];
        
        FIRStorage *storage = [FIRStorage storage];
        
        FIRStorageReference *imageRef = [storage referenceForURL:profileImageURL];
        
        [imageRef dataWithMaxSize:10 * 1024 * 1024 completion:^(NSData *data, NSError *error) {
            if (error != nil) {
                
                NSLog(@"Error downloading profile image: %@", error);
                
            } else {
                
                [self.profilesImagesDictionary setObject:[UIImage imageWithData:data] forKey:uid];
                [self.tableView reloadData];
            }
        }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 1) {
        
        if (!self.viewingActivity) return 0;
        
        return ([self.discussions count] == 0) ? 1 : [self.discussions count] + 1;
    }
    
    if (self.viewingActivity) return ([self.viewingActivity.details isEqualToString:@""]) ? 5 : 6;
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == [self.discussions count]) {
            WAViewActivityPostDiscussionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"postDiscussionCell" forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
            cell.postTextView.scrollEnabled = false;
            cell.postTextView.delegate = self;
            
            if ([self.discussionPostText isEqualToString:@""]) {
                cell.postTextView.textColor = [WAValues notSelectedTextColor];
                cell.postTextView.text = @"Join the discussion!";
            }
            else {
                cell.postTextView.textColor = [WAValues selectedTextColor];
                cell.postTextView.text = self.discussionPostText;
            }
            
            [cell.postButton addTarget:self action:@selector(postButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }
        
        NSDictionary *discussion = [self.discussions objectAtIndex:indexPath.row];
        
        NSString *discussionUID = discussion[@"user_id"];
        
        NSDate *timePosted = [NSDate dateWithTimeIntervalSince1970:[discussion[@"time_posted"] doubleValue]];
        
        WAViewActivityDiscussionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"discussionCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        cell.profileImageView.layer.cornerRadius = 15.0;
        cell.profileImageView.clipsToBounds = true;
        
        NSDictionary *user = self.userInfoDiscussionsDictionary[discussionUID];
        
        if (user) {
            cell.nameLabel.text = user[@"name"];
        }
        else {
            cell.nameLabel.text = @"";
            [self.userInfoDiscussionsDictionary setObject:@{@"name": @"", @"profile_image_url": @""} forKey:discussionUID];
            [WAServer getUserBasicInfoWithID:discussionUID completion:^(NSDictionary *user) {
                
                NSLog(@"user loaded");
                
                [self.userInfoDiscussionsDictionary setObject:user forKey:discussionUID];
                [self loadProfileImage:user[@"profile_image_url"] uid:discussionUID];
                
                [self.tableView reloadData];
            }];
        }
        
        UIImage *image = self.profilesImagesDictionary[discussionUID];
        
        cell.profileImageView.image = (image) ? image : [UIImage imageNamed:@"BlankCircle"];
        
        cell.discussionTextLabel.text = discussion[@"text"];
        
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        [formatter1 setDateFormat:@"h:mm aa on MM/dd"];
        NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
        [formatter2 setDateFormat:@"MM/dd"];
        
        cell.timeLabel.text = [NSString stringWithFormat:@"%@ on %@", [formatter1 stringFromDate:timePosted], [formatter2 stringFromDate:timePosted]];
        
        return cell;
    }
    
    if (indexPath.row == 0) {
        
        WAViewActivityInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        NSMutableArray *headerTabs = [[NSMutableArray alloc] init];
        
        for (int i=0; i<[self.viewingActivity.interests count]; i++) {
            NSString *interest = [self.viewingActivity.interests objectAtIndex:i];
            
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
        
        if ([self.viewingActivity.hostGroupID length] > 0) {
            [headerTabs addObject:@[self.viewingActivity.hostGroupShortName, [WAValues tabColorOrange], [UIColor whiteColor], @true]];
            cell.activityHeaderView.groupID = self.viewingActivity.hostGroupID;
        }
        
        [cell.activityHeaderView setTabs:headerTabs];
        
        cell.activityHeaderView.delegate = self;
        
        cell.titleLabel.text = self.viewingActivity.title;
        
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        [formatter1 setDateFormat:@"h:mm aa"];
        NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
        [formatter2 setDateFormat:@"h:mm aa"];
        NSDateFormatter *formatter3 = [[NSDateFormatter alloc] init];
        [formatter3 setDateFormat:@"MM/dd"];
        
        NSString *startTimeString = [formatter1 stringFromDate:self.viewingActivity.startTime];
        NSString *endTimeString = [formatter2 stringFromDate:self.viewingActivity.endTime];
        
        cell.timeLabel.text = [NSString stringWithFormat:@"%@\nto %@", startTimeString, endTimeString];
        
        cell.dateLabel.text = [formatter3 stringFromDate:self.viewingActivity.startTime];
        
        return cell;
    }
    
    if (indexPath.row == 1) {
        
        WAViewActivityButtonsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buttonsCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        cell.interestedView.backgroundColor = ([self.viewingActivity.interestedUserIDs containsObject:[FIRAuth auth].currentUser.uid]) ? [WAValues buttonInterestedColor] : [WAValues buttonBlueColor];
        cell.goingView.backgroundColor = ([self.viewingActivity.goingUserIDs containsObject:[FIRAuth auth].currentUser.uid]) ? [WAValues buttonGoingColor] : [WAValues buttonBlueColor];
        cell.inviteView.backgroundColor = [WAValues buttonBlueColor];
        cell.shareView.backgroundColor = [WAValues buttonBlueColor];
        
        cell.interestedView.layer.cornerRadius = 8.0;
        cell.goingView.layer.cornerRadius = 8.0;
        cell.inviteView.layer.cornerRadius = 8.0;
        cell.shareView.layer.cornerRadius = 8.0;
        
        [cell.interestedButton addTarget:self action:@selector(interestedButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.goingButton addTarget:self action:@selector(goingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.inviteButton addTarget:self action:@selector(inviteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.shareButton addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    if (indexPath.row == 2) {
        
        WAViewActivityLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"locationCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        cell.locationLabel.text = self.viewingActivity.locationName;
        
        [cell.showMapButton addTarget:self action:@selector(showMapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    if (indexPath.row == 3) {
        
        WAViewActivityAttendeesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"attendeesCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        cell.interestedCount.text = [NSString stringWithFormat:@"%ld", (long)self.viewingActivity.numberInterested];
        cell.goingCount.text = [NSString stringWithFormat:@"%ld", (long)self.viewingActivity.numberGoing];
        
        if (self.viewingActivity.numberInterested == 0) cell.interestedLabel.text = @"Are you interested?";
        if (self.viewingActivity.numberGoing == 0) cell.goingLabel.text = @"Be the first one to go!";
        
        NSMutableString *interestedNames = [[NSMutableString alloc] init];
        
        int interestedCount = ([self.viewingActivity.interestedUserIDs count] > 3) ? 3 : (int)[self.viewingActivity.interestedUserIDs count];
        
        if (self.viewingActivity.numberInterested == 0) interestedCount = 0;
        
        for (int i=0; i<interestedCount; i++) {
            
            NSString *replyUID = [self.viewingActivity.interestedUserIDs objectAtIndex:i];
            
            if ([[self.userInfoDictionary allKeys] containsObject:replyUID]) {
                NSDictionary *userInfo = [self.userInfoDictionary objectForKey:replyUID];
                [interestedNames appendString:[NSString stringWithFormat:@"%@", userInfo[@"name"]]];
                if ([self.viewingActivity.interestedUserIDs count] == 1) [interestedNames appendString:@" is interested"];
                else if ((i == 2 || i == [self.viewingActivity.interestedUserIDs count]-1) && [self.viewingActivity.goingUserIDs count] > 3) [interestedNames appendString:[NSString stringWithFormat:@" and %ld %@ are interested", (long)(self.viewingActivity.numberInterested-3), (self.viewingActivity.numberInterested-3 == 1) ? @"other" : @"others"]];
                else if (i == [self.viewingActivity.interestedUserIDs count]-1) [interestedNames appendString:@" are interested"];
                else if ([self.viewingActivity.interestedUserIDs count] > 3 || i != [self.viewingActivity.interestedUserIDs count]-2) [interestedNames appendString:@", "];
                else [interestedNames appendString:@" and "];
            }
            else {
                interestedNames = [NSMutableString stringWithFormat:@""];
                [WAServer getUserBasicInfoWithID:replyUID completion:^(NSDictionary *user) {
                    [self.userInfoDictionary setObject:user forKey:replyUID];
                    [self.tableView reloadData];
                }];
                break;
            }
        }
        
        if (self.viewingActivity.numberInterested != 0) cell.interestedLabel.text = interestedNames;
        
        NSMutableString *goingNames = [[NSMutableString alloc] init];
        
        int goingCount = ([self.viewingActivity.goingUserIDs count] > 3) ? 3 : (int)[self.viewingActivity.goingUserIDs count];
        
        if (self.viewingActivity.numberGoing == 0) goingCount = 0;
        
        for (int i=0; i<goingCount; i++) {
            
            NSString *replyUID = [self.viewingActivity.goingUserIDs objectAtIndex:i];
            
            if ([[self.userInfoDictionary allKeys] containsObject:replyUID]) {
                NSDictionary *userInfo = [self.userInfoDictionary objectForKey:replyUID];
                [goingNames appendString:[NSString stringWithFormat:@"%@", userInfo[@"name"]]];
                if ([self.viewingActivity.goingUserIDs count] == 1) [goingNames appendString:@" is going"];
                else if ((i == 2 || i == [self.viewingActivity.goingUserIDs count]-1) && [self.viewingActivity.goingUserIDs count] > 3) [goingNames appendString:[NSString stringWithFormat:@" and %ld %@ are going", (long)(self.viewingActivity.numberGoing-3), (self.viewingActivity.numberGoing-3 == 1) ? @"other" : @"others"]];
                else if (i == [self.viewingActivity.goingUserIDs count]-1) [goingNames appendString:@" are going"];
                else if ([self.viewingActivity.goingUserIDs count] > 3 || i != [self.viewingActivity.goingUserIDs count]-2) [goingNames appendString:@", "];
                else [goingNames appendString:@" and "];
            }
            else {
                goingNames = [NSMutableString stringWithFormat:@""];
                [WAServer getUserBasicInfoWithID:replyUID completion:^(NSDictionary *user) {
                    [self.userInfoDictionary setObject:user forKey:replyUID];
                    [self.tableView reloadData];
                }];
                break;
            }
        }
        
        if (self.viewingActivity.numberGoing != 0) cell.goingLabel.text = goingNames;
        
        return cell;
    }
    
    if (indexPath.row == 4) {
        
        WAViewActivityHostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hostCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        cell.hostProfileImageView.image = self.activityHostImage;
        
        cell.hostProfileImageView.clipsToBounds = true;
        cell.hostProfileImageView.layer.cornerRadius = 17.5;
        cell.hostProfileImageView.layer.cornerRadius = 17.5;
        
        cell.hostNameLabel.text = self.activityHostName;
        cell.hostInfoLabel.text = self.activityHostDetails;
        
        return cell;
    }
    
    WAViewActivityDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailsCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    cell.detailsTextLabel.text = self.viewingActivity.details;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 4) {
        
        if ([self.viewingActivity.host isEqualToString:[FIRAuth auth].currentUser.uid]) {
            [self.tabBarController setSelectedIndex:4];
        }
        else {
            WAViewUserTableViewController *destinationController = [self.storyboard instantiateViewControllerWithIdentifier:@"WAViewUserTableViewController"];
            destinationController.viewingUserID = self.viewingActivity.host;
            [self.navigationController pushViewController:destinationController animated:YES];
        }
    }
    if (indexPath.section == 1 && indexPath.row < [self.discussions count]) {
        
        NSDictionary *discussion = [self.discussions objectAtIndex:indexPath.row];
        
        if ([discussion[@"user_id"] isEqualToString:[FIRAuth auth].currentUser.uid]) {
            [self.tabBarController setSelectedIndex:4];
        }
        else {
            WAViewUserTableViewController *destinationController = [self.storyboard instantiateViewControllerWithIdentifier:@"WAViewUserTableViewController"];
            destinationController.viewingUserID = discussion[@"user_id"];
            [self.navigationController pushViewController:destinationController animated:YES];
        }
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return [[UIView alloc] init];
    }
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 20)];
    
    headerView.backgroundColor = [[UIColor alloc] initWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 0, self.tableView.frame.size.width-30, 20)];
    
    label.textColor = [UIColor colorWithRed:143./255.0 green:142./255.0 blue:148./255.0 alpha:1.0];
    
    label.text = @"Discussion";
    
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

# pragma mark - Button targets

- (void)showMapButtonPressed:(UIButton *)button {
    
    [self performSegueWithIdentifier:@"openShowMap" sender:self];
}


- (void)interestedButtonPressed:(UIButton *)button {
    
    if (![self.viewingActivity.interestedUserIDs containsObject:[FIRAuth auth].currentUser.uid]) {
        [WAServer activityInterested:[FIRAuth auth].currentUser.uid activityID:self.viewingActivity.activityID completion:nil];
        
        [self.viewingActivity.interestedUserIDs addObject:[FIRAuth auth].currentUser.uid];
        [self.viewingActivity.goingUserIDs removeObject:[FIRAuth auth].currentUser.uid];
    }
    else {
        [WAServer activityRemoveUser:[FIRAuth auth].currentUser.uid activityID:self.viewingActivity.activityID completion:nil];
        
        [self.viewingActivity.interestedUserIDs removeObject:[FIRAuth auth].currentUser.uid];
        [self.viewingActivity.goingUserIDs removeObject:[FIRAuth auth].currentUser.uid];
    }
    
    self.viewingActivity.numberInterested = [self.viewingActivity.interestedUserIDs count];
    self.viewingActivity.numberGoing = [self.viewingActivity.goingUserIDs count];
    
    [self.tableView reloadData];
}

- (void)goingButtonPressed:(UIButton *)button {
    
    if (![self.viewingActivity.goingUserIDs containsObject:[FIRAuth auth].currentUser.uid]) {
        [WAServer activityGoing:[FIRAuth auth].currentUser.uid activityID:self.viewingActivity.activityID completion:nil];
        
        [self.viewingActivity.interestedUserIDs removeObject:[FIRAuth auth].currentUser.uid];
        [self.viewingActivity.goingUserIDs addObject:[FIRAuth auth].currentUser.uid];
    }
    else {
        [WAServer activityRemoveUser:[FIRAuth auth].currentUser.uid activityID:self.viewingActivity.activityID completion:nil];
        
        [self.viewingActivity.interestedUserIDs removeObject:[FIRAuth auth].currentUser.uid];
        [self.viewingActivity.goingUserIDs removeObject:[FIRAuth auth].currentUser.uid];
    }
    
    self.viewingActivity.numberInterested = [self.viewingActivity.interestedUserIDs count];
    self.viewingActivity.numberGoing = [self.viewingActivity.goingUserIDs count];
    
    [self.tableView reloadData];
}

- (void)inviteButtonPressed:(UIButton *)button {
    
    if (self.viewingActivity.canOthersInvite) {
        
        UIAlertController *inviteMenu = [UIAlertController alertControllerWithTitle:@"Invite" message:@"You can invite friends or groups you are part of." preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *friendsAction = [UIAlertAction actionWithTitle:@"Invite Friends" style:UIAlertActionStyleDefault handler: ^(UIAlertAction *action){
            [self inviteFriends];
        }];
        UIAlertAction *groupsAction = [UIAlertAction actionWithTitle:@"Invite Groups" style:UIAlertActionStyleDefault handler: ^(UIAlertAction *action){
            [self inviteGroups];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        
        [inviteMenu addAction:friendsAction];
        [inviteMenu addAction:groupsAction];
        [inviteMenu addAction:cancelAction];
        
        if (inviteMenu.popoverPresentationController) {
            
            inviteMenu.popoverPresentationController.sourceView = button;
            inviteMenu.popoverPresentationController.sourceRect = button.bounds;
        }
        
        [self presentViewController:inviteMenu animated:true completion:nil];
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Invite" message:@"You are not allowed to invite others for this private event." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:true completion:nil];
    }
    
}

- (void)shareButtonPressed:(UIButton *)button {
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"h:mm aa"];
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"h:mm aa"];
    NSDateFormatter *formatter3 = [[NSDateFormatter alloc] init];
    [formatter3 setDateFormat:@"MM/dd"];
    
    NSString *startTimeString = [formatter1 stringFromDate:self.viewingActivity.startTime];
    NSString *endTimeString = [formatter2 stringFromDate:self.viewingActivity.endTime];
    NSString *dateString = [formatter3 stringFromDate:self.viewingActivity.startTime];
    
    NSString *shareString = [NSString stringWithFormat:@"Go to this activity!\n\n%@\nFrom %@ to %@ on %@\n%@\n\nFrom the Walla app (https://www.wallasquad.com/)", self.viewingActivity.title, startTimeString, endTimeString, dateString, self.viewingActivity.locationAddress];
    
    UIActivityViewController *shareMenu = [[UIActivityViewController alloc] initWithActivityItems:@[shareString] applicationActivities:@[]];
    
    if (shareMenu.popoverPresentationController) {
        
        shareMenu.popoverPresentationController.sourceView = button;
        shareMenu.popoverPresentationController.sourceRect = button.bounds;
    }
    
    [self presentViewController:shareMenu animated:true completion:nil];
    
}

#pragma mark - Tab header view delegate

- (void)activityTabButtonPressed:(NSString *)groupID {
    
    NSLog(@"Tab pressed: %@", groupID);
    
    WAViewGroupTableViewController *destinationController = [self.storyboard instantiateViewControllerWithIdentifier:@"WAViewGroupTableViewController"];
    destinationController.viewingGroupID = groupID;
    [self.navigationController pushViewController:destinationController animated:YES];
}

#pragma mark - Invite

- (void)inviteFriends {
    
    NSMutableArray *friendsToInvite = [[NSMutableArray alloc] init];
    
    for (NSString *uid in self.userFriends) {
        if (![self.viewingActivity.invitedUserIDs containsObject:uid] && ![self.viewingActivity.goingUserIDs containsObject:uid]) {
            [friendsToInvite addObject:uid];
        }
    }
    
    WAUserPickerViewController *userPicker = [[WAUserPickerViewController alloc] initWithTitle:@"Invite Friends" selectedUsers:@[] userFriendIDs:friendsToInvite];
    
    userPicker.delegate = self;
    
    self.definesPresentationContext = true;
    userPicker.view.backgroundColor = [[UIColor alloc] initWithWhite:0.5 alpha:0.2];
    userPicker.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    [self presentViewController:userPicker animated:false completion:nil];
    
}

- (void)inviteGroups {
    
    NSMutableArray *groupsToInvite = [[NSMutableArray alloc] init];
    
    for (NSString *uid in self.userGroups) {
        if (![self.viewingActivity.invitedGroupIDs containsObject:uid]) {
            [groupsToInvite addObject:uid];
        }
    }
    
    WAGroupPickerViewController *groupPicker = [[WAGroupPickerViewController alloc] initWithTitle:@"Invite Group" selectedGroups:@[] userGroupIDs:groupsToInvite canSelectMultipleGourps:true];
    
    groupPicker.delegate = self;
    
    self.definesPresentationContext = true;
    groupPicker.view.backgroundColor = [[UIColor alloc] initWithWhite:0.5 alpha:0.2];
    groupPicker.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    [self presentViewController:groupPicker animated:false completion:nil];
    
}

#pragma mark - Group picker delegate

- (void)groupPickerViewGroupSelected:(NSArray *)groups tag:(NSInteger)tag {
    
    for (NSDictionary *group in groups) {
        NSString *inviteGUID = group[@"group_id"];
        
        [WAServer activityInviteGroupWithID:inviteGUID toActivity:self.viewingActivityID completion:nil];
    }
}

#pragma mark - User picker delegate

- (void)userPickerViewUserSelected:(NSArray *)users tag:(NSInteger)tag {
    
    for (NSDictionary *user in users) {
        NSString *inviteUID = user[@"user_id"];
        
        [WAServer activityInviteUserWithID:inviteUID toActivity:self.viewingActivityID completion:nil];
    }
}

#pragma mark - Text view delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if ([self.discussionPostText isEqualToString:@""]) {
        textView.textColor = [WAValues selectedTextColor];
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    self.discussionPostText = textView.text;
    
    if ([self.discussionPostText isEqualToString:@""]) {
        textView.textColor = [WAValues notSelectedTextColor];
        textView.text = @"Join the discussion!";
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    
    self.discussionPostText = textView.text;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

#pragma mark - Post discussion

- (void)postButtonPressed:(UIButton *)button {
    
    NSLog(@"postButtonPressed");
    
    WAViewActivityPostDiscussionTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.discussions count] inSection:1]];
    
    [cell.postTextView resignFirstResponder];
    
    if ([self.discussionPostText isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No Text" message:@"You must write something before you can join the discussion." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:true completion:nil];
    }
    else {
        
        [WAServer postDiscussion:self.discussionPostText activityID:self.viewingActivityID completion:^(BOOL success) {
            if (success) {
                [self loadDiscussions];
            }
        }];
        
        self.discussionPostText = @"";
        
        [self.tableView reloadData];
    }
    
}

#pragma mark - Navigation

- (void)openCreateActivity {
    
    [self performSegueWithIdentifier:@"openCreateActivity" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"openShowMap"]) {
        
        WAShowMapViewController *destinationController = (WAShowMapViewController *) [segue destinationViewController];
        destinationController.location = self.viewingActivity.location;
        destinationController.locationName = self.viewingActivity.locationName;
        destinationController.locationAddress = self.viewingActivity.locationAddress;
    }
}

@end
