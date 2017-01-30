//
//  WALoginTableViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 1/1/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import "WALoginTableViewController.h"

#import "WALoginSignupIconTableViewCell.h"
#import "WALoginSignupTextFieldTableViewCell.h"
#import "WALoginSignupButtonTableViewCell.h"
#import "WALoginBottomButtonTableViewCell.h"

#import "WAValues.h"

@import Firebase;

@interface WALoginTableViewController ()

@end

@implementation WALoginTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up table view
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WALoginSignupIconTableViewCell" bundle:nil] forCellReuseIdentifier:@"iconCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WALoginSignupTextFieldTableViewCell" bundle:nil] forCellReuseIdentifier:@"textFieldCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WALoginSignupButtonTableViewCell" bundle:nil] forCellReuseIdentifier:@"buttonCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WALoginBottomButtonTableViewCell" bundle:nil] forCellReuseIdentifier:@"bottomCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = [WAValues loginSignupTableViewBackgroundColor];
    
    self.tableView.showsVerticalScrollIndicator = false;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100.0;
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    // Initialize values
    
    self.emailAddress = @"";
    self.password = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        WALoginSignupIconTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iconCell" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    if (indexPath.row == 3) {
        
        WALoginSignupButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buttonCell" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.button setTitle:@"Log in" forState:UIControlStateNormal];
        [cell.button addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    if (indexPath.row == 4) {
        
        WALoginBottomButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bottomCell" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.signupButton addTarget:self action:@selector(signupButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.forgotPasswordButton addTarget:self action:@selector(forgotPasswordButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    WALoginSignupTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textFieldCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 1) {
        
        cell.textField.placeholder = @"Email Address";
        cell.textField.tag = 1;
        cell.textField.delegate = self;
        
        cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
        cell.textField.secureTextEntry = false;
        
        cell.textField.returnKeyType = UIReturnKeyNext;
        
        cell.textField.text = self.emailAddress;
    }
    else if (indexPath.row == 2) {
        
        cell.textField.placeholder = @"Password";
        cell.textField.tag = 2;
        cell.textField.delegate = self;
        
        cell.textField.keyboardType = UIKeyboardTypeASCIICapable;
        cell.textField.secureTextEntry = true;
        
        cell.textField.returnKeyType = UIReturnKeyDone;
        
        cell.textField.text = self.password;
    }
    
    return cell;
}

#pragma mark - Text field delegate

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
    
    NSLog(@"textFieldDidEndEditing: %@", textField.text);
    
    if (textField.tag == 1) {
        self.emailAddress = textField.text;
    }
    else if (textField.tag == 2) {
        self.password = textField.text;
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.tag == 1) {
        WALoginSignupTextFieldTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        
        [cell.textField becomeFirstResponder];
    }
    else if (textField.tag == 2) {
        
        [textField resignFirstResponder];
        
        [self loginButtonPressed:nil];
    }
    
    return false;
}

# pragma mark - Button targets

- (void)loginButtonPressed:(UIButton *)button {
    
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"inSignup"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([self.emailAddress isEqualToString:@""] || [self.password isEqualToString:@""]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Incomplete" message:@"You must enter an email address and password to log in. If you forgot your password, click \"Forgot password\" below." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:true completion:nil];
    }
    else {
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
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Check Email Address" message:@"Make sure the email address you entered is correct." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
                    [alert addAction:cancelAction];
                    [self presentViewController:alert animated:true completion:nil];
                }
                
                NSLog(@"Login Error: \(error)");
            }
            
        }];
    }
    
}

- (void)signupButtonPressed:(UIButton *)button {
    
    [self performSegueWithIdentifier:@"openSignup" sender:self];
}

- (void)forgotPasswordButtonPressed:(UIButton *)button {
    
    [self performSegueWithIdentifier:@"openForgotPassword" sender:self];
}

@end
