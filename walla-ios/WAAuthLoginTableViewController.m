//
//  WAAuthLoginTableViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 3/17/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import "WAAuthLoginTableViewController.h"

#import "WAAuthLoginTableViewCell.h"
#import "WAAuthClearTableViewCell.h"

#import "WAValues.h"

@import Firebase;

@interface WAAuthLoginTableViewController ()

@end

@implementation WAAuthLoginTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WAAuthLoginTableViewCell" bundle:nil] forCellReuseIdentifier:@"loginCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WAAuthClearTableViewCell" bundle:nil] forCellReuseIdentifier:@"clearCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.showsVerticalScrollIndicator = false;
    
    self.tableView.bounces = true;
    
    self.tableView.backgroundColor = [WAValues colorFromHexString:@"#FFA44A"];
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    self.password = @"";
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
        
        WAAuthLoginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"loginCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.backgroundColor = [WAValues colorFromHexString:@"#FFA44A"];
        
        [cell.backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.emailAddressLabel.text = self.emailAddress;
        
        cell.passwordTextField.delegate = self;
        
        return cell;
    }
    
    WAAuthClearTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"clearCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor = [WAValues colorFromHexString:@"#FFA44A"];
    
    cell.forgotPasswordButton.hidden = !(indexPath.row == 2);
    
    [cell.forgotPasswordButton addTarget:self action:@selector(forgotPasswordButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark - Button targets

- (void)backButtonPressed:(UIButton *)button {
    
    [self.navigationController popViewControllerAnimated:true];
}

- (void)forgotPasswordButtonPressed:(UIButton *)button {
    
    NSLog(@"Reset password: %@", self.emailAddress);
    
    self.tableView.userInteractionEnabled = false;
    
    [[FIRAuth auth] sendPasswordResetWithEmail:self.emailAddress completion:^(NSError *error) {
        
        self.tableView.userInteractionEnabled = true;
        
        if (error) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"There was a problem resetting your password. Make sure you entered your email address correctly." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:true completion:nil];
        }
        else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Email Sent" message:@"You will receive a password reset email shortly." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [self.navigationController popViewControllerAnimated:true];
            }];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:true completion:nil];
        }
    }];
    
}

- (void)loginButtonPressed:(UIButton *)button {
    
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"inSignup"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    WAAuthLoginTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    self.password = cell.passwordTextField.text;
    
    if ([self.password isEqualToString:@""]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Incomplete" message:@"You must enter a password." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:true completion:nil];
    }
    else {
        
        self.tableView.userInteractionEnabled = false;
        
        [[FIRAuth auth] signInWithEmail:self.emailAddress password:self.password completion:^(FIRUser *user, NSError *error) {
            
            if (error) {
                
                if (error.code == FIRAuthErrorCodeWrongPassword) {
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Wrong Password" message:@"The password you entered is incorrect. Tap on \"Forgot password\" below to reset your password if you cannot remember it." preferredStyle:UIAlertControllerStyleAlert];
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
                else if (error.code == FIRAuthErrorCodeUserDisabled) {
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"User Account Disabled" message:@"Your account has been disabled. We disable accounts when we find that they violate the Community Guidelines. Please contact us to resolve this issue." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
                    [alert addAction:cancelAction];
                    [self presentViewController:alert animated:true completion:nil];
                }
                else {
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Unknown Error" message:@"Please try again." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
                    [alert addAction:cancelAction];
                    [self presentViewController:alert animated:true completion:nil];
                }
                
                NSLog(@"Login Error: %@", error);
            }
            
            self.tableView.userInteractionEnabled = true;
            
        }];
    }
    
}

#pragma mark - Text field delegate

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
    
    self.password = textField.text;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    self.password = textField.text;
    
    return true;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    [self loginButtonPressed:nil];
    
    return false;
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
