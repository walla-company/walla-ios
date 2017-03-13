//
//  WACreateActivityTableViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/17/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WACreateActivityTableViewController.h"

#import "WAValues.h"

#import "WAServer.h"

@import Firebase;

@interface WACreateActivityTableViewController ()

@end

@implementation WACreateActivityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up navigation bar buttons
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    self.navigationItem.rightBarButtonItem.enabled = false;
    
    // Set up table view
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WACreateActivityAudienceTableViewCell" bundle:nil] forCellReuseIdentifier:@"audienceCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WACreateActivityTitleTableViewCell" bundle:nil] forCellReuseIdentifier:@"titleCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WACreateActivityTimeTableViewCell" bundle:nil] forCellReuseIdentifier:@"timeCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WACreateActivityLocationTableViewCell" bundle:nil] forCellReuseIdentifier:@"locationCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WACreateActivityDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"detailsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WACreateActivityHostTableViewCell" bundle:nil] forCellReuseIdentifier:@"hostCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WACreateActivityInterestsTableViewCell" bundle:nil] forCellReuseIdentifier:@"interestsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WACreateActivityInviteGroupsTableViewCell" bundle:nil] forCellReuseIdentifier:@"inviteGroupsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WACreateActivityInviteFriendsTableViewCell" bundle:nil] forCellReuseIdentifier:@"inviteFriendsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WACreateActivityCanInviteTableViewCell" bundle:nil] forCellReuseIdentifier:@"canInviteCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WACreateActivityPostTableViewCell" bundle:nil] forCellReuseIdentifier:@"postCell"];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100.0;
    
    self.tableView.showsVerticalScrollIndicator = false;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    // Initialize default values
    
    self.notSelectedColor = [[UIColor alloc] initWithRed:189.0/255.0 green:189.0/255.0 blue:195.0/255.0 alpha:1.0];
    self.selectedColor = [[UIColor alloc] initWithRed:143.0/255.0 green:142.0/255.0 blue:148.0/255.0 alpha:1.0];
    
    self.firstUserLocationUpdate = true;
    
    self.mapViews = [[NSMutableArray alloc] init];
    
    // Required
    
    self.activityPublic = true;
    self.activityTitle = @"";
    self.activityStartTime = nil;
    self.activityEndTime = nil;
    self.activityInterests = [[NSArray alloc] init];
    self.guestsCanInviteOthers = true;
    
    // Optional
    
    self.activityDetails = @"";
    self.activityHostGroup = [[NSArray alloc] init];
    self.activityInvitedGroups = [[NSArray alloc] init];
    self.activityInvitedFriends = [[NSArray alloc] init];
    
    self.userGroupIDs = [[NSArray alloc] init];
    self.userFriendIDs = [[NSArray alloc] init];
    
    self.userVerified = false;
    
    [WAServer getUserGroupsWithID:[FIRAuth auth].currentUser.uid completion:^(NSArray *groups) {
        self.userGroupIDs = groups;
    }];
    
    [WAServer getUserFriendsWithID:[FIRAuth auth].currentUser.uid completion:^(NSArray *users) {
        self.userFriendIDs = users;
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [WAServer getUserVerified:^(BOOL verified) {
        self.userVerified = verified;
        
        NSLog(@"self.userVerified: %@", (self.userVerified) ? @"true" : @"false");
        
        if (!self.userVerified) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Account not Verified" message:@"You cannot post an activity until your account has been verified. Open the verification link to verify your account. If you have not received a verification link, you can request one now." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *requestAction = [UIAlertAction actionWithTitle:@"Request Verification Link" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                self.tableView.userInteractionEnabled = false;
                
                [WAServer sendVerificationEmail:^(BOOL success) {
                    
                    self.tableView.userInteractionEnabled = true;
                    
                    if (success) {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Email Sent" message:@"We have sent you a verification email. Please open the verification link." preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                            [self dismissViewControllerAnimated:true completion:nil];
                        }];
                        [alert addAction:cancelAction];
                        [self presentViewController:alert animated:true completion:nil];
                    }
                    else {
                        [self dismissViewControllerAnimated:true completion:nil];
                    }
                }];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [self dismissViewControllerAnimated:true completion:nil];
            }];
            [alert addAction:requestAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:true completion:nil];
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    for (GMSMapView *mapView in self.mapViews) {
        
        @try {
            [mapView removeObserver:self forKeyPath:@"myLocation"];
        } @catch (NSException *exception) {
            NSLog(@"Removing observer exception");
        }
        
    }
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)cancel {
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - Post Activity

- (void)postActivity {
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.activityPublic == true) return 10;
    
    return 11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        WACreateActivityAudienceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"audienceCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        if (self.activityPublic == true) {
            [cell.publicButton setImage:[UIImage imageNamed:@"PublicButtonPressed"] forState:UIControlStateNormal];
            [cell.privateButton setImage:[UIImage imageNamed:@"PrivateButtonReleased"] forState:UIControlStateNormal];
        }
        else {
            [cell.publicButton setImage:[UIImage imageNamed:@"PublicBottonReleased"] forState:UIControlStateNormal];
            [cell.privateButton setImage:[UIImage imageNamed:@"PrivateButtonPressed"] forState:UIControlStateNormal];
        }
        
        [cell.publicButton addTarget:self action:@selector(activityPublicButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.privateButton addTarget:self action:@selector(activityPrivateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    if (indexPath.row == 1) {
        WACreateActivityTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        cell.activityTitleTextField.tag = 1;
        cell.activityTitleTextField.delegate = self;
        
        return cell;
    }
    
    if (indexPath.row == 2) {
        WACreateActivityTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"timeCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        [cell.startTimeButton addTarget:self action:@selector(selectTimeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.endTimeButton addTarget:self action:@selector(selectTimeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.startTimeButton.tag = 1;
        cell.endTimeButton.tag = 2;
        
        if (self.activityStartTime != nil) {
            [self setTimeTitle:self.activityStartTime label:cell.startTimeLabel];
            cell.startTimeLabel.textColor = self.selectedColor;
        }
        else {
            cell.startTimeLabel.text = @"Choose start time";
            cell.startTimeLabel.textColor = self.notSelectedColor;
        }
        
        if (self.activityEndTime != nil) {
            [self setTimeTitle:self.activityEndTime label:cell.endTimeLabel];
            cell.endTimeLabel.textColor = self.selectedColor;
        }
        else {
            cell.endTimeLabel.text = @"Choose end time";
            cell.endTimeLabel.textColor = self.notSelectedColor;
        }
        
        return cell;
    }
    
    if (indexPath.row == 3) {
        WACreateActivityLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"locationCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        cell.locationMap.userInteractionEnabled = false;
        cell.locationMap.layer.cornerRadius = 8.0;
        cell.locationMap.myLocationEnabled = true;
        
        [cell.locationMap addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context:nil];
        
        [self.mapViews addObject:cell.locationMap];
        
        [cell.locationButton addTarget:self action:@selector(searchLocationButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.activityLocation) {
            cell.locationLabel.text = self.activityLocation.name;
            cell.locationLabel.textColor = [WAValues selectedTextColor];
            
            GMSMarker *marker = [GMSMarker markerWithPosition:self.activityLocation.coordinate];
            marker.title = self.activityLocation.name;
            marker.map = cell.locationMap;
            
            GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:self.activityLocation.coordinate zoom:16];
            [cell.locationMap setCamera:camera];
        }
        else {
            cell.locationLabel.text = @"Location";
            cell.locationLabel.textColor = [WAValues notSelectedTextColor];
            
            if (self.userLocation) {
                GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:self.userLocation.coordinate zoom:16];
                [cell.locationMap setCamera:camera];
            }
            else {
                GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:39.8282 longitude:-98.5795 zoom:2.5];
                [cell.locationMap setCamera:camera];
            }
        }
        
        return cell;
    }
    
    if (indexPath.row == 4) {
        WACreateActivityInterestsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"interestsCell"];
        
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        [cell.interestsButton addTarget:self action:@selector(chooseInterestsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self setInterestsLabel:self.activityInterests label:cell.interestsLabel];
        
        return cell;
    }
    
    if (indexPath.row == 5) {
        WACreateActivityDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailsCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        cell.detailsTextView.tag = 1;
        cell.detailsTextView.scrollEnabled = false;
        cell.detailsTextView.delegate = self;
        
        if ([self.activityDetails isEqual: @""]) {
            cell.detailsTextView.textColor = self.notSelectedColor;
            cell.detailsTextView.text = @"Details";
        }
        else {
            cell.detailsTextView.textColor = self.selectedColor;
            cell.detailsTextView.text = self.activityDetails;
        }
        
        return cell;
    }
    
    if (indexPath.row == 6) {
        WACreateActivityHostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hostCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        cell.chooseHostGroupButton.tag = 1;
        
        [cell.chooseHostGroupButton addTarget:self action:@selector(chooseGroupButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self setGroupsLabelTitle:self.activityHostGroup label:cell.hostGroupLabel onlyOne:true];
        
        return cell;
    }
    
    if (indexPath.row == 7) {
        WACreateActivityInviteGroupsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inviteGroupsCell"];
        
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        cell.groupsButton.tag = 2;
        
        [cell.groupsButton addTarget:self action:@selector(chooseGroupButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self setGroupsLabelTitle:self.activityInvitedGroups label:cell.groupsLabel onlyOne:false];
        
        return cell;
    }
    
    if (indexPath.row == 8) {
        WACreateActivityInviteFriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inviteFriendsCell"];
        
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        [cell.friendsButton addTarget:self action:@selector(inviteFriendsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self setUsersLabel:self.activityInvitedFriends label:cell.friendsLabel];
        
        return cell;
    }
    
    if (indexPath.row == 9 && self.activityPublic == false) {
        WACreateActivityCanInviteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"canInviteCell"];
        
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        [cell.yesButton setImage:[UIImage imageNamed:(self.guestsCanInviteOthers) ? @"YesButtonPressed" : @"YesButtonReleased"] forState:UIControlStateNormal];
        [cell.noButton setImage:[UIImage imageNamed:(self.guestsCanInviteOthers) ? @"NoButtonReleased" : @"NoButtonPressed"] forState:UIControlStateNormal];
        
        [cell.yesButton addTarget:self action:@selector(guestsCanInviteOthersButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.noButton addTarget:self action:@selector(guestsCannotInviteOthersButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    WACreateActivityPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"postCell"];
    
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    [cell.postButton addTarget:self action:@selector(postButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.postView.layer.cornerRadius = 8.0;
    
    return cell;
}

#pragma mark - Button targets

- (void)activityPublicButtonPressed:(UIButton *)button {
    
    self.activityPublic = true;
    
    self.guestsCanInviteOthers = true;
    
    [self.tableView reloadData];
}

- (void)activityPrivateButtonPressed:(UIButton *)button {
    
    self.activityPublic = false;
    
    [self.tableView reloadData];
}

- (void)selectTimeButtonPressed:(UIButton *)button {
    
    WADatePickerViewController *datePicker;
    
    WACreateActivityTimeTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kTimeCellRow inSection:0]];
    
    if (button.tag == 1) {
        if (self.activityStartTime == nil && self.activityEndTime == nil) {
            self.activityStartTime = [NSDate new];
        }
        else if (self.activityStartTime == nil && self.activityEndTime != nil) {
            self.activityStartTime = self.activityEndTime;
        }
        
        datePicker = [[WADatePickerViewController alloc] initWithTitle:@"Choose Start Time" date:self.activityStartTime];
    }
    else if (button.tag == 2) {
        
        if (self.activityEndTime == nil && self.activityStartTime == nil) {
            self.activityEndTime = [NSDate new];
        }
        else if (self.activityEndTime == nil && self.activityStartTime != nil) {
            self.activityEndTime = self.activityStartTime;
        }
        
        [datePicker setDate:self.activityEndTime];
        
        if (self.activityEndTime == nil && self.activityStartTime == nil) {
            self.activityEndTime = [NSDate new];
        }
        else if (self.activityEndTime == nil && self.activityStartTime != nil) {
            self.activityEndTime = [self.activityStartTime copy];
        }
        
        datePicker = [[WADatePickerViewController alloc] initWithTitle:@"Choose End Time" date:self.activityEndTime];
    }
    
    [self setTimeTitle:self.activityStartTime label:cell.startTimeLabel];
    [self setTimeTitle:self.activityEndTime label:cell.endTimeLabel];
    
    datePicker.delegate = self;
    datePicker.view.tag = button.tag;
    
    self.definesPresentationContext = true;
    datePicker.view.backgroundColor = [[UIColor alloc] initWithWhite:0.5 alpha:0.2];
    datePicker.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    [self presentViewController:datePicker animated:false completion:nil];
}

- (void)searchLocationButtonPressed:(UIButton *)button {
    
    GMSAutocompleteViewController *autocompleteView = [[GMSAutocompleteViewController alloc] init];
    autocompleteView.delegate = self;
    [self presentViewController:autocompleteView animated:YES completion:nil];
}

- (void)chooseInterestsButtonPressed:(UIButton *)button {
    
    WAInterestPickerViewController *interestsPicker = [[WAInterestPickerViewController alloc] initWithTitle:@"Choose Interests" selectedInterests:self.activityInterests maxInterests:2];
    
    interestsPicker.view.tag = button.tag;
    
    interestsPicker.delegate = self;
    
    self.definesPresentationContext = true;
    interestsPicker.view.backgroundColor = [[UIColor alloc] initWithWhite:0.5 alpha:0.2];
    interestsPicker.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    [self presentViewController:interestsPicker animated:false completion:nil];
}

- (void)chooseGroupButtonPressed:(UIButton *) button {
    
    WAGroupPickerViewController *groupPicker = [[WAGroupPickerViewController alloc] initWithTitle:((button.tag == 1) ? @"Choose Host Group" : @"Invite Group(s)") selectedGroups:((button.tag == 1) ? self.activityHostGroup : self.activityInvitedGroups) userGroupIDs:self.userGroupIDs canSelectMultipleGourps:(button.tag == 2)];
    
    groupPicker.view.tag = button.tag;
    
    groupPicker.delegate = self;
    
    self.definesPresentationContext = true;
    groupPicker.view.backgroundColor = [[UIColor alloc] initWithWhite:0.5 alpha:0.2];
    groupPicker.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    [self presentViewController:groupPicker animated:false completion:nil];
}

- (void)inviteFriendsButtonPressed:(UIButton *)button {
    
    WAUserPickerViewController *userPicker = [[WAUserPickerViewController alloc] initWithTitle:@"Invite Friends" selectedUsers:self.activityInvitedFriends userFriendIDs:self.userFriendIDs];
    
    userPicker.view.tag = button.tag;
    
    userPicker.delegate = self;
    
    self.definesPresentationContext = true;
    userPicker.view.backgroundColor = [[UIColor alloc] initWithWhite:0.5 alpha:0.2];
    userPicker.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    [self presentViewController:userPicker animated:false completion:nil];
}

- (void)guestsCanInviteOthersButtonPressed:(UIButton *)button {
    
    self.guestsCanInviteOthers = true;
    
    [self.tableView reloadData];
}

- (void)guestsCannotInviteOthersButtonPressed:(UIButton *)button {
    
    self.guestsCanInviteOthers = false;
    
    [self.tableView reloadData];
}

- (void)postButtonPressed:(UIButton *)button {
    
    if ([self.activityTitle isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Title Required" message:@"You must enter a title for the activity." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:true completion:nil];
    }
    else if (!self.activityStartTime && !self.activityEndTime) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Times Required" message:@"You must select a start and end time for the activity." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:true completion:nil];
    }
    else if (!self.activityLocation) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Location Required" message:@"You must enter a location for the activity." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:true completion:nil];
    }
    else if ([self.activityInterests count] == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Interest Required" message:@"You must select at least one interest for the activity." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:true completion:nil];
    }
    else if (self.userVerified) {
        
        self.tableView.userInteractionEnabled = false;
        
        NSString *hostGroupID = @"";
        NSString *hostGroupName = @"";
        NSString *hostGroupShortaName = @"";
        
        if ([self.activityHostGroup count] == 1) {
            NSDictionary *group = [self.activityHostGroup objectAtIndex:0];
            
            hostGroupID = group[@"group_id"];
            hostGroupName = group[@"name"];
            hostGroupShortaName = group[@"short_name"];
        }
        
        NSMutableArray *invitedGroups = [[NSMutableArray alloc] init];
        
        for (NSDictionary *group in self.activityInvitedGroups) {
            [invitedGroups addObject:group[@"group_id"]];
        }
        
        NSMutableArray *invitedFriends = [[NSMutableArray alloc] init];
        
        for (NSDictionary *user in self.activityInvitedFriends) {
            [invitedFriends addObject:user[@"user_id"]];
        }
        
        NSLog(@"self.activityPublic: %@", (self.activityPublic) ? @"true" : @"false");
        
        [WAServer createActivity:self.activityTitle startTime:self.activityStartTime endTime:self.activityEndTime locationName:self.activityLocation.name locationAddress:self.activityLocation.formattedAddress location:[[CLLocation alloc] initWithLatitude:self.activityLocation.coordinate.latitude longitude:self.activityLocation.coordinate.longitude] interests:self.activityInterests details:self.activityDetails hostGroupID:hostGroupID hostGroupName:hostGroupName hostGroupShortName:hostGroupShortaName invitedUsers:invitedFriends invitedGroups:invitedGroups activityPublic:self.activityPublic guestsCanInviteOthers:self.guestsCanInviteOthers completion:^(BOOL success) {
            
            self.tableView.userInteractionEnabled = true;
            
            if (success) {
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Activity Posted" message:@"Your activity was successfully posted." preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [self dismissViewControllerAnimated:true completion:nil];
                }];
                
                [alert addAction:cancelAction];
                
                [self presentViewController:alert animated:true completion:nil];
            }
            else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"There was a problem posting the activity." preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
                
                [alert addAction:cancelAction];
                
                [self presentViewController:alert animated:true completion:nil];
            }
        }];
    }
}

#pragma mark - Date picker delegate

- (void)datePickerViewDateChanged:(NSDate *)date tag:(NSInteger)tag {
    
    if (tag == 1) {
        self.activityStartTime = date;
        
        if (self.activityEndTime.timeIntervalSince1970 < self.activityStartTime.timeIntervalSince1970) {
            self.activityEndTime = self.activityStartTime;
        }
    }
    else if (tag == 2) {
        self.activityEndTime = date;
        
        if (self.activityEndTime.timeIntervalSince1970 < self.activityStartTime.timeIntervalSince1970) {
            self.activityStartTime = self.activityEndTime;
        }
    }
    
    WACreateActivityTimeTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kTimeCellRow inSection:0]];
    [self setTimeTitle:self.activityStartTime label:cell.startTimeLabel];
    [self setTimeTitle:self.activityEndTime label:cell.endTimeLabel];
    
}

