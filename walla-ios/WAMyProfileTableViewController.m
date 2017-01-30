//
//  WAMyProfileTableViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/17/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WAMyProfileTableViewController.h"

#import "WAMyProfileMainTableViewCell.h"
#import "WAMyProfileTextTableViewCell.h"

#import "WAServer.h"

@import Firebase;

@interface WAMyProfileTableViewController ()

@end

@implementation WAMyProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CreateNewEvent"] style:UIBarButtonItemStylePlain target:self action:@selector(openCreateActivity)];
    
    // Set up table view
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WAMyProfileMainTableViewCell" bundle:nil] forCellReuseIdentifier:@"mainCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WAMyProfileTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"textCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = [[UIColor alloc] initWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 65.0;
    
    self.tableView.showsVerticalScrollIndicator = false;
    
    // Initialize values
    self.titleArray = @[@"Edit profile", @"My friends", @"My groups", @"My interests", @"About Walla", @"Log out"];
    
    self.name = @"";
    self.academicLevel = @"";
    self.major = @"";
    self.graduationYear = @"";
    self.hometown = @"";
    self.profileImageURL = @"";
    self.profileImage = [UIImage imageNamed:@"BlankCircle"];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [WAServer getUserBasicInfoWithID:[FIRAuth auth].currentUser.uid completion:^(NSDictionary *user){
        
        self.name = [user objectForKey:@"name"];
        self.graduationYear = [NSString stringWithFormat:@"%@", [user objectForKey:@"graduation_year"]];
        self.academicLevel = ([[user objectForKey:@"academic_level"] isEqualToString:@"undergrad"]) ? @"Undergraduate" : @"Graduate";
        self.major = [user objectForKey:@"major"];
        self.hometown = [user objectForKey:@"hometown"];
        self.profileImageURL = [user objectForKey:@"profile_image_url"];
        
        [self.tableView reloadData];
        
        [self loadProfileImage];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadProfileImage {
    
    if (![self.profileImageURL isEqualToString:@""]) {
        
        FIRStorage *storage = [FIRStorage storage];
        
        FIRStorageReference *imageRef = [storage referenceForURL:self.profileImageURL];
        
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
    
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        WAMyProfileMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor clearColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.profileImageView.image = (self.profileImage) ? self.profileImage : [UIImage imageNamed:@"BlankCircle"];
        
        cell.profileImageView.clipsToBounds = true;
        cell.profileImageView.layer.cornerRadius = 32.5;
        
        cell.nameLabel.text = self.name;
        cell.infoLabel.text = [NSString stringWithFormat:@"%@ Class of %@\n%@", self.academicLevel, self.graduationYear, self.major];
        cell.locationLabel.text = self.hometown;
        
        return cell;
    }
    
    WAMyProfileTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.customTextLabel.text = self.titleArray[indexPath.row - 1];
    
    if (indexPath.row == 6) {
        cell.textLabel.textColor = [UIColor redColor];
    }
    else {
        cell.textLabel.textColor = [[UIColor alloc] initWithRed:109.0/255.0 green:109.0/255.0 blue:109.0/255.0 alpha:1.0];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
            
        case 1:
            [self performSegueWithIdentifier:@"openEditProfile" sender:self];
            break;
            
        case 2:
            [self performSegueWithIdentifier:@"openMyFriends" sender:self];
            break;
            
        case 3:
            [self performSegueWithIdentifier:@"openMyGroups" sender:self];
            break;
            
        case 4:
            [self performSegueWithIdentifier:@"openMyInterests" sender:self];
            break;
            
        case 5:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.wallasquad.com/"] options:@{} completionHandler:nil];
            break;
            
        default:
            break;
    }
    
    if (indexPath.row == 6) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure?" message:@"You will have to log back in." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:cancelAction];
        
        UIAlertAction *option = [UIAlertAction actionWithTitle:@"Log out" style:UIAlertActionStyleDestructive handler: ^(UIAlertAction *action){
            [self logout];
        }];
        
        [alert addAction:option];
        
        [self presentViewController:alert animated:true completion:nil];
    }
    
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

#pragma mark - Navigation

- (void)openCreateActivity {
    
    [self performSegueWithIdentifier:@"openCreateActivity" sender:self];
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
