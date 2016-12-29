//
//  WACreateActivityTableViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/17/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WACreateActivityTableViewController.h"

#import "WAValues.h"

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
    
    self.tableView.backgroundColor = [[UIColor alloc] initWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
    
    // Initialize default values
    
    self.notSelectedColor = [[UIColor alloc] initWithRed:189.0/255.0 green:189.0/255.0 blue:195.0/255.0 alpha:1.0];
    self.selectedColor = [[UIColor alloc] initWithRed:143.0/255.0 green:142.0/255.0 blue:148.0/255.0 alpha:1.0];
    
    self.firstUserLocationUpdate = true;
    
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
    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    autocompleteView.autocompleteFilter = filter;
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
    
    WAGroup *group1 = [[WAGroup alloc] initWithName:@"Something Borrowed Something Blue" shortName:@"SBSB" groupID:@"1" color:[UIColor orangeColor]];
    WAGroup *group2 = [[WAGroup alloc] initWithName:@"Mechanical Engineers" shortName:@"MechEng" groupID:@"2" color:[UIColor purpleColor]];
    WAGroup *group3 = [[WAGroup alloc] initWithName:@"Residential Assisstants" shortName:@"RA" groupID:@"3" color:[UIColor greenColor]];
    
    WAGroupPickerViewController *groupPicker = [[WAGroupPickerViewController alloc] initWithTitle:((button.tag == 1) ? @"Choose Host Group" : @"Invite Group(s)") selectedGroups:((button.tag == 1) ? self.activityHostGroup : self.activityInvitedGroups) allGroups:@[group1, group2, group3] canSelectMultipleGourps:(button.tag == 2)];
    
    groupPicker.view.tag = button.tag;
    
    groupPicker.delegate = self;
    
    self.definesPresentationContext = true;
    groupPicker.view.backgroundColor = [[UIColor alloc] initWithWhite:0.5 alpha:0.2];
    groupPicker.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    [self presentViewController:groupPicker animated:false completion:nil];
}

- (void)inviteFriendsButtonPressed:(UIButton *)button {
    
    WAUser *user1 = [[WAUser alloc] initWithFirstName:@"Ben" lastName:@"Yang" userID:@"1" classYear:@"Freshman" major:@"Computer Science" image:nil];
    WAUser *user2 = [[WAUser alloc] initWithFirstName:@"Alexis" lastName:@"Angel" userID:@"2" classYear:@"Freshman" major:@"Economics" image:nil];
    WAUser *user3 = [[WAUser alloc] initWithFirstName:@"Mia" lastName:@"Carlson" userID:@"3" classYear:@"Freshman" major:@"Pre-med" image:nil];
    
    WAUserPickerViewController *userPicker = [[WAUserPickerViewController alloc] initWithTitle:@"Invite Friends" selectedUsers:self.activityInvitedFriends allUsers:@[user1, user2, user3]];
    
    userPicker.view.tag = button.tag;
    
    userPicker.delegate = self;
    
    self.definesPresentationContext = true;
    userPicker.view.backgroundColor = [[UIColor alloc] initWithWhite:0.5 alpha:0.2];
    userPicker.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    [self presentViewController:userPicker animated:false completion:nil];
}

- (void)guestsCanInviteOthersButtonPressed:(UIButton *)button {
    
}

- (void)guestsCannotInviteOthersButtonPressed:(UIButton *)button {
    
}

- (void)postButtonPressed:(UIButton *)button {
    
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
        for (WAGroup *group in groups) {
            
            groupsString = [groupsString stringByAppendingString:group.shortName];
            
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
        for (WAUser *user in users) {
            
            usersString = [usersString stringByAppendingString:user.firstName];
            
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
        for (NSNumber *index in interests) {
            
            interestsString = [interestsString stringByAppendingString:[WAValues interestsArray][index.integerValue][0]];
            
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

#pragma mark - KVO updates

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if (self.firstUserLocationUpdate) {
        self.firstUserLocationUpdate = false;
        
        self.userLocation = [change objectForKey:NSKeyValueChangeNewKey];
        
        [self.tableView reloadData];
    }
}

@end