- (void)setTimeTitle:(NSDate *)date label:(UILabel *)label {
    
    if (date != nil) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterShortStyle;
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
        
        label.text = [dateFormatter stringFromDate:date];
        
        label.textColor = self.selectedColor;
    }
}

#pragma mark - Places autocomplete view delegate

- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    
    self.activityLocation = place;
    
    NSLog(@"Place name %@", place.name);
    NSLog(@"Place address %@", place.formattedAddress);
    NSLog(@"Place coordinates %f, %f", place.coordinate.latitude, place.coordinate.longitude);
    
    [self.tableView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Group picker delegate

- (void)groupPickerViewGroupSelected:(NSArray *)groups tag:(NSInteger)tag {
    
    if (tag == 1) {
        self.activityHostGroup = groups;
        
        WACreateActivityHostTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kHostCellRow inSection:0]];
        [self setGroupsLabelTitle:self.activityHostGroup label:cell.hostGroupLabel onlyOne:true];
    }
    else if (tag == 2) {
        self.activityInvitedGroups = groups;
        
        WACreateActivityInviteGroupsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kInviteGroupsCellRow inSection:0]];
        [self setGroupsLabelTitle:self.activityInvitedGroups label:cell.groupsLabel onlyOne:false];
    }
}

- (void)setGroupsLabelTitle:(NSArray *)groups label:(UILabel *)label onlyOne:(BOOL)onlyOne {
    
    NSString *groupsString = @"";
    
    if ([groups count] > 0) {
        
        int count = 0;
        for (NSDictionary *group in groups) {
            
            groupsString = [groupsString stringByAppendingString:group[@"short_name"]];
            
            if (count != [groups count]-1) {
                groupsString = [groupsString stringByAppendingString:@", "];
            }
            
            count++;
        }
        
        label.textColor = self.selectedColor;
    }
    else {
        if (onlyOne) {
            groupsString = @"Group";
        }
        else {
            groupsString = @"Group(s)";
        }
        
        label.textColor = self.notSelectedColor;
    }
    
    label.text = groupsString;
}

