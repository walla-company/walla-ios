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

#import "SuccessfullPostViewController.h"

double const WAMaximumDescriptionLength = 200;

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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WACreateActivityDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"detailsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WACreateActivityTimeTableViewCell" bundle:nil] forCellReuseIdentifier:@"timeCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WACreateActivityMeetingPlaceTableViewCell" bundle:nil] forCellReuseIdentifier:@"meetingPlaceCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WACreateActivityLocationTableViewCell" bundle:nil] forCellReuseIdentifier:@"locationCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WACreateActivityHostTableViewCell" bundle:nil] forCellReuseIdentifier:@"hostCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WACreateActivityFoodTableViewCell" bundle:nil] forCellReuseIdentifier:@"foodCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WACreateActivityPostTableViewCell" bundle:nil] forCellReuseIdentifier:@"postCell"];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100.0;
    
    self.tableView.showsVerticalScrollIndicator = false;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    // Initialize default values
    
    self.notSelectedColor = [[UIColor alloc] initWithRed:164.0/255.0 green:163.0/255.0 blue:168.0/255.0 alpha:1.0];
    self.selectedColor = [UIColor blackColor];
    
    self.firstUserLocationUpdate = true;
    
    self.mapViews = [[NSMutableArray alloc] init];
    
    self.activityTitle = @"";
    self.activityStartTime = nil;
    self.meetingPlace = @"";
    self.activityLocation = nil;
    self.activityHostGroup = [[NSArray alloc] init];
    self.freeFood = false;
    
    self.userGroupIDs = [[NSArray alloc] init];
    
    self.userVerified = false;
    
    self.activityLocation = nil;
    
    [WAServer getUserGroupsWithID:[FIRAuth auth].currentUser.uid completion:^(NSArray *groups) {
        self.userGroupIDs = groups;
    }];
    
    self.titlePlaceHolder = @"Pick up basketball? Biochemistry seminar? Club event? Study buddy? Art buddy? Create an activity to find a friend or two to tag along!";
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
#warning ST - return this later after backend fixes
    //[self verifyUser];
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
    
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        WACreateActivityDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailsCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        cell.titleTextView.scrollEnabled = false;
        cell.titleTextView.delegate = self;
        
        if ([self.activityTitle isEqual: @""]) {
            cell.titleTextView.textColor = self.notSelectedColor;
            cell.titleTextView.text = self.titlePlaceHolder;
        }
        else {
            cell.titleTextView.textColor = self.selectedColor;
            cell.titleTextView.text = self.activityTitle;
        }
        
        return cell;
    }
    
    if (indexPath.row == 1) {
        WACreateActivityTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"timeCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        [cell.startTimeButton addTarget:self action:@selector(selectTimeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.activityStartTime != nil) {
            [self setTimeTitle:self.activityStartTime label:cell.startTimeLabel];
            cell.startTimeLabel.textColor = self.selectedColor;
        }
        else {
            cell.startTimeLabel.text = @"Pick date and time";
            cell.startTimeLabel.textColor = self.notSelectedColor;
        }
        
        return cell;
    }
    
    if (indexPath.row == 2) {
        WACreateActivityMeetingPlaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"meetingPlaceCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        cell.meetingPlaceTextField.delegate = self;
        
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
            cell.locationLabel.text = @"Enter Location";
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
        WACreateActivityHostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hostCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        cell.chooseHostGroupButton.tag = 1;
        
        [cell.chooseHostGroupButton addTarget:self action:@selector(chooseGroupButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self setGroupsLabelTitle:self.activityHostGroup label:cell.hostGroupLabel onlyOne:true];
        
        return cell;
    }
    
    if (indexPath.row == 5) {
        WACreateActivityFoodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"foodCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        [cell.freeFoodButton addTarget:self action:@selector(freeFoodButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.freeFoodLabel.text = (self.freeFood) ? @"Yes" : @"No";
        
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

- (void)selectTimeButtonPressed:(UIButton *)button {
    
    WADatePickerViewController *datePicker;
    
    WACreateActivityTimeTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kTimeCellRow inSection:0]];
    
    if (self.activityStartTime == nil) {
        self.activityStartTime = [NSDate new];
    }
    
    datePicker = [[WADatePickerViewController alloc] initWithTitle:@"Choose Time" date:self.activityStartTime];
    
    [self setTimeTitle:self.activityStartTime label:cell.startTimeLabel];
    
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

- (void)chooseGroupButtonPressed:(UIButton *) button {
    
    WAGroupPickerViewController *groupPicker = [[WAGroupPickerViewController alloc] initWithTitle: @"Choose Host Group" selectedGroups:self.activityHostGroup userGroupIDs:self.userGroupIDs canSelectMultipleGourps:false];
    
    groupPicker.delegate = self;
    
    self.definesPresentationContext = true;
    groupPicker.view.backgroundColor = [[UIColor alloc] initWithWhite:0.5 alpha:0.2];
    groupPicker.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    [self presentViewController:groupPicker animated:false completion:nil];
}

- (void)freeFoodButtonPressed:(UIButton *)button {
    
    UIAlertController *levelMenu = [UIAlertController alertControllerWithTitle:@"Is there free food?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *option1 = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler: ^(UIAlertAction *action){
        
        self.freeFood = true;
        
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    UIAlertAction *option2 = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler: ^(UIAlertAction *action){
        
        self.freeFood = false;
        
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [levelMenu addAction:option1];
    [levelMenu addAction:option2];
    
    [levelMenu addAction:cancelAction];
    
    [self presentViewController:levelMenu animated:true completion:nil];
    
}

- (void)postButtonPressed:(UIButton *)button {
    
    NSLog(@"Title: %@", self.activityTitle);
    NSLog(@"Start time: %@", self.activityStartTime);
    NSLog(@"Meeting place: %@", self.meetingPlace);
    NSLog(@"Location: %@", self.activityLocation);
    NSLog(@"Host group: %@", self.activityHostGroup);
    NSLog(@"Free food: %@", (self.freeFood) ? @"Yes" : @"No");
    
    if ([self.activityTitle isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Description Required" message:@"You have to tell us what this activity is about." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:true completion:nil];
    }
    else if ([self.activityTitle length] > 500) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Description Too Long" message:@"Your description has to be less than 500 characters." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:true completion:nil];
    }
    else if (!self.activityStartTime) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Time Required" message:@"You have to tell us when this activity begins." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:true completion:nil];
    }
    else if ([self.meetingPlace isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Meeting Place Required" message:@"You have to tell us where you're meeting." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:true completion:nil];
    }
    else {//if (self.userVerified) {
        
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
        
        NSArray *interests = (self.freeFood) ? @[@"Free Food"] : @[];
        
        CLLocation *activityLocation = [[CLLocation alloc] initWithLatitude:0 longitude:0];
        NSString *activityAddress = @"";
        
        if (self.activityLocation) {
            activityLocation = [[CLLocation alloc] initWithLatitude:self.activityLocation.coordinate.latitude longitude:self.activityLocation.coordinate.longitude] ;
            activityAddress = self.activityLocation.formattedAddress;
        }
        
        __weak typeof(self) weakSelf = self;

        [WAServer createActivity:self.activityTitle startTime:self.activityStartTime endTime:self.activityStartTime locationName:self.meetingPlace locationAddress:activityAddress location:activityLocation interests:interests hostGroupID:hostGroupID hostGroupName:hostGroupName hostGroupShortName:hostGroupShortaName completion:^(BOOL success) {
            
            self.tableView.userInteractionEnabled = true;
            
            if (success) {
                UIViewController *presentingController = weakSelf.presentingViewController;
                [weakSelf dismissViewControllerAnimated:YES completion:^{
                    [SuccessfullPostViewController presentFromViewController:presentingController];
                }];
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
    
    self.activityStartTime = date;
    
    WACreateActivityTimeTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kTimeCellRow inSection:0]];
    [self setTimeTitle:self.activityStartTime label:cell.startTimeLabel];
    
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
    
    self.activityLocation = nil;
    
    [self.tableView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Group picker delegate

- (void)groupPickerViewGroupSelected:(NSArray *)groups tag:(NSInteger)tag {
    
    self.activityHostGroup = groups;
    
    WACreateActivityHostTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kHostCellRow inSection:0]];
    [self setGroupsLabelTitle:self.activityHostGroup label:cell.hostGroupLabel onlyOne:true];
}

- (void)setGroupsLabelTitle:(NSArray *)groups label:(UILabel *)label onlyOne:(BOOL)onlyOne {
    
    NSString *groupsString = @"";
    
    if ([groups count] > 0) {
        
        int count = 0;
        for (NSDictionary *group in groups) {
            
            groupsString = [groupsString stringByAppendingString:group[@"name"]];
            
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

#pragma mark - Text field delegate

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
    
    self.meetingPlace = textField.text;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    self.meetingPlace = textField.text;
    
    return true;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    self.meetingPlace = textField.text;
    
    [textField resignFirstResponder];
    
    return false;
}

#pragma mark - Text view delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if ([self.activityTitle isEqualToString:@""]) {
        textView.textColor = self.selectedColor;
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    self.activityTitle = textView.text;
    
    if ([self.activityTitle isEqualToString:@""]) {
        textView.textColor = self.notSelectedColor;
        textView.text = self.titlePlaceHolder;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    
    self.activityTitle = textView.text;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    WACreateActivityDetailsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kDetailsCellRow]];
    [cell setMaximumCharactersLabelCurrent:textView.text.length];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *resultingString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (resultingString.length > WAMaximumDescriptionLength) {
        return NO;
    }
    return YES;
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

#pragma mark - Supporting functions

- (void)verifyUser {
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

@end
