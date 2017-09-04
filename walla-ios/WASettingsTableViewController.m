//
//  WASettingsTableViewController.m
//  walla-ios
//
//  Created by Stas Tomych on 8/21/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import "WASettingsTableViewController.h"
#import "WASettingsTableViewCell.h"
#import "WAServer.h"
#import "WAWebViewController.h"

@import Firebase;

static NSString *settingsCellIdentifier = @"WASettingsTableViewCell";

@interface WASettingsTableViewController ()

@end

@implementation WASettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WASettingsTableViewCell" bundle:nil] forCellReuseIdentifier:settingsCellIdentifier];
    self.tableView.backgroundColor = [[UIColor alloc] initWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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

- (void)openUrl:(NSString *)urlString {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: urlString] options:@{} completionHandler:nil];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showTerms"]) {
        WAWebViewController *controller = (WAWebViewController *)segue.destinationViewController;
        controller.file = @"terms";
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 1; //return 2 rows, when change password functionality will be implemented
    } else if (section == 2) {
        return 1;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WASettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:settingsCellIdentifier forIndexPath:indexPath];
    cell.cellSubtitleLabel.text = @"";
    cell.cellTitleLabel.textColor = [UIColor blackColor];
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.cellTitleLabel.text = @"About Walla";
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        cell.cellTitleLabel.text = @"Terms of Use";
    } else if (indexPath.section == 0 && indexPath.row == 2) {
        cell.cellTitleLabel.text = @"How can we improve Walla?";
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        cell.cellTitleLabel.text = @"Account email";
        cell.cellSubtitleLabel.text = self.user.email;
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        cell.cellTitleLabel.text = @"Change my password";
    } else if (indexPath.section == 2 && indexPath.row == 0) {
        cell.cellTitleLabel.text = @"Log out";
        cell.cellTitleLabel.textColor = [UIColor colorWithRed:255/255.0 green:162./255.0 blue:71./255.0 alpha:1.0];
    }
    return cell;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 45)];
    headerView.backgroundColor = [[UIColor alloc] initWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 0, self.tableView.frame.size.width-30, 45)];
    label.textColor = [UIColor colorWithRed:165/255.0 green:165./255.0 blue:165/255.0 alpha:1.0];
    label.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium];
    [headerView addSubview:label];
    label.text = section == 0 ? @"ABOUT" : @"ACCOUNT";
    return section == 2 ? nil : headerView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 2) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 45)];
        headerView.backgroundColor = [[UIColor alloc] initWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 0, self.tableView.frame.size.width-30, 45)];
        label.textColor = [UIColor blackColor];
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        label.text = [NSString stringWithFormat:@"Walla Version %@\n© 2017 GenieUs, Inc. All rights reserved.", version];
        label.numberOfLines = 2;
        label.font = [UIFont systemFontOfSize:12.0];
        [headerView addSubview:label];
        return headerView;
    } else {
        return nil;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 2 ? 70 : 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
    // @"About Walla";
        [self openUrl: @"https://www.wallasquad.com/"];
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        [self performSegueWithIdentifier:@"showTerms" sender:self];
    } else if (indexPath.section == 0 && indexPath.row == 2) {
    //@"How can we improve Walla?";
        [self openUrl: @"mailto:judy@wallasquad.com"];
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        //@"Account email";
    } else if (indexPath.section == 1 && indexPath.row == 1) {
    //@"Change my password";
    } else if (indexPath.section == 2 && indexPath.row == 0) {
    //@"Log out";
        [self showLogoutAlert];
    }
}


@end