#pragma mark - User picker delegate

- (void)userPickerViewUserSelected:(NSArray *)users tag:(NSInteger)tag {
    
    self.activityInvitedFriends = users;
    
    WACreateActivityInviteFriendsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kInviteFriendsCellRow inSection:0]];
    [self setUsersLabel:self.activityInvitedFriends label:cell.friendsLabel];
}

- (void)setUsersLabel:(NSArray *)users label:(UILabel *)label {
    
    NSString *usersString = @"";
    
    if ([users count] > 0) {
        
        int count = 0;
        for (NSDictionary *user in users) {
            
            usersString = [usersString stringByAppendingString:user[@"name"]];
            
            if (count != [users count]-1) {
                usersString = [usersString stringByAppendingString:@", "];
            }
            
            count++;
        }
        
        label.textColor = self.selectedColor;
    }
    else {
        
        usersString = @"Friend(s)";
        
        label.textColor = self.notSelectedColor;
    }
    
    label.text = usersString;
}

#pragma mark - Interests picker delegate

- (void)intersPickerViewUserSelected:(NSArray *)interests tag:(NSInteger)tag {
    
    self.activityInterests = interests;
    
    WACreateActivityInterestsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kInterestsCellRow inSection:0]];
    [self setInterestsLabel:self.activityInterests label:cell.interestsLabel];
}

