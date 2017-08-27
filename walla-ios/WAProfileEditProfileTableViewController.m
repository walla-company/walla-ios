//
//  WAProfileEditProfileTableViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/27/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WAProfileEditProfileTableViewController.h"
#import "WAEditProfileTableViewCell.h"
#import "WAInfoProfileTableViewCell.h"
#import "WAEmojiProfileTableViewCell.h"
#import "NSString+EMOEmoji.h"
#import "WAValues.h"
#import "WAServer.h"
#import "MBProgressHUD.h"
static NSString *editProfileCellIdentifier = @"WAEditProfileTableViewCell";
static NSString *infoProfileCellIdentifier = @"WAInfoProfileTableViewCell";
static NSString *emojiProfileCellIdentifier = @"WAEmojiProfileTableViewCell";

typedef enum EditProfileTextField {
    EditProfileFirstNameTextField = 1000,
    EditProfileLastNameTextField = 2000,
    EditProfileGraduationYearTextField = 3000,
    EditProfileMajorTextField = 4000,
    EditProfileHometownTextField = 5000,
    EditProfileDetailsTextField = 6000,
    EditProfileReasonSchoolTextField = 7000,
    EditProfileWannaMeetTextField = 8000,
    EditProfileGoal1TextField = 9000,
    EditProfileGoal2TextField = 10000,
    EditProfileGoal3TextField = 11000,
    EditProfileSignatureEmojiTextField = 12000
} EditProfileTextField;


@import Firebase;

@interface WAProfileEditProfileTableViewController ()
@property BOOL isUserDataUpdated;
@end

