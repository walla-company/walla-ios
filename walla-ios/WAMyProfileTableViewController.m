//
//  WAMyProfileTableViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/17/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WAMyProfileTableViewController.h"

#import "WAProfileHeaderTableViewCell.h"
#import "WAProfileTextTableViewCell.h"
#import "WASettingsTableViewController.h"
#import "WAServer.h"
#import "WAValues.h"

static NSString *headerCellIdentifier = @"WAProfileHeaderTableViewCell";
static NSString *textCellIdentifier = @"WAProfileTextTableViewCell";

@import Firebase;

@interface WAMyProfileTableViewController ()
@property BOOL loadProfilePhoto;

@end

@implementation WAMyProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *rightBarButtonItem =  [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings"] style:UIBarButtonItemStylePlain target:self action:@selector(openSettings)];
//    UIBarButtonItem *rightBarButtonItem =  [[UIBarButtonItem alloc] initWithTitle:@"Log out" style:UIBarButtonItemStylePlain target:self action:@selector(showLogoutAlert)];
//
    self.navigationItem.rightBarButtonItem = self.userId != nil ? nil : rightBarButtonItem;
    // Set up table view
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"WAProfileHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:headerCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"WAProfileTextTableViewCell" bundle:nil] forCellReuseIdentifier:textCellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 65.0;
    self.tableView.showsVerticalScrollIndicator = false;
    
    // Initialize values
    self.titleArray = @[@"Edit profile", @"About Walla", @"Log out"];
    
    self.profileImage = [UIImage imageNamed:@"BlankCircle"];
    
    self.groupsDictionary = [[NSMutableDictionary alloc] init];
    self.loadProfilePhoto = YES;
    self.title = self.userId != nil ? @"Profile" : @"My Profile";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [WAServer getUserWithID: self.userId != nil ? self.userId : [FIRAuth auth].currentUser.uid  completion:^(WAUser *user) {
        self.user = user;
        [self.tableView reloadData];
        if (self.loadProfilePhoto) {
            [self loadProfileImage];
        }
    }];
    BOOL openEditProfile = [[NSUserDefaults standardUserDefaults] boolForKey:@"openEditProfile"];
    if (openEditProfile) {
        [self performSegueWithIdentifier:@"openEditProfile" sender:self];
    }
}

