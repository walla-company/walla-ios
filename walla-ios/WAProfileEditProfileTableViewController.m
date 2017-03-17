//
//  WAProfileEditProfileTableViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/27/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WAProfileEditProfileTableViewController.h"

#import "WAProfileEditProfilePictureTableViewCell.h"
#import "WAProfileEditProfileNameTableViewCell.h"
#import "WAProfileEditProfileAcademicLevelTableViewCell.h"
#import "WAProfileEditProfileYearTableViewCell.h"
#import "WAProfileEditProfileMajorTableViewCell.h"
#import "WAProfileEditProfileLocationTableViewCell.h"
#import "WAProfileEditProfileDetailsTableViewCell.h"
#import "WAProfileEditGroupHeaderTableViewCell.h"
#import "WAProfileEditGroupTableViewCell.h"
#import "WAProfileEditAddGroupTableViewCell.h"

#import "WAValues.h"
#import "WAServer.h"

@import Firebase;

@interface WAProfileEditProfileTableViewController ()

@end

@implementation WAProfileEditProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Edit Profile";
    
    // Set up table view
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WAProfileEditProfilePictureTableViewCell" bundle:nil] forCellReuseIdentifier:@"pictureCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WAProfileEditProfileNameTableViewCell" bundle:nil] forCellReuseIdentifier:@"nameCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WAProfileEditProfileAcademicLevelTableViewCell" bundle:nil] forCellReuseIdentifier:@"academicLevelCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WAProfileEditProfileYearTableViewCell" bundle:nil] forCellReuseIdentifier:@"yearCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WAProfileEditProfileMajorTableViewCell" bundle:nil] forCellReuseIdentifier:@"majorCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WAProfileEditProfileLocationTableViewCell" bundle:nil] forCellReuseIdentifier:@"locationCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WAProfileEditProfileDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"detailsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WAProfileEditGroupHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"groupHeaderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WAProfileEditGroupTableViewCell" bundle:nil] forCellReuseIdentifier:@"groupCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WAProfileEditAddGroupTableViewCell" bundle:nil] forCellReuseIdentifier:@"addGroupCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100.0;
    
    self.tableView.showsVerticalScrollIndicator = false;
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    // Initialize defualt values
    
    self.profileImage = [UIImage imageNamed:@"BlankCircle"];
    
    self.loadProfilePhoto = true;
    
    self.groupsDictionary = [[NSMutableDictionary alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [WAServer getUserWithID:[FIRAuth auth].currentUser.uid completion:^(WAUser *user){
        
        self.user = user;
        [self.tableView reloadData];
        
        if (self.loadProfilePhoto) {
            [self loadProfileImage];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                
                self.profileImage = [UIImage imageWithData:data];
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
    
    if (self.user) return 9 + [self.user.groups count];
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        WAProfileEditProfilePictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pictureCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.profileImageView.image = self.profileImage;
        
        cell.profileImageView.layer.cornerRadius = 50.0;
        cell.profileImageView.clipsToBounds = true;
        
        [cell.editButton addTarget:self action:@selector(editProfilePictureButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    if (indexPath.row == 1) {
        
        WAProfileEditProfileNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nameCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.firstNameTextField.text = self.user.firstName;
        cell.lastNameTextField.text = self.user.lastName;
        
        cell.firstNameTextField.tag = 1;
        cell.firstNameTextField.delegate = self;
        cell.lastNameTextField.tag = 2;
        cell.lastNameTextField.delegate = self;
        
        return cell;
    }
    
    if (indexPath.row == 2) {
        
        WAProfileEditProfileAcademicLevelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"academicLevelCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.chooseButton addTarget:self action:@selector(chooseAcademicLevelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([self.user.academicLevel isEqualToString:@""]) {
            cell.academicLevelLabel.textColor = [WAValues notSelectedTextColor];
            cell.academicLevelLabel.text = @"Choose academic level";
        }
        else {
            cell.academicLevelLabel.textColor = [WAValues selectedTextColor];
            cell.academicLevelLabel.text = ([self.user.academicLevel isEqualToString:@"undergrad"]) ? @"Undergraduate" : @"Graduate";
        }
        
        return cell;
        
    }
    
    if (indexPath.row == 3) {
        
        WAProfileEditProfileYearTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"yearCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.chooseButton addTarget:self action:@selector(chooseYearButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([self.user.graduationYear integerValue] <= 0) {
            cell.graduationYearLabel.textColor = [WAValues notSelectedTextColor];
            cell.graduationYearLabel.text = @"Choose graduation year";
        }
        else {
            cell.graduationYearLabel.textColor = [WAValues selectedTextColor];
            cell.graduationYearLabel.text = self.user.graduationYear;
        }
        
        return cell;
    }
    
    if (indexPath.row == 4) {
        
        WAProfileEditProfileMajorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"majorCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.majorTextField.text = self.user.major;
        
        cell.majorTextField.tag = 3;
        cell.majorTextField.delegate = self;
        
        return cell;
    }
    
    if (indexPath.row == 5) {
        
        WAProfileEditProfileLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"locationCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.locationTextField.text = self.user.hometown;
        
        cell.locationTextField.tag = 4;
        cell.locationTextField.delegate = self;
        
        return cell;
    }
    
    if (indexPath.row == 6) {
        
        WAProfileEditProfileDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailsCell" forIndexPath:indexPath];
        
        cell.detailsTextView.scrollEnabled = false;
        cell.detailsTextView.delegate = self;
        
        if ([self.user.details isEqual: @""]) {
            cell.detailsTextView.textColor = [WAValues notSelectedTextColor];
            cell.detailsTextView.text = @"Details";
        }
        else {
            cell.detailsTextView.textColor = [WAValues selectedTextColor];
            cell.detailsTextView.text = self.user.details;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    if (indexPath.row == 7) {
        
        WAProfileEditGroupHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupHeaderCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    if ([self.user.groups count] > 0 && indexPath.row >= 8 && indexPath.row <= [self.user.groups count] + 7) {
        
        WAProfileEditGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *groupID = self.user.groups[indexPath.row - 8];
        
        if (self.groupsDictionary[groupID]) {
            NSDictionary *group = self.groupsDictionary[groupID];
            
            cell.nameLabel.text = group[@"name"];
        }
        else {
            cell.nameLabel.text = @"";
            [self.groupsDictionary setObject:@{@"name": @""} forKey:groupID];
            [WAServer getGroupBasicInfoWithID:groupID completion:^(NSDictionary *group) {
                
                [self.groupsDictionary setObject:group forKey:groupID];
                
                [self.tableView reloadData];
            }];
        }

        cell.deleteButton.tag = indexPath.row - 8;
        
        [cell.deleteButton addTarget:self action:@selector(leaveGroupButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    WAProfileEditAddGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addGroupCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.addGroupButton addTarget:self action:@selector(addGroupButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark - Button targets

- (void)chooseAcademicLevelButtonPressed:(UIButton *)button {
    
    UIAlertController *levelMenu = [UIAlertController alertControllerWithTitle:@"Academic Level" message:@"Choose an option" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *option1 = [UIAlertAction actionWithTitle:@"Undergraduate" style:UIAlertActionStyleDefault handler: ^(UIAlertAction *action){
        
        self.user.academicLevel = @"undergrad";
        
        [WAServer updateUserAcademicLevel:self.user.academicLevel completion:nil];
        
        [self.tableView reloadData];
    }];
    UIAlertAction *option2 = [UIAlertAction actionWithTitle:@"Graduate" style:UIAlertActionStyleDefault handler: ^(UIAlertAction *action){
        
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

- (void)chooseYearButtonPressed:(UIButton *)button {
    
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

- (void)editProfilePictureButtonPressed:(UIButton *)button {
    
    UIAlertController *photoMenu = [UIAlertController alertControllerWithTitle:@"Edit Profile Photo" message:@"Choose an option" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler: ^(UIAlertAction *action){
        [self takePhoto];
    }];
    UIAlertAction *choosePhotoAction = [UIAlertAction actionWithTitle:@"Choose Photo" style:UIAlertActionStyleDefault handler: ^(UIAlertAction *action){
        [self choosePhoto];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [photoMenu addAction:takePhotoAction];
    [photoMenu addAction:choosePhotoAction];
    [photoMenu addAction:cancelAction];
    
    if (photoMenu.popoverPresentationController) {
        
        photoMenu.popoverPresentationController.sourceView = button;
        photoMenu.popoverPresentationController.sourceRect = button.bounds;
    }
    
    [self presentViewController:photoMenu animated:true completion:nil];
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

#pragma mark - Choose photo

- (void)takePhoto {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.allowsEditing = true;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    imagePicker.delegate = self;
    
    [self presentViewController:imagePicker animated:true completion:nil];
}

- (void)choosePhoto {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.allowsEditing = true;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    
    [self presentViewController:imagePicker animated:true completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    NSLog(@"(ORIGINAL) height: %f, width: %f", image.size.height, image.size.width);
    
    if (image.size.height != image.size.width) {
        
        NSLog(@"Crop Photo");
        
        CGFloat targetSize = (image.size.height > image.size.width) ? image.size.width : image.size.height;
        image = [self cropToBounds:image width:targetSize height:targetSize];
    }
    
    image = [self resizeImage:image targetSize:CGSizeMake(300.0, 300.0)];
    
    self.profileImage = image;
    
    NSLog(@"(RESIZE) height: %f, width: %f", image.size.height, image.size.width);
    
    [self.tableView reloadData];
    
    self.loadProfilePhoto = false;
    
    [self dismissViewControllerAnimated:true completion:^(void){
        self.loadProfilePhoto = true;
    }];
    
    [self uploadPhoto];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:true completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image targetSize:(CGSize)targetSize {
    
    CGSize size = image.size;
    
    CGFloat widthRatio = targetSize.width / image.size.width;
    CGFloat heightRatio = targetSize.height / image.size.height;
    
    CGSize newSize;
    
    if (widthRatio > heightRatio) {
        newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio);
    } else {
        newSize = CGSizeMake(size.width * widthRatio, size.height * widthRatio);
    }
    
    CGRect rect = CGRectMake(0, 0, newSize.width, newSize.height);
    
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0);
    [image drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)cropToBounds:(UIImage *)image width:(CGFloat)width height:(CGFloat)height {
    
    UIImage *contextImage = [UIImage imageWithCGImage:image.CGImage];
    CGSize contextSize = contextImage.size;
    
    CGFloat posX = 0.0;
    CGFloat posY = 0.0;
    CGFloat cgwidth = width;
    CGFloat cgheight = height;
    
    if (contextSize.width > contextSize.height) {
        posX = ((contextSize.width - contextSize.height) / 2);
        posY = 0;
        cgwidth = contextSize.height;
        cgheight = contextSize.height;
    }
    else {
        posX = 0;
        posY = ((contextSize.height - contextSize.width) / 2);
        cgwidth = contextSize.width;
        cgheight = contextSize.width;
    }
    
    CGRect rect = CGRectMake(posX, posY, cgwidth, cgheight);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(contextImage.CGImage, rect);
    
    return [[UIImage alloc] initWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
}

- (void)uploadPhoto {
    
    FIRStorage *storage = [FIRStorage storage];
    FIRStorageReference *storageRef = [storage referenceForURL:@"gs://walla-launch.appspot.com"];
    
    NSData *data = UIImageJPEGRepresentation(self.profileImage, 0.75);
    
    FIRStorageReference *riversRef = [storageRef child:[NSString stringWithFormat:@"profile_images/%@.jpg", [FIRAuth auth].currentUser.uid]];
    
    [riversRef putData:data metadata:nil completion:^(FIRStorageMetadata *metadata, NSError *error) {
        if (error != nil) {
            
            NSLog(@"Profile Image upload error");
            
        } else {
            
            [WAServer updateUserProfileImageURL:[metadata.downloadURL absoluteString] completion:nil];
        }
    }];
    
}

#pragma mark - Text field delegate

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
    
    if (textField.tag == 1) {
        
        self.user.firstName = textField.text;
        
        [WAServer updateUserFirstName:self.user.firstName completion:nil];
    }
    else if (textField.tag == 2) {
        
        self.user.lastName = textField.text;
        
        [WAServer updateUserLastName:self.user.lastName completion:nil];
    }
    else if (textField.tag == 3) {
        
        self.user.major = textField.text;
        
        [WAServer updateUserMajor:self.user.major completion:nil];
    }
    else if (textField.tag == 4) {
        
        self.user.hometown = textField.text;
        
        [WAServer updateUserHometown:self.user.hometown completion:nil];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return false;
}

#pragma mark - Text view delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if ([self.user.details isEqualToString:@""]) {
        textView.textColor = [WAValues selectedTextColor];
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    self.user.details = textView.text;
    
    if ([self.user.details isEqualToString:@""]) {
        textView.textColor = [WAValues notSelectedTextColor];
        textView.text = @"Details";
    }
    
    [WAServer updateUserDescription:self.user.details completion:nil];
}

- (void)textViewDidChange:(UITextView *)textView {
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

@end