- (void)setInterestsLabel:(NSArray *)interests label:(UILabel *)label {
    
    NSString *interestsString = @"";
    
    if ([interests count] > 0) {
        
        int count = 0;
        for (NSString *interest in interests) {
            
            interestsString = [interestsString stringByAppendingString:interest];
            
            if (count != [interests count]-1) {
                interestsString = [interestsString stringByAppendingString:@", "];
            }
            
            count++;
        }
        
        label.textColor = [WAValues selectedTextColor];
    }
    else {
        
        interestsString = @"Interest(s)";
        
        label.textColor = [WAValues notSelectedTextColor];
    }
    
    label.text = interestsString;
}

#pragma mark - Text field delegate

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
    
    if (textField.tag == 1) {
        self.activityTitle = textField.text;
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return false;
}

#pragma mark - Text view delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if (textView.tag == 1) {
        if ([self.activityDetails isEqualToString:@""]) {
            textView.textColor = self.selectedColor;
            textView.text = @"";
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if (textView.tag == 1) {
        self.activityDetails = textView.text;
        
        if ([self.activityDetails isEqualToString:@""]) {
            textView.textColor = self.notSelectedColor;
            textView.text = @"Details";
        }
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

#pragma mark - Location manager delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations {
    
    if (self.firstUserLocationUpdate) {
        self.firstUserLocationUpdate = false;
        
        self.userLocation = locations[0];
        
        [self.tableView reloadData];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if (self.firstUserLocationUpdate) {
        self.firstUserLocationUpdate = false;
        
        self.userLocation = [change objectForKey:NSKeyValueChangeNewKey];
        
        [self.tableView reloadData];
    }
}

@end