- (void)loadProfileImage {
    if (self.user.profileImageURL.length > 0) {
        FIRStorage *storage = [FIRStorage storage];
        FIRStorageReference *imageRef = [storage referenceForURL:self.user.profileImageURL];
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

-(BOOL)isProfileComplete:(WAUser *)user {
    if (self.user.firstName.length == 0 ||
        self.user.lastName.length == 0 ||
        self.user.signatureEmoji.length == 0 ||
        self.user.profileImageURL.length == 0 ||
        self.user.graduationYear.length == 0 ||
        self.user.major.length == 0 ||
        self.user.hometown.length == 0 ||
        self.user.details.length == 0 ||
        self.user.reasonSchool.length == 0 ||
        self.user.wannaMeet.length == 0 ||
        self.user.goal1.length == 0 ||
        self.user.goal2.length == 0 ||
        self.user.goal3.length == 0 ){
        return false;
    }
    return true;
}

-(NSString *)nonNullString:(NSString *)string {
    return string.length > 0 ? string : @"";
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger mandatoryRows = 5;//self.userId != nil ? 3 : 8;
    return self.user == nil ? 0 : mandatoryRows; //+  [self.user.groups count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *blackAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName: [UIFont systemFontOfSize:14]};
    NSDictionary *grayAttributes = @{NSForegroundColorAttributeName: [UIColor lightGrayColor],NSFontAttributeName: [UIFont systemFontOfSize:14]};
    NSMutableAttributedString *attrString = [NSMutableAttributedString new];

    if (indexPath.row == 0) {
        WAProfileHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: headerCellIdentifier forIndexPath:indexPath];
        cell.userImageView.image = (self.user.profileImageURL.length == 0 && self.userId == nil) ? nil : ((self.profileImage) ? self.profileImage : [UIImage imageNamed:@"BlankCircle"]);
        cell.userNameLabel.text = [NSString stringWithFormat:@"%@ %@", [self nonNullString: self.user.firstName], [self nonNullString: self.user.lastName]];
        cell.emojiLabel.text = [self stringFromString:self.user.signatureEmoji placeholder:@"●"];
        NSString *classString = self.user.graduationYear.length > 0 ? [NSString stringWithFormat:@"Class of %@", self.user.graduationYear] : @"";
        NSString *fromString = self.user.hometown.length > 0 ? [NSString stringWithFormat:@"From of %@", self.user.hometown] : @"";
        NSString *graduationYear = [self stringFromString:classString placeholder:@"Graduation year"];
        NSString *major = [self stringFromString:self.user.major placeholder:@"Major"];
        NSString *hometown = [self stringFromString:fromString placeholder:@"Hometown"];
        
        [attrString appendAttributedString: [[NSAttributedString alloc] initWithString:graduationYear attributes:classString > 0 ? blackAttributes : grayAttributes]];
        [attrString appendAttributedString: [[NSAttributedString alloc] initWithString:@"\n" attributes:blackAttributes]];
        [attrString appendAttributedString: [[NSAttributedString alloc] initWithString:major attributes:self.user.major.length > 0 ? blackAttributes : grayAttributes]];
        [attrString appendAttributedString: [[NSAttributedString alloc] initWithString:@"\n" attributes:blackAttributes]];
        [attrString appendAttributedString: [[NSAttributedString alloc] initWithString:hometown attributes:fromString.length > 0 ? blackAttributes : grayAttributes]];
        [attrString appendAttributedString: [[NSAttributedString alloc] initWithString:@"\n" attributes:blackAttributes]];
        cell.userInfoLabel.attributedText = attrString;

        cell.pointsLabel.text = [NSString stringWithFormat:@"Brownie points: %@", [self nonNullString:self.user.points]];
        cell.imageEditView.hidden = self.userId != nil;
        cell.editButton.hidden = cell.imageEditView.hidden;
        [cell.editButton addTarget:self action:@selector(openEditProfile) forControlEvents:UIControlEventTouchUpInside];
        cell.incompleteAlertViewHeightConstraint.constant = (![self isProfileComplete:self.user] && self.userId == nil) ? 60 : 0;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openEditPhoto)];
        if (!cell.editButton.hidden) {
            [cell.imageContainerView addGestureRecognizer: tapGestureRecognizer];
        }
        return cell;
        
    } else if (indexPath.row == 1) {
        WAProfileTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:textCellIdentifier forIndexPath:indexPath];
        cell.cellTitleLabel.text = @"About me";
        NSString *content = [self stringFromString:self.user.details placeholder:@"Edit your profile and introduce yourself in a few sentences!\n"];
        [attrString appendAttributedString: [[NSAttributedString alloc] initWithString:content attributes:self.user.details.length > 0 ? blackAttributes : grayAttributes]];
        cell.cellContentLabel.attributedText = attrString;
        cell.editButton.hidden = self.userId != nil;
        [cell.editButton addTarget:self action:@selector(openEditProfile) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else if (indexPath.row == 2) {
        WAProfileTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:textCellIdentifier forIndexPath:indexPath];
        cell.cellTitleLabel.text = @"Why Duke?";
        NSString *content = [self stringFromString:self.user.reasonSchool placeholder:@"Everyone has their reasons. Tell everyone why you chose your university!\n"];
        [attrString appendAttributedString: [[NSAttributedString alloc] initWithString:content attributes:self.user.reasonSchool.length > 0 ? blackAttributes : grayAttributes]];
        cell.cellContentLabel.attributedText = attrString;
        cell.editButton.hidden = YES;
        return cell;
    } else if (indexPath.row == 3) {
        WAProfileTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:textCellIdentifier forIndexPath:indexPath];
        cell.cellTitleLabel.text = @"Who I’d like to meet";
        NSString *content = [self stringFromString:self.user.wannaMeet placeholder:@"During college you will meet so many different people. What kind of people do you want to meet?\n"];
        [attrString appendAttributedString: [[NSAttributedString alloc] initWithString:content attributes:self.user.wannaMeet.length > 0 ? blackAttributes : grayAttributes]];
        cell.cellContentLabel.attributedText = attrString;
        cell.editButton.hidden = YES;
        return cell;
    } else {
        WAProfileTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:textCellIdentifier forIndexPath:indexPath];
        cell.cellTitleLabel.text = @"My 3 goals for this year are…";
        
        NSString *goal1 = [self stringFromString:self.user.goal1 placeholder:@"First goal"];
        NSString *goal2 = [self stringFromString:self.user.goal2 placeholder:@"Second goal"];
        NSString *goal3 = [self stringFromString:self.user.goal3 placeholder:@"Third goal"];
        [attrString appendAttributedString: [[NSAttributedString alloc] initWithString:@"1. " attributes:blackAttributes]];
        [attrString appendAttributedString: [[NSAttributedString alloc] initWithString:goal1 attributes:self.user.goal1.length > 0 ? blackAttributes : grayAttributes]];
        [attrString appendAttributedString: [[NSAttributedString alloc] initWithString:@"\n" attributes:blackAttributes]];
        [attrString appendAttributedString: [[NSAttributedString alloc] initWithString:@"2. " attributes:blackAttributes]];
        [attrString appendAttributedString: [[NSAttributedString alloc] initWithString:goal2 attributes:self.user.goal2.length > 0 ? blackAttributes : grayAttributes]];
        [attrString appendAttributedString: [[NSAttributedString alloc] initWithString:@"\n" attributes:blackAttributes]];
        [attrString appendAttributedString: [[NSAttributedString alloc] initWithString:@"3. " attributes:blackAttributes]];
        [attrString appendAttributedString: [[NSAttributedString alloc] initWithString:goal3 attributes:self.user.goal3.length > 0 ? blackAttributes : grayAttributes]];
        [attrString appendAttributedString: [[NSAttributedString alloc] initWithString:@"\n" attributes:blackAttributes]];
        cell.cellContentLabel.attributedText = attrString;
        cell.editButton.hidden = YES;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(7_0) {
    return UITableViewAutomaticDimension;
}

