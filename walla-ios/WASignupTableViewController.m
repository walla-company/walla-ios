//
//  WASignupTableViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 1/2/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import "WASignupTableViewController.h"

#import "WASignupUploadPhotoTableViewCell.h"
#import "WALoginSignupTextFieldTableViewCell.h"
#import "WASignupPopupTableViewCell.h"
#import "WALoginSignupButtonTableViewCell.h"
#import "WASignupBottomButtonTableViewCell.h"

#import "WAValues.h"
#import "WAServer.h"

@import Firebase;

@interface WASignupTableViewController ()

@end

@implementation WASignupTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up table view
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WASignupUploadPhotoTableViewCell" bundle:nil] forCellReuseIdentifier:@"photoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WALoginSignupTextFieldTableViewCell" bundle:nil] forCellReuseIdentifier:@"textFieldCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WASignupPopupTableViewCell" bundle:nil] forCellReuseIdentifier:@"popupCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WALoginSignupButtonTableViewCell" bundle:nil] forCellReuseIdentifier:@"buttonCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WASignupBottomButtonTableViewCell" bundle:nil] forCellReuseIdentifier:@"bottomCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = [WAValues loginSignupTableViewBackgroundColor];
    
    self.tableView.showsVerticalScrollIndicator = false;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100.0;
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    // Set defaul values
    
    self.profileImage = nil;
    
    self.firstName = @"";
    self.lastName = @"";
    self.emailAddress = @"";
    self.academicLevel = @"";
    self.major = @"";
    self.graduationYear = 0;
    
    self.password1 = @"";
    self.password2 = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        WASignupUploadPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photoCell" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.profilePhotoView.image = (self.profileImage) ? self.profileImage : [UIImage imageNamed:@"Floating_Icon_Upload"];
        
        if (self.profileImage) {
            cell.profilePhotoView.layer.cornerRadius = 65.0;
            cell.profilePhotoView.clipsToBounds = true;
        }
        else {
            cell.profilePhotoView.layer.cornerRadius = 0.0;
        }
        
        [cell.choosePhotoButton addTarget:self action:@selector(choosePhotoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    if (indexPath.row == 4) {
        
        WASignupPopupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"popupCell" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([self.academicLevel isEqualToString:@""]) {
            cell.label.text = @"Academic Level";
            cell.label.textColor = [WAValues notSelectedTextColor];
        }
        else {
            cell.label.text = ([self.academicLevel isEqualToString:@"undergrad"]) ? @"Undergraduate" : @"Graduate";
            cell.label.textColor = [WAValues selectedTextColor];
        }
        
        [cell.button addTarget:self action:@selector(chooseAcademicLevelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    if (indexPath.row == 6) {
        
        WASignupPopupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"popupCell" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (self.graduationYear == 0) {
            cell.label.text = @"Graduation Year";
            cell.label.textColor = [WAValues notSelectedTextColor];
        }
        else {
            cell.label.text = [NSString stringWithFormat:@"%ld", (long) self.graduationYear];
            cell.label.textColor = [WAValues selectedTextColor];
        }
        
        [cell.button addTarget:self action:@selector(chooseGraduationYearButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    if (indexPath.row == 9) {
        
        WALoginSignupButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buttonCell" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.button setTitle:@"Sign up" forState:UIControlStateNormal];
        [cell.button addTarget:self action:@selector(signupButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }

    if (indexPath.row == 10) {
        
        WASignupBottomButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bottomCell" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    WALoginSignupTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textFieldCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 1) {
        
        cell.textField.placeholder = @"First Name";
        cell.textField.tag = 1;
        cell.textField.delegate = self;
        
        cell.textField.keyboardType = UIKeyboardTypeDefault;
        cell.textField.secureTextEntry = false;
        
        cell.textField.returnKeyType = UIReturnKeyNext;
        
        cell.textField.text = self.firstName;
    }
    else if (indexPath.row == 2) {
        
        cell.textField.placeholder = @"Last Name";
        cell.textField.tag = 2;
        cell.textField.delegate = self;
        
        cell.textField.keyboardType = UIKeyboardTypeDefault;
        cell.textField.secureTextEntry = false;
        
        cell.textField.returnKeyType = UIReturnKeyNext;
        
        cell.textField.text = self.lastName;
    }
    else if (indexPath.row == 3) {
        
        cell.textField.placeholder = @"Email Address";
        cell.textField.tag = 3;
        cell.textField.delegate = self;
        
        cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
        cell.textField.secureTextEntry = false;
        
        cell.textField.returnKeyType = UIReturnKeyNext;
        
        cell.textField.text = self.emailAddress;
    }
    else if (indexPath.row == 5) {
        
        cell.textField.placeholder = @"Major";
        cell.textField.tag = 5;
        cell.textField.delegate = self;
        
        cell.textField.keyboardType = UIKeyboardTypeDefault;
        cell.textField.secureTextEntry = false;
        
        cell.textField.returnKeyType = UIReturnKeyNext;
        
        cell.textField.text = self.major;
    }
    else if (indexPath.row == 7) {
        
        cell.textField.placeholder = @"Password";
        cell.textField.tag = 7;
        cell.textField.delegate = self;
        
        cell.textField.keyboardType = UIKeyboardTypeASCIICapable;
        cell.textField.secureTextEntry = true;
        
        cell.textField.returnKeyType = UIReturnKeyNext;
        
        cell.textField.text = self.password1;
    }
    else if (indexPath.row == 8) {
        
        cell.textField.placeholder = @"Confirm Password";
        cell.textField.tag = 8;
        cell.textField.delegate = self;
        
        cell.textField.keyboardType = UIKeyboardTypeASCIICapable;
        cell.textField.secureTextEntry = true;
        
        cell.textField.returnKeyType = UIReturnKeyDone;
        
        cell.textField.text = self.password2;
    }
    
    return cell;
}

#pragma mark - Text field delegate

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
    
    if (textField.tag == 1) {
        self.firstName = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    else if (textField.tag == 2) {
        self.lastName = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    else if (textField.tag == 3) {
        self.emailAddress = textField.text;
    }
    else if (textField.tag == 5) {
        self.major = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    else if (textField.tag == 7) {
        self.password1 = textField.text;
    }
    else if (textField.tag == 8) {
        self.password2 = textField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.tag == 1) {
        WALoginSignupTextFieldTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        
        [cell.textField becomeFirstResponder];
    }
    else if (textField.tag == 2) {
        WALoginSignupTextFieldTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        
        [cell.textField becomeFirstResponder];
    }
    else if (textField.tag == 3) {
        
        [textField resignFirstResponder];
    }
    else if (textField.tag == 5) {
        
        [textField resignFirstResponder];
    }
    else if (textField.tag == 7) {
        WALoginSignupTextFieldTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0]];
        
        [cell.textField becomeFirstResponder];
    }
    else if (textField.tag == 8) {
        
        [textField resignFirstResponder];
        
        [self signupButtonPressed:nil];
    }
    
    return false;
}

# pragma mark - Button targets

- (void)choosePhotoButtonPressed:(UIButton *)button {
    
    UIAlertController *photoMenu = [UIAlertController alertControllerWithTitle:@"Upload Profile Photo" message:@"Choose an option" preferredStyle:UIAlertControllerStyleActionSheet];
    
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

- (void)chooseAcademicLevelButtonPressed:(UIButton *)button {
    
    UIAlertController *levelMenu = [UIAlertController alertControllerWithTitle:@"Academic Level" message:@"Choose an option" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *option1 = [UIAlertAction actionWithTitle:@"Undergraduate" style:UIAlertActionStyleDefault handler: ^(UIAlertAction *action){
        self.academicLevel = @"undergrad";
        [self.tableView reloadData];
    }];
    UIAlertAction *option2 = [UIAlertAction actionWithTitle:@"Graduate" style:UIAlertActionStyleDefault handler: ^(UIAlertAction *action){
        self.academicLevel = @"grad";
        [self.tableView reloadData];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [levelMenu addAction:option1];
    [levelMenu addAction:option2];
    
    [levelMenu addAction:cancelAction];
    
    [self presentViewController:levelMenu animated:true completion:nil];
}

- (void)chooseGraduationYearButtonPressed:(UIButton *)button {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSInteger yearInt = [[formatter stringFromDate:[NSDate date]] integerValue];
    
    UIAlertController *yearMenu = [UIAlertController alertControllerWithTitle:@"Graduation Year" message:@"Choose an option" preferredStyle:UIAlertControllerStyleAlert];
    
    for (int i=0; i < 6; i++) {
        
        UIAlertAction *option = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%ld", (long) yearInt + i] style:UIAlertActionStyleDefault handler: ^(UIAlertAction *action){
            
            self.graduationYear = yearInt + i;
            
            [self.tableView reloadData];
        }];
        
        [yearMenu addAction:option];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [yearMenu addAction:cancelAction];
    
    [self presentViewController:yearMenu animated:true completion:nil];
}

- (void)signupButtonPressed:(UIButton *)button {
    
    if ([self canSignup]) {
        NSLog(@"canSignup");
        
        self.tableView.userInteractionEnabled = false;
        
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"inSignup"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[FIRAuth auth] createUserWithEmail:self.emailAddress password:self.password1 completion:^(FIRUser *user, NSError *error) {
            if (user) {
                [self uploadUserInfo];
            } else {
                self.tableView.userInteractionEnabled = true;
                
                if (error.code == FIRAuthErrorCodeInvalidEmail) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Emaill Address" message:@"The email address you entered is not valid. Please enter a valid email address and try again." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
                    [alert addAction:cancelAction];
                    [self presentViewController:alert animated:true completion:nil];
                }
                else if (error.code == FIRAuthErrorCodeEmailAlreadyInUse) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Email Address Taken" message:@"Another account has already been created with the email address you have entered." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
                    [alert addAction:cancelAction];
                    [self presentViewController:alert animated:true completion:nil];
                }
                else if (error.code == FIRAuthErrorCodeWeakPassword) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Password too Weak" message:@"The password you entered is too weak. Please enter a stronger password and try again." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
                    [alert addAction:cancelAction];
                    [self presentViewController:alert animated:true completion:nil];
                }
                else if (error.code == FIRAuthErrorCodeNetworkError) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Network Error" message:@"There was a problem communicating with our servers. Please make sure you are connected to the internet and try again." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
                    [alert addAction:cancelAction];
                    [self presentViewController:alert animated:true completion:nil];
                }
                else {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Unknown Error" message:@"An unkown error has occured. Please make sure you are connected to the internet and try again." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
                    [alert addAction:cancelAction];
                    [self presentViewController:alert animated:true completion:nil];
                }
            }
         }];
    }
}


- (BOOL)canSignup {
    
    if ([self.firstName isEqualToString:@""] || [self.lastName isEqualToString:@""] || [self.emailAddress isEqualToString:@""] || [self.academicLevel isEqualToString:@""] || [self.major isEqualToString:@""] || self.graduationYear == 0 || [self.password1 isEqualToString:@""] || [self.password2 isEqualToString:@""]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Enter all Information" message:@"You must fill out all of the information to create an account." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:true completion:nil];
        
        return false;
    }
    
    if (![self.password1 isEqualToString:self.password2]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Passwords do not Match" message:@"The passwords you entered do not match." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:true completion:nil];
        
        return false;
    }
    
    NSString *schoolIdentifier = [WAServer schoolIdentifierFromEmail:self.emailAddress];
    
    if ([schoolIdentifier isEqualToString:@""]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Use School Email" message:@"You must use your school email address to create an account." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:true completion:nil];
        
        return false;
    }
    
    return true;
}

- (void)uploadUserInfo {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        [WAServer addUser:[FIRAuth auth].currentUser.uid firstName:self.firstName lastName:self.lastName email:self.emailAddress academicLevel:self.academicLevel major:self.major graduationYear:self.graduationYear completion:^(BOOL success){
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (success) [self uploadUserPhoto];
            });
        }];
    });
}

- (void)uploadUserPhoto {
    
    if (self.profileImage) {
        
        FIRStorage *storage = [FIRStorage storage];
        FIRStorageReference *storageRef = [storage referenceForURL:@"gs://walla-launch.appspot.com"];
        
        NSData *data = UIImageJPEGRepresentation(self.profileImage, 0.75);
        
        FIRStorageReference *riversRef = [storageRef child:[NSString stringWithFormat:@"profile_images/%@.jpg", [FIRAuth auth].currentUser.uid]];
        
        [riversRef putData:data metadata:nil completion:^(FIRStorageMetadata *metadata, NSError *error) {
            if (error != nil) {
                
                NSLog(@"Profile Image upload error");
                
                [self doneSigningUp];
                
            } else {
                
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
                    
                    [WAServer updateUserProfileImageURL:[NSString stringWithFormat:@"gs://walla-launch.appspot.com/profile_images/%@.jpg", [FIRAuth auth].currentUser.uid] completion:^(BOOL success) {
                        [self doneSigningUp];
                    }];
                });
            }
        }];
        
        
    }
    else {
        [self doneSigningUp];
    }
    
}

- (void)doneSigningUp {
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"inSignup"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SignupComplete" object:nil];
}

- (void)loginButtonPressed:(UIButton *)button {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure?" message:@"Any information you have entered will be deleted." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Stay" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:cancelAction];
    
    UIAlertAction *option = [UIAlertAction actionWithTitle:@"Log in" style:UIAlertActionStyleDefault handler: ^(UIAlertAction *action){
        [self.navigationController popViewControllerAnimated:true];
    }];
    
    [alert addAction:option];
    
    [self presentViewController:alert animated:true completion:nil];
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
    
    [self dismissViewControllerAnimated:true completion:nil];
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


@end
