//
//  WAAuthSignupTableViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 3/17/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import "WAAuthSignupTableViewController.h"

#import "WAAuthSignupTableViewCell.h"
#import "WAAuthClearTableViewCell.h"

#import "WAServer.h"
#import "WAValues.h"

@import Firebase;

@interface WAAuthSignupTableViewController ()

@end

@implementation WAAuthSignupTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WAAuthSignupTableViewCell" bundle:nil] forCellReuseIdentifier:@"signupCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WAAuthClearTableViewCell" bundle:nil] forCellReuseIdentifier:@"clearCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.showsVerticalScrollIndicator = false;
    
    self.tableView.bounces = true;
    
    self.tableView.backgroundColor = [WAValues colorFromHexString:@"#FFA44A"];
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    self.profileImage = nil;
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
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1) return 500;
    
    if ([[UIScreen mainScreen] bounds].size.height <= 500) return 0;
    
    return ([[UIScreen mainScreen] bounds].size.height - 500) / 2.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1) {
        
        WAAuthSignupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"signupCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.backgroundColor = [WAValues colorFromHexString:@"#FFA44A"];
        
        [cell.backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.profileImage) cell.profileImageView.image = self.profileImage;
        else cell.profileImageView.image = [UIImage imageNamed:@"Upload-Photo-Icon"];
        
        cell.profileImageView.clipsToBounds = true;
        cell.profileImageView.layer.cornerRadius = 57.5;
        
        cell.emailAddressLabel.text = self.emailAddress;
        
        [cell.choosePhotoButton addTarget:self action:@selector(choosePhotoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.signupButton addTarget:self action:@selector(signupButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.firstNametextField.delegate = self;
        cell.lastNameTextField.delegate = self;
        cell.passwordTextField.delegate = self;
        
        cell.firstNametextField.tag = 1;
        cell.lastNameTextField.tag = 2;
        cell.passwordTextField.tag = 3;
        
        return cell;
        
    }
    
    WAAuthClearTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"clearCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor = [WAValues colorFromHexString:@"#FFA44A"];
    
    cell.forgotPasswordButton.hidden = true;
    
    return cell;
}

#pragma mark - Button targets

- (void)backButtonPressed:(UIButton *)button {
    
    [self.navigationController popViewControllerAnimated:true];
}

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

- (void)signupButtonPressed:(UIButton *)button {
    [self.view endEditing:YES];
    WAAuthSignupTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    self.firstName = cell.firstNametextField.text;
    self.lastName = cell.lastNameTextField.text;
    self.password = cell.passwordTextField.text;
    
    if ([self.firstName isEqualToString:@""] || [self.lastName isEqualToString:@""] || [self.password isEqualToString:@""]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Enter all Information" message:@"You must fill out all of the information to create an account." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:true completion:nil];
    }
    else {
        
        self.tableView.userInteractionEnabled = false;
        
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"inSignup"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[FIRAuth auth] createUserWithEmail:self.emailAddress password:self.password completion:^(FIRUser *user, NSError *error) {
            if (user) {
                [self uploadUserInfo];
                
                [WAServer sendVerificationEmail:nil];
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
                
                NSLog(@"Signup Error: \(error)");
            }
        }];

    }
    
}

#pragma mark - Upload user info

- (void)uploadUserInfo {
    
    [WAServer addUser:[FIRAuth auth].currentUser.uid firstName:self.firstName lastName:self.lastName email:self.emailAddress completion:^(BOOL success) {
        
        [self uploadUserPhoto];
    }];
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
                
                [WAServer updateUserProfileImageURL:[metadata.downloadURL absoluteString] completion:^(BOOL success) {
                    
                    [self doneSigningUp];
                }];
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

#pragma mark - Text field delegate

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
    
    if (textField.tag == 1) {
        
        self.firstName = textField.text;
    }
    else if (textField.tag == 2) {
        
        self.lastName = textField.text;
    }
    else if (textField.tag == 3) {
        
        self.password = textField.text;
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField.tag == 1) {
        
        self.firstName = textField.text;
    }
    else if (textField.tag == 2) {
        
        self.lastName = textField.text;
    }
    else if (textField.tag == 3) {
        
        self.password = textField.text;
    }
    
    return true;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    WAAuthSignupTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    if (textField.tag == 1) {
        
        self.firstName = textField.text;
        
        [cell.lastNameTextField becomeFirstResponder];
    }
    else if (textField.tag == 2) {
        
        self.lastName = textField.text;
        
        [cell.passwordTextField becomeFirstResponder];
    }
    else if (textField.tag == 3) {
        
        self.password = textField.text;
        
        [textField resignFirstResponder];
        [self signupButtonPressed:nil];
    }
    
    return false;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
