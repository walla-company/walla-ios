//
//  WAForgotPasswordTableViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 1/29/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import "WAForgotPasswordTableViewController.h"

#import "WALoginSignupIconTableViewCell.h"
#import "WALoginSignupTextFieldTableViewCell.h"
#import "WALoginSignupButtonTableViewCell.h"
#import "WASignupBottomButtonTableViewCell.h"

#import "WAValues.h"

@import Firebase;

@interface WAForgotPasswordTableViewController ()

@end

@implementation WAForgotPasswordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up table view
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WALoginSignupIconTableViewCell" bundle:nil] forCellReuseIdentifier:@"iconCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WALoginSignupTextFieldTableViewCell" bundle:nil] forCellReuseIdentifier:@"textFieldCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WALoginSignupButtonTableViewCell" bundle:nil] forCellReuseIdentifier:@"buttonCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WASignupBottomButtonTableViewCell" bundle:nil] forCellReuseIdentifier:@"bottomCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = [WAValues loginSignupTableViewBackgroundColor];
    
    self.tableView.showsVerticalScrollIndicator = false;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100.0;
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    // Initialize values
    
    self.emailAddress = @"";
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
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        WALoginSignupIconTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iconCell" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    if (indexPath.row == 1) {
        WALoginSignupTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textFieldCell" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textField.placeholder = @"Email Address";
        cell.textField.tag = 1;
        cell.textField.delegate = self;
        
        cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
        cell.textField.secureTextEntry = false;
        
        cell.textField.returnKeyType = UIReturnKeyDone;
        
        cell.textField.text = self.emailAddress;
        
        return cell;
    }
    
    if (indexPath.row == 2) {
        
        WALoginSignupButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buttonCell" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.button setTitle:@"Send password reset email" forState:UIControlStateNormal];
        [cell.button addTarget:self action:@selector(sendEmailButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    WASignupBottomButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bottomCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.loginButton setTitle:@"Back" forState:UIControlStateNormal];
    [cell.loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark - Text field delegate

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
    
    NSLog(@"textFieldDidEndEditing: %@", textField.text);
    
    self.emailAddress = textField.text;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self sendPasswordResetEmail];
    
    return false;
}

#pragma mark - Button targets

- (void)sendEmailButtonPressed:(UIButton *)button {
    
    [self sendPasswordResetEmail];
}

- (void)loginButtonPressed:(UIButton *)button {
    
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - Reset password

- (void)sendPasswordResetEmail {
    
    NSLog(@"Reset password: %@", self.emailAddress);
    
    self.tableView.userInteractionEnabled = false;
    
    if ([self.emailAddress isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Enter Email Address" message:@"Enter your email address to reset your password." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:true completion:nil];
    }
    else {
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
                    [self dismissViewControllerAnimated:true completion:nil];
                }];
                [alert addAction:cancelAction];
                [self presentViewController:alert animated:true completion:nil];
            }
         }];
    }
    
}

@end
