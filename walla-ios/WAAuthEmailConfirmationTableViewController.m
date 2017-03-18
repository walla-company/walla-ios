//
//  WAAuthEmailConfirmationTableViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 3/17/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import "WAAuthEmailConfirmationTableViewController.h"

#import "WAAuthConfirmEmailTableViewCell.h"
#import "WAAuthClearTableViewCell.h"

#import "WAServer.h"
#import "WAValues.h"

@import Firebase;

@interface WAAuthEmailConfirmationTableViewController ()

@end

@implementation WAAuthEmailConfirmationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WAAuthConfirmEmailTableViewCell" bundle:nil] forCellReuseIdentifier:@"confirmEmailCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WAAuthClearTableViewCell" bundle:nil] forCellReuseIdentifier:@"clearCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.showsVerticalScrollIndicator = false;
    
    self.tableView.bounces = true;
    
    self.tableView.backgroundColor = [WAValues colorFromHexString:@"#FFA44A"];
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
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
    
    if (indexPath.row == 1) return 400;
    
    return ([[UIScreen mainScreen] bounds].size.height - 420) / 2.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1) {
        
        WAAuthConfirmEmailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"confirmEmailCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.backgroundColor = [WAValues colorFromHexString:@"#FFA44A"];
        /*
        [cell.backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.emailAddressLabel.text = self.emailAddress;
        
        cell.passwordTextField.delegate = self;*/
        
        [cell.resendEmailButton addTarget:self action:@selector(resendEmailButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    WAAuthClearTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"clearCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor = [WAValues colorFromHexString:@"#FFA44A"];
    
    cell.forgotPasswordButton.hidden = !(indexPath.row == 2);
    
    [cell.forgotPasswordButton setTitle:@"Logout" forState:UIControlStateNormal];
    
    [cell.forgotPasswordButton addTarget:self action:@selector(logoutButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark - Button targets

- (void)logoutButtonPressed:(UIButton *)button {
    
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

- (void)resendEmailButtonPressed:(UIButton *)butotn {
    
    self.tableView.userInteractionEnabled = false;
    
    [WAServer sendVerificationEmail:^(BOOL success) {
        
        self.tableView.userInteractionEnabled = true;
        
        if (success) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Email Sent" message:@"We have sent you a verification email. Please open the verification link." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [self dismissViewControllerAnimated:true completion:nil];
            }];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:true completion:nil];
        }
        else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"There was an error sending the verification email. Please try again." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [self dismissViewControllerAnimated:true completion:nil];
            }];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:true completion:nil];
        }
    }];
    
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
