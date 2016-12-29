//
//  WAProfileEditProfileTableViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/27/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WAProfileEditProfileTableViewController.h"

#import "WAValues.h"

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
    [self.tableView registerNib:[UINib nibWithNibName:@"WAProfileEditProfileYearTableViewCell" bundle:nil] forCellReuseIdentifier:@"yearCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WAProfileEditProfileMajorTableViewCell" bundle:nil] forCellReuseIdentifier:@"majorCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WAProfileEditProfileLocationTableViewCell" bundle:nil] forCellReuseIdentifier:@"locationCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WAProfileEditProfileDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"detailsCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = [WAValues defaultTableViewBackgroundColor];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100.0;
    
    self.tableView.showsVerticalScrollIndicator = false;
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    // Initialize default values
    
    self.user = [[WAUser alloc] initWithFirstName:@"John" lastName:@"Smith" userID:@"USERID" classYear:@"2020" major:@"Computer Science" image:[UIImage imageNamed:@"BlankCircle"]];
    
    self.user.details = @"This is stuff about me...";
    self.user.location = @"Durham, NC";
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
    
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        WAProfileEditProfilePictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pictureCell" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.profileImageView.image = self.user.profileImage;
        
        cell.profileImageView.layer.cornerRadius = 50.0;
        cell.profileImageView.clipsToBounds = true;
        
        [cell.editButton addTarget:self action:@selector(editProfilePictureButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    if (indexPath.row == 1) {
        
        WAProfileEditProfileNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nameCell" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor clearColor];
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
        
        WAProfileEditProfileYearTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"yearCell" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.chooseButton addTarget:self action:@selector(chooseYearButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    if (indexPath.row == 3) {
        
        WAProfileEditProfileMajorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"majorCell" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.majorTextField.text = self.user.major;
        
        cell.majorTextField.tag = 3;
        cell.majorTextField.delegate = self;
        
        return cell;
    }
    
    if (indexPath.row == 4) {
        
        WAProfileEditProfileLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"locationCell" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.locationTextField.text = self.user.location;
        
        cell.locationTextField.tag = 4;
        cell.locationTextField.delegate = self;
        
        return cell;
    }
    
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
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - Button targets

- (void)chooseYearButtonPressed:(UIButton *)button {
    
    UIAlertController *yearMenu = [UIAlertController alertControllerWithTitle:@"Graduation Year" message:@"Choose an option" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *option1 = [UIAlertAction actionWithTitle:@"2017" style:UIAlertActionStyleDefault handler: ^(UIAlertAction *action){
        
    }];
    UIAlertAction *option2 = [UIAlertAction actionWithTitle:@"2018" style:UIAlertActionStyleDefault handler: ^(UIAlertAction *action){
        
    }];
    UIAlertAction *option3 = [UIAlertAction actionWithTitle:@"2019" style:UIAlertActionStyleDefault handler: ^(UIAlertAction *action){
        
    }];
    UIAlertAction *option4 = [UIAlertAction actionWithTitle:@"2020" style:UIAlertActionStyleDefault handler: ^(UIAlertAction *action){
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [yearMenu addAction:option1];
    [yearMenu addAction:option2];
    [yearMenu addAction:option3];
    [yearMenu addAction:option4];
    
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
    
    self.user.profileImage = image;
    
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

#pragma mark - Text field delegate

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
    
    if (textField.tag == 1) {
        
        self.user.firstName = textField.text;
    }
    else if (textField.tag == 2) {
        
        self.user.lastName = textField.text;
    }
    else if (textField.tag == 3) {
        
        self.user.major = textField.text;
    }
    else if (textField.tag == 4) {
        
        self.user.location = textField.text;
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
}

- (void)textViewDidChange:(UITextView *)textView {
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

@end