@implementation WAProfileEditProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Edit Profile";
    // Set up table view
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"WAEditProfileTableViewCell" bundle:nil] forCellReuseIdentifier:editProfileCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"WAInfoProfileTableViewCell" bundle:nil] forCellReuseIdentifier:infoProfileCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"WAEmojiProfileTableViewCell" bundle:nil] forCellReuseIdentifier:emojiProfileCellIdentifier];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.showsVerticalScrollIndicator = false;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    self.groupsDictionary = [[NSMutableDictionary alloc] init];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonPressed:)];

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    __weak typeof(self) weakSelf = self;
    [WAServer getUserWithID:[FIRAuth auth].currentUser.uid completion:^(WAUser *user){
        
        weakSelf.user = user;
        weakSelf.isUserDataUpdated = false;
        [weakSelf.tableView reloadData];
        
//        if (self.loadProfilePhoto) {
//            [self loadProfileImage];
//        }
    }];
    
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"openEditProfile"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        if (self.isUserDataUpdated) {
            [WAServer updateUser:self.user completion: nil];
        }
    }
    [super viewWillDisappear:animated];
}
- (void)loadProfileImage {
    
    NSLog(@"Load profile photo");
    
    if (![self.user.profileImageURL isEqualToString:@""]) {
        
        NSLog(@"profileImageURL: %@", self.user.profileImageURL);
        
        FIRStorage *storage = [FIRStorage storage];
        
        FIRStorageReference *imageRef = [storage referenceForURL:self.user.profileImageURL];;
        
        [imageRef dataWithMaxSize:10 * 1024 * 1024 completion:^(NSData *data, NSError *error) {
            if (error != nil) {
                
                NSLog(@"Error downloading profile image: %@", error);
                
            } else {
                
//                self.profileImage = [UIImage imageWithData:data];
                [self.tableView reloadData];
            }
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    int mandatoryRows = [self.user.groups count] > 0 ? 8 : 7;
//    if (self.user) return mandatoryRows + [self.user.groups count];
//    
    return 14;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        WAEditProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:editProfileCellIdentifier forIndexPath:indexPath];
        cell.cellTitleLabel.text = @"First name";
        cell.textView.text = self.user.firstName;
        cell.textView.tag = EditProfileFirstNameTextField;
        cell.textViewHeightConstraint.constant = 30;
        [self setupCell:cell];
        return cell;
    } else if (indexPath.row == 1){
        WAEditProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:editProfileCellIdentifier forIndexPath:indexPath];
        cell.cellTitleLabel.text = @"Last name";
        cell.textView.text = self.user.lastName;
        cell.textView.tag = EditProfileLastNameTextField;
        cell.textViewHeightConstraint.constant = 30;
        [self setupCell:cell];
        return cell;
    } else if (indexPath.row == 2){
        WAEditProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:editProfileCellIdentifier forIndexPath:indexPath];
        cell.cellTitleLabel.text = @"Graduation year";
        cell.textView.text = self.user.graduationYear;
        cell.textView.tag = EditProfileGraduationYearTextField;
        cell.placeholderLabel.text = cell.cellTitleLabel.text;
        cell.textViewHeightConstraint.constant = 30;
        [self setupCell:cell];
        cell.charsLabel.hidden = YES;
        return cell;
    } else if (indexPath.row == 3){
        WAEditProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:editProfileCellIdentifier forIndexPath:indexPath];
        cell.cellTitleLabel.text = @"Major";
        cell.textView.text = self.user.major;
        cell.textView.tag = EditProfileMajorTextField;
        cell.placeholderLabel.text = cell.cellTitleLabel.text;
        cell.textViewHeightConstraint.constant = 30;
        [self setupCell:cell];
        return cell;
    } else if (indexPath.row == 4){
        WAEditProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:editProfileCellIdentifier forIndexPath:indexPath];
        cell.cellTitleLabel.text = @"Where are you from?";
        cell.textView.text = self.user.hometown;
        cell.textView.tag = EditProfileHometownTextField;
        cell.placeholderLabel.text = @"City, Country";
        cell.textViewHeightConstraint.constant = 30;
        [self setupCell:cell];
        return cell;
    } else if (indexPath.row == 5){
        WAEditProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:editProfileCellIdentifier forIndexPath:indexPath];
        cell.cellTitleLabel.text = @"Describe yourself in a few sentences.";
        cell.textView.text = self.user.details;
        cell.textView.tag = EditProfileDetailsTextField + 200;
        cell.placeholderLabel.text = @"What do you enjoy doing? What type of person are you? Why did you pick your major?";
        cell.textViewHeightConstraint.constant = 120;
        [self setupCell:cell];
        return cell;
    } else if (indexPath.row == 6){
        WAEditProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:editProfileCellIdentifier forIndexPath:indexPath];
        cell.cellTitleLabel.text = @"Why did you pick Duke?";
        cell.textView.text = self.user.reasonSchool;
        cell.textView.tag = EditProfileReasonSchoolTextField + 200;
        cell.placeholderLabel.text = @"What do you like about campus or the people?";
        cell.textViewHeightConstraint.constant = 120;
        [self setupCell:cell];
        return cell;
    } else if (indexPath.row == 7){
        WAEditProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:editProfileCellIdentifier forIndexPath:indexPath];
        cell.cellTitleLabel.text = @"Who would you like to meet this year?";
        cell.textView.text = self.user.wannaMeet;
        cell.textView.tag = EditProfileWannaMeetTextField + 200;
        cell.placeholderLabel.text = @"What kind of friends would you like to make this year? What qualities would make these connections meaningful?";
        cell.textViewHeightConstraint.constant = 120;
        [self setupCell:cell];
        return cell;
    } else if (indexPath.row == 8){
        WAInfoProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:infoProfileCellIdentifier forIndexPath:indexPath];
        cell.cellTitleLabel.text = @"What are your goals this year?";
        cell.cellSubtitleLabel.text = @"These can be academic, social or personal goals.";
        return cell;
    } else if (indexPath.row == 9){
        WAEditProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:editProfileCellIdentifier forIndexPath:indexPath];
        cell.cellTitleLabel.text = @"Goal 1";
        cell.textView.text = self.user.goal1;
        cell.textView.tag = EditProfileGoal1TextField + 100;
        cell.placeholderLabel.text = @"ex. Learn a martial art";
        cell.textViewHeightConstraint.constant = 60;
        [self setupCell:cell];
        return cell;
    } else if (indexPath.row == 10){
        WAEditProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:editProfileCellIdentifier forIndexPath:indexPath];
        cell.cellTitleLabel.text = @"Goal 2";
        cell.textView.text = self.user.goal2;
        cell.textView.tag = EditProfileGoal2TextField + 100;
        cell.placeholderLabel.text = @"ex. Become involved in student politics";
        cell.textViewHeightConstraint.constant = 60;
        [self setupCell:cell];
        return cell;
    } else if (indexPath.row == 11){
        WAEditProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:editProfileCellIdentifier forIndexPath:indexPath];
        cell.cellTitleLabel.text = @"Goal 3";
        cell.textView.text = self.user.goal3;
        cell.textView.tag = EditProfileGoal3TextField + 100;
        cell.placeholderLabel.text = @"ex. Volunteer locally";
        cell.textViewHeightConstraint.constant = 60;
        [self setupCell:cell];
        return cell;
    } else if (indexPath.row == 12){
        WAInfoProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:infoProfileCellIdentifier forIndexPath:indexPath];
        cell.cellTitleLabel.text = @"Pick your signature emoji!";
        cell.cellSubtitleLabel.text = @"Your emoji will be displayed after your  name when you post or comment.";
        return cell;
    } else {
        WAEmojiProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:emojiProfileCellIdentifier forIndexPath:indexPath];
        cell.textView.text = self.user.signatureEmoji;
        cell.textView.tag = EditProfileSignatureEmojiTextField + 1;
        cell.textView.delegate = self;
        return cell;
    }
}

