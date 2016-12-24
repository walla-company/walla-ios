//
//  WACreateActivityTableViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/17/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WACreateActivityTableViewController.h"

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
    [self.tableView registerNib:[UINib nibWithNibName:@"WACreateActivityExtraTableViewCell" bundle:nil] forCellReuseIdentifier:@"extraCell"];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100.0;
    
    self.tableView.showsVerticalScrollIndicator = false;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    // Initialize default values
    self.activityPublic = true;
    
    self.notSelectedColor = [[UIColor alloc] initWithRed:189.0/255.0 green:189.0/255.0 blue:195.0/255.0 alpha:1.0];
    self.selectedColor = [[UIColor alloc] initWithRed:143.0/255.0 green:142.0/255.0 blue:148.0/255.0 alpha:1.0];
    
    self.activityTitle = @"";
    self.activityDetails = @"";
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
        WACreateActivityAudienceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"audienceCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        
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
        
        cell.activityTitleTextField.tag = 1;
        cell.activityTitleTextField.delegate = self;
        
        return cell;
    }
    
    if (indexPath.row == 2) {
        WACreateActivityTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"timeCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        
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
        
        cell.locationMapView.userInteractionEnabled = false;
        
        cell.locationMapView.layer.cornerRadius = 8.0;
        
        return cell;
    }
    
    if (indexPath.row == 4) {
        WACreateActivityDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailsCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        
        cell.detailsTextView.tag = 1;
        cell.detailsTextView.scrollEnabled = false;
        cell.detailsTextView.delegate = self;
        
        if ([self.activityDetails isEqual: @""]) {
            cell.detailsTextView.textColor = self.notSelectedColor;
            cell.detailsTextView.text = @"Details";
        }
        
        return cell;
    }
    
    if (indexPath.row == 5) {
        WACreateActivityHostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hostCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        
        cell.chooseHostGroupButton.tag = 1;
        
        [cell.chooseHostGroupButton addTarget:self action:@selector(chooseGroupButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    WACreateActivityExtraTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"extraCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    
    return cell;
}

#pragma mark - Button targets

- (void)activityPublicButtonPressed:(UIButton *)button {
    
    self.activityPublic = true;
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)activityPrivateButtonPressed:(UIButton *)button {
    
    self.activityPublic = false;
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)selectTimeButtonPressed:(UIButton *)button {
    
    WADatePickerViewController *datePicker;// = [[WADatePickerViewController alloc] init];
    
    WACreateActivityTimeTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
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

- (void)setTimeTitle:(NSDate *)date label:(UILabel *)label {
    
    if (date != nil) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterShortStyle;
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
        
        label.text = [dateFormatter stringFromDate:date];
        
        label.textColor = self.selectedColor;
    }
}

- (void)chooseGroupButtonPressed:(UIButton *) button {
    
    if (button.tag == 1) {
        
        WAGroupPickerViewController *groupPicker = [[WAGroupPickerViewController alloc] initWithTitle:@"Choose Host Group" selectedGroups:@[] allGroups:@[]];
        
        groupPicker.view.tag = 1;
        
        groupPicker.delegate = self;
        
        self.definesPresentationContext = true;
        groupPicker.view.backgroundColor = [[UIColor alloc] initWithWhite:0.5 alpha:0.2];
        groupPicker.modalPresentationStyle = UIModalPresentationOverFullScreen;
        
        [self presentViewController:groupPicker animated:false completion:nil];
        
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
    
    WACreateActivityTimeTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    [self setTimeTitle:self.activityStartTime label:cell.startTimeLabel];
    [self setTimeTitle:self.activityEndTime label:cell.endTimeLabel];
    
}

#pragma mark - Group picker delegate

- (void)groupPickerViewGroupSelected:(NSArray *)groups tag:(NSInteger)tag {
    
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
        NSLog(@"self.activityDetails: %@", self.activityDetails);
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

@end
