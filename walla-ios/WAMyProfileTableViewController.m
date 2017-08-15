//
//  WAMyProfileTableViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/17/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WAMyProfileTableViewController.h"

#import "WAMyProfileMainTableViewCell.h"
#import "WAMyProfileGroupTableViewCell.h"
#import "WAMyProfileDetailsTableViewCell.h"
#import "WAMyProfileTextTableViewCell.h"
#import "WAMyProfileInfoTableViewCell.h"
#import "WAMyProfileClearTableViewCell.h"

#import "WAServer.h"
#import "WAValues.h"

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
    [self.tableView registerNib:[UINib nibWithNibName:@"WAMyProfileGroupTableViewCell" bundle:nil] forCellReuseIdentifier:@"groupCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WAMyProfileDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"detailsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WAMyProfileTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"textCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WAMyProfileInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"infoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WAMyProfileClearTableViewCell" bundle:nil] forCellReuseIdentifier:@"clearCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = [[UIColor alloc] initWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 65.0;
    
    self.tableView.showsVerticalScrollIndicator = false;
    
    // Initialize values
    self.titleArray = @[@"Edit profile", @"About Walla", @"Log out"];
    
    self.profileImage = [UIImage imageNamed:@"BlankCircle"];
    
    self.groupsDictionary = [[NSMutableDictionary alloc] init];
    
    self.title = self.userId != nil ? @"Profile" : @"My Profile";
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [WAServer getUserWithID: self.userId != nil ? self.userId : [FIRAuth auth].currentUser.uid  completion:^(WAUser *user) {
        
        self.user = user;
        
        [self.tableView reloadData];
        
        [self loadProfileImage];
    }];
    
    BOOL openEditProfile = [[NSUserDefaults standardUserDefaults] boolForKey:@"openEditProfile"];
    
    if (openEditProfile) {
        
        [self performSegueWithIdentifier:@"openEditProfile" sender:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadProfileImage {
    
    if (![self.user.profileImageURL isEqualToString:@""]) {
        
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger mandatoryRows = self.userId != nil ? 3 : 8;
    return [self.user.groups count] + mandatoryRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        WAMyProfileMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor whiteColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.profileImageView.image = (self.profileImage) ? self.profileImage : [UIImage imageNamed:@"BlankCircle"];
        
        cell.profileImageView.clipsToBounds = true;
        cell.profileImageView.layer.cornerRadius = 32.5;
        
        cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", self.user.firstName, self.user.lastName];
        
        NSString *levelString = ([self.user.academicLevel isEqualToString:@""]) ? @"" : [NSString stringWithFormat:@"%@ ", ([self.user.academicLevel isEqualToString:@"undergrad"]) ? @"Undergraduate" : @"Grad/Prof"];
        NSString *yearString = ([self.user.graduationYear integerValue] <=0 ) ? @"" : [NSString stringWithFormat:@"Class of %@", self.user.graduationYear];
        NSString *majorString = ([self.user.major isEqualToString:@""]) ? @"" : [NSString stringWithFormat:@"\n%@", self.user.major];
        
        cell.infoLabel.text = [NSString stringWithFormat:@"%@%@%@", levelString, yearString, majorString];
        cell.locationLabel.text = ([self.user.hometown isEqualToString:@""]) ? @"" : [NSString stringWithFormat:@"From %@", self.user.hometown];
        
        return cell;
    }
    
    if ([self.user.groups count] > 0 && indexPath.row >= 1 && indexPath.row <= [self.user.groups count]) {
        WAMyProfileGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupCell" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor whiteColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *groupID = self.user.groups[indexPath.row - 1];
        
        if (self.groupsDictionary[groupID]) {
            NSDictionary *group = self.groupsDictionary[groupID];
            
            cell.groupNameLabel.text = group[@"name"];
            cell.groupTagViewLabel.text = group[@"short_name"];
            cell.groupTagView.backgroundColor = [WAValues colorFromHexString:group[@"color"]];
        }
        else {
            cell.groupTagView.backgroundColor = [UIColor whiteColor];
            cell.groupTagViewLabel.text = @"";
            cell.groupNameLabel.text = @"";
            [self.groupsDictionary setObject:@{@"name": @"", @"short_name": @"", @"color": @"#ffffff"} forKey:groupID];
            [WAServer getGroupBasicInfoWithID:groupID completion:^(NSDictionary *group) {
                
                [self.groupsDictionary setObject:group forKey:groupID];
                
                [self.tableView reloadData];
            }];
        }
        
        return cell;
    }
    
    if (indexPath.row == 1 + [self.user.groups count]) {
        WAMyProfileDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailsCell" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor whiteColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.detailsLabel.text = self.user.details;
        
        return cell;
    }
    
    if (indexPath.row == 2 + [self.user.groups count] || indexPath.row == 6 + [self.user.groups count]) {
        WAMyProfileClearTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"clearCell" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor clearColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    if (indexPath.row == 7 + [self.user.groups count]) {
        WAMyProfileInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor whiteColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.infoLabel.text = [NSString stringWithFormat:@"Account: %@\nVersion %@\n%@", [FIRAuth auth].currentUser.email, [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"], @"© 2017 GenieUs, Inc. All rights reserved."];
        
        return cell;
    }
    
    WAMyProfileTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.customTextLabel.text = self.titleArray[indexPath.row - (3 + [self.user.groups count])];
    
    if (indexPath.row == 5 + [self.user.groups count]) {
        cell.customTextLabel.textColor = [WAValues colorFromHexString:@"#FF8F6C"];
    }
    else {
        cell.customTextLabel.textColor = [[UIColor alloc] initWithRed:109.0/255.0 green:109.0/255.0 blue:109.0/255.0 alpha:1.0];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 3 + [self.user.groups count]) {
        
        [self performSegueWithIdentifier:@"openEditProfile" sender:self];
    }
    else if (indexPath.row == 4 + [self.user.groups count]) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.wallasquad.com/"] options:@{} completionHandler:nil];
    }
    else if (indexPath.row == 5 + [self.user.groups count]) {
        
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