- (void)setupCell:(WAEditProfileTableViewCell *)cell {
    cell.textView.delegate = self;
    cell.placeholderLabel.hidden = cell.textView.text.length > 0;
    NSInteger textViewTag = cell.textView.tag  - (cell.textView.tag / 1000) * 1000;
    cell.charsLabel.hidden = textViewTag == 0;
    cell.charsLabel.text = [NSString stringWithFormat:@"%lu/%li chars", (unsigned long)cell.textView.text.length, (long)textViewTag];
}

#pragma mark - Button targets

- (void)chooseAcademicLevelButtonPressed:(UIButton *)button {
    
    UIAlertController *levelMenu = [UIAlertController alertControllerWithTitle:@"Academic Level" message:@"Choose an option" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *option1 = [UIAlertAction actionWithTitle:@"Undergraduate" style:UIAlertActionStyleDefault handler: ^(UIAlertAction *action){
        
        self.user.academicLevel = @"undergrad";
        
        [WAServer updateUserAcademicLevel:self.user.academicLevel completion:nil];
        
        [self.tableView reloadData];
    }];
    UIAlertAction *option2 = [UIAlertAction actionWithTitle:@"Grad/Prof" style:UIAlertActionStyleDefault handler: ^(UIAlertAction *action){
        
        self.user.academicLevel = @"grad";
        
        [WAServer updateUserAcademicLevel:self.user.academicLevel completion:nil];
        
        [self.tableView reloadData];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [levelMenu addAction:option1];
    [levelMenu addAction:option2];
    
    [levelMenu addAction:cancelAction];
    
    [self presentViewController:levelMenu animated:true completion:nil];
    
}

- (void)chooseYearButtonPressed {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSInteger yearInt = [[formatter stringFromDate:[NSDate date]] integerValue];
    
    UIAlertController *yearMenu = [UIAlertController alertControllerWithTitle:@"Graduation Year" message:@"Choose an option" preferredStyle:UIAlertControllerStyleAlert];
    
    for (int i=0; i < 6; i++) {
        
        UIAlertAction *option = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%ld", (long) yearInt + i] style:UIAlertActionStyleDefault handler: ^(UIAlertAction *action){
            
            self.user.graduationYear = [NSString stringWithFormat:@"%ld", (long) yearInt + i];
            
            [WAServer updateUserGraduationYear:yearInt + i completion:nil];
            
            [self.tableView reloadData];
        }];
        
        [yearMenu addAction:option];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [yearMenu addAction:cancelAction];
    
    [self presentViewController:yearMenu animated:true completion:nil];
}


- (void)leaveGroupButtonPressed:(UIButton *) button {
    
    NSString *groupID = self.user.groups[button.tag];
    
    [WAServer leaveGroup:groupID completion:nil];
    
    NSMutableArray *groupsArray = [[NSMutableArray alloc] initWithArray:self.user.groups];
    
    [groupsArray removeObject:groupID];
    
    self.user.groups = groupsArray;
    
    [self.tableView reloadData];
}

- (void)addGroupButtonPressed:(UIButton *)button {
    
    [self performSegueWithIdentifier:@"openAddGroup" sender:self];
}

- (void)saveButtonPressed:(UIBarButtonItem *)button {
    [self.view endEditing:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WAServer updateUser:self.user completion:^(BOOL success) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void) backButtonPressed: (UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Text field delegate

//- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
//    
//    if (textField.tag == 1) {
//        
//        self.user.firstName = textField.text;
//        
//        [WAServer updateUserFirstName:self.user.firstName completion:nil];
//    }
//    else if (textField.tag == 2) {
//        
//        self.user.lastName = textField.text;
//        
//        [WAServer updateUserLastName:self.user.lastName completion:nil];
//    }
//    else if (textField.tag == 3) {
//        
//        self.user.major = textField.text;
//        
//        [WAServer updateUserMajor:self.user.major completion:nil];
//    }
//    else if (textField.tag == 4) {
//        
//        self.user.hometown = textField.text;
//        
//        [WAServer updateUserHometown:self.user.hometown completion:nil];
//    }
//}

#pragma mark - Text view delegate

- (UILabel *)charsLabelFromView:(UIView *)view {
    return (UILabel *)[[[view superview] superview] viewWithTag:2000];
}

- (UILabel *)placeholderLabelFromView:(UIView *)view {
    return (UILabel *)[[view superview] viewWithTag:1000];
}


- (void)textViewDidBeginEditing:(UITextView *)textView {
    UILabel *label = [self placeholderLabelFromView:textView];
    if (label != nil) {
        label.hidden = YES;
    }
    NSInteger originTag = (textView.tag / 1000) * 1000;

    if (originTag == EditProfileGraduationYearTextField) {
        [textView resignFirstResponder];
        [self chooseYearButtonPressed];
    }

    
//    if ([self.user.details isEqualToString:@""]) {
//        textView.textColor = [WAValues selectedTextColor];
//        textView.text = @"";
//    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    UILabel *label = [self placeholderLabelFromView:textView];
    if (label != nil) {
        label.hidden = textView.text.length > 0;
    }
    NSInteger originTag = (textView.tag / 1000) * 1000;
    if (originTag == EditProfileFirstNameTextField) {
        self.user.firstName = textView.text;
    } else if (originTag == EditProfileLastNameTextField) {
        self.user.lastName = textView.text;
    } else if (originTag == EditProfileGraduationYearTextField) {
        self.user.graduationYear = textView.text;
    } else if (originTag == EditProfileMajorTextField) {
        self.user.major = textView.text;
    } else if (originTag == EditProfileHometownTextField) {
        self.user.hometown = textView.text;
    } else if (originTag == EditProfileDetailsTextField) {
        self.user.details = textView.text;
    } else if (originTag == EditProfileReasonSchoolTextField) {
        self.user.reasonSchool = textView.text;
    } else if (originTag == EditProfileWannaMeetTextField) {
        self.user.wannaMeet = textView.text;
    } else if (originTag == EditProfileGoal1TextField) {
        self.user.goal1 = textView.text;
    } else if (originTag == EditProfileGoal2TextField) {
        self.user.goal2 = textView.text;
    } else if (originTag == EditProfileGoal3TextField) {
        self.user.goal3 = textView.text;
    } else if (originTag == EditProfileSignatureEmojiTextField) {
        self.user.signatureEmoji = textView.text;
    }


    
//    self.user.details = textView.text;
//    
//    if ([self.user.details isEqualToString:@""]) {
//        textView.textColor = [WAValues notSelectedTextColor];
//        textView.text = WADetailsPlaceholderText;
//    }
//    
//    [WAServer updateUserDescription:self.user.details completion:nil];
}

- (void)textViewDidChange:(UITextView *)textView {
    UILabel *label = [self charsLabelFromView:textView];
    NSInteger maxChars = textView.tag  - (textView.tag / 1000) * 1000;
    if (label != nil) {
        label.text = [NSString stringWithFormat: @"%lu/%li chars", textView.text.length, (long)maxChars];
    }
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSInteger originTag = (textView.tag / 1000) * 1000;
    NSInteger textViewTag = textView.tag - originTag;
    
    self.isUserDataUpdated = true;
    
    if([text isEqualToString:@"\n"] && textViewTag == 0) {
        [textView resignFirstResponder];
        return NO;
    }
    if (originTag == EditProfileSignatureEmojiTextField) {
        return text.length > 0 ? [text emo_containsEmoji] : YES;
    }
    NSInteger maxChars = textViewTag == 0 ? 140 : textViewTag;
    return textView.text.length + (text.length - range.length) <= maxChars;
    
}
@end