- (NSString *)stringFromString:(NSString *)inputString placeholder:(NSString *)placeholder {
    return inputString.length > 0 ? inputString : (self.userId == nil ? placeholder : @"");
}

- (void)logout {
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    
    NSString *token = [[FIRInstanceID instanceID] token];
    NSLog(@"Messaging instanceID token: %@", token);
    
    if (token != nil && ![token isEqualToString:@""]) {
        [WAServer removeNotificationToken:token completion:^(BOOL success) {
            NSError *signOutError;
            BOOL status = [[FIRAuth auth] signOut:&signOutError];
            if (!status) {
                NSLog(@"Error signing out: %@", signOutError);
            }
        }];
    }
}

- (void)showLogoutAlert {
    __weak typeof(self) weakSelf = self;

    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Hey" message:@"Are you sure that you want to log out?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [weakSelf logout];
    }];
    [alertVC addAction:okAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - Navigation
- (void)openSettings {
    
    [self performSegueWithIdentifier:@"openSettings" sender:self];
}

- (void)openEditProfile {
    
    [self performSegueWithIdentifier:@"openEditProfile" sender:self];
}


- (void)openCreateActivity {
    
    [self performSegueWithIdentifier:@"openCreateActivity" sender:self];
}

- (void)openEditPhoto {
    
    
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
    
    [self presentViewController:photoMenu animated:true completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"openSettings"]) {
        
        WASettingsTableViewController *destinationController = (WASettingsTableViewController *) [segue destinationViewController];
        destinationController.user = self.user;
    }
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
    self.user.profileImageURL = @"http";
    [self.tableView reloadData];
    
    self.loadProfilePhoto = false;
    
    [self dismissViewControllerAnimated:true completion:^(void){
//        self.loadProfilePhoto = true;
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
            self.loadProfilePhoto = YES;
            [WAServer updateUserProfileImageURL:[metadata.downloadURL absoluteString] completion:nil];
        }
    }];
    
}

@end
