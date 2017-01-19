//
//  WAViewActivityViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/26/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WAViewActivityViewController.h"

#import "WAViewGroupTableViewController.h"

#import "WAViewUserTableViewController.h"

#import "WAShowMapViewController.h"

#import "WAServer.h"

#import "WAValues.h"

@import Firebase;

@interface WAViewActivityViewController ()

@end

@implementation WAViewActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"ACTIVITYID: %@", self.viewingActivityID);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CreateNewEvent"] style:UIBarButtonItemStylePlain target:self action:@selector(openCreateActivity)];
    
    // Set up view activity table view
    
    self.viewActivityTableView.delegate = self;
    self.viewActivityTableView.dataSource = self;
    
    self.viewActivityTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.viewActivityTableView registerNib:[UINib nibWithNibName:@"WAViewActivityInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"infoCell"];
    [self.viewActivityTableView registerNib:[UINib nibWithNibName:@"WAViewActivityLocationTableViewCell" bundle:nil] forCellReuseIdentifier:@"locationCell"];
    [self.viewActivityTableView registerNib:[UINib nibWithNibName:@"WAViewActivityAttendeesTableViewCell" bundle:nil] forCellReuseIdentifier:@"attendeesCell"];
    [self.viewActivityTableView registerNib:[UINib nibWithNibName:@"WAViewActivityButtonsTableViewCell" bundle:nil] forCellReuseIdentifier:@"buttonsCell"];
    [self.viewActivityTableView registerNib:[UINib nibWithNibName:@"WAViewActivityHostTableViewCell" bundle:nil] forCellReuseIdentifier:@"hostCell"];
    [self.viewActivityTableView registerNib:[UINib nibWithNibName:@"WAViewActivityDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"detailsCell"];
    
    self.viewActivityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.viewActivityTableView.backgroundColor = [[UIColor alloc] initWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
    
    self.viewActivityTableView.showsVerticalScrollIndicator = false;
    
    self.viewActivityTableView.rowHeight = UITableViewAutomaticDimension;
    self.viewActivityTableView.estimatedRowHeight = 150.0;
    
    self.userInfoDictionary = [[NSMutableDictionary alloc] init];
    
    self.activityHostImage = [UIImage imageNamed:@"BlankCircle"];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [WAServer getActivityWithID:self.viewingActivityID completion:^(WAActivity *activity){
        
        self.viewingActivity = activity;
        if (self.viewingActivity.activityPublic) self.title = @"Public";
        else self.title = @"Private";
        [self.viewActivityTableView reloadData];
        
        [WAServer getUserBasicInfoWithID:self.viewingActivity.host completion:^(NSDictionary *user) {
            
            self.activityHostName = user[@"name"];
            self.activityHostDetails = [NSString stringWithFormat:@"%@ Class of %@", ([user[@"academic_level"] isEqualToString:@"undergrad"]) ? @"Undergraduate" : @"Graduate", user[@"graduation_year"]];
            [self.viewActivityTableView reloadData];
            
            [self loadProfileImage:user[@"profile_image_url"]];
        }];
    }];
    
    [WAServer getUserFriendsWithID:[FIRAuth auth].currentUser.uid completion:^(NSArray *friends) {
        self.userFriends = friends;
    }];
    
    [WAServer getUserGroupsWithID:[FIRAuth auth].currentUser.uid completion:^(NSArray *groups) {
        self.userGroups = groups;
    }];
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
                [self.viewActivityTableView reloadData];
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
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.viewingActivity) return ([self.viewingActivity.details isEqualToString:@""]) ? 5 : 6;
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        WAViewActivityInfoTableViewCell *cell = [self.viewActivityTableView dequeueReusableCellWithIdentifier:@"infoCell" forIndexPath:indexPath];
        
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
        
        WAViewActivityButtonsTableViewCell *cell = [self.viewActivityTableView dequeueReusableCellWithIdentifier:@"buttonsCell" forIndexPath:indexPath];
        
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
        
        WAViewActivityLocationTableViewCell *cell = [self.viewActivityTableView dequeueReusableCellWithIdentifier:@"locationCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        cell.locationLabel.text = self.viewingActivity.locationName;
        
        [cell.showMapButton addTarget:self action:@selector(showMapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    if (indexPath.row == 3) {
        
        WAViewActivityAttendeesTableViewCell *cell = [self.viewActivityTableView dequeueReusableCellWithIdentifier:@"attendeesCell" forIndexPath:indexPath];
        
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
                else if ((i == 2 || i == [self.viewingActivity.interestedUserIDs count]-1) && [self.viewingActivity.goingUserIDs count] > 3) [interestedNames appendString:[NSString stringWithFormat:@" and %ld %@ are going", (long)(self.viewingActivity.numberInterested-3), (self.viewingActivity.numberInterested-3 == 1) ? @"other" : @"others"]];
                else if (i == [self.viewingActivity.interestedUserIDs count]-1) [interestedNames appendString:@" are going"];
                else if ([self.viewingActivity.interestedUserIDs count] > 3 || i != [self.viewingActivity.interestedUserIDs count]-2) [interestedNames appendString:@", "];
                else [interestedNames appendString:@" and "];
            }
            else {
                interestedNames = [NSMutableString stringWithFormat:@""];
                [WAServer getUserBasicInfoWithID:replyUID completion:^(NSDictionary *user) {
                    [self.userInfoDictionary setObject:user forKey:replyUID];
                    [self.viewActivityTableView reloadData];
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
                    [self.viewActivityTableView reloadData];
                }];
                break;
            }
        }
        
        if (self.viewingActivity.numberGoing != 0) cell.goingLabel.text = goingNames;
        
        return cell;
    }
    
    if (indexPath.row == 4) {
        
        WAViewActivityHostTableViewCell *cell = [self.viewActivityTableView dequeueReusableCellWithIdentifier:@"hostCell" forIndexPath:indexPath];
        
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
    
    WAViewActivityDetailsTableViewCell *cell = [self.viewActivityTableView dequeueReusableCellWithIdentifier:@"detailsCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    cell.detailsTextLabel.text = self.viewingActivity.details;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 4) {
        
        if ([self.viewingActivity.host isEqualToString:[FIRAuth auth].currentUser.uid]) {
            [self.tabBarController setSelectedIndex:4];
        }
        else {
            WAViewUserTableViewController *destinationController = [self.storyboard instantiateViewControllerWithIdentifier:@"WAViewUserTableViewController"];
            destinationController.viewingUserID = self.viewingActivity.host;
            [self.navigationController pushViewController:destinationController animated:YES];
        }
    }
    
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
    
    [self.viewActivityTableView reloadData];
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
    
    [self.viewActivityTableView reloadData];
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
        if (![self.viewingActivity.invitedUserIDs containsObject:uid]) {
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
