//
//  WAAuthCheckEmailTableViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 3/17/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import "WAAuthCheckEmailTableViewController.h"

#import "WAAuthLoginTableViewController.h"
#import "WAAuthSignupTableViewController.h"

#import "WAAuthCheckEmailTableViewCell.h"
#import "WAAuthClearTableViewCell.h"

#import "UITableView+Walla.h"

#import "WAServer.h"
#import "WAValues.h"

@import Firebase;

@interface WAAuthCheckEmailTableViewController ()

@end

@implementation WAAuthCheckEmailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WAAuthCheckEmailTableViewCell" bundle:nil] forCellReuseIdentifier:@"checkCell"];
   
    [self.tableView registerNib:[UINib nibWithNibName:@"WAAuthClearTableViewCell" bundle:nil] forCellReuseIdentifier:@"clearCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.showsVerticalScrollIndicator = false;
    
    self.tableView.bounces = true;
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self.tableView setUpFadedBackgroundView];
    
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
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1) return 400;
    
    return ([[UIScreen mainScreen] bounds].size.height - 420) / 2.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1) {
        
        WAAuthCheckEmailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"checkCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.emailAddressTextField.delegate = self;
        
        [cell.continueButton addTarget:self action:@selector(continueButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    WAAuthClearTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"clearCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    cell.forgotPasswordButton.hidden = true;
    
    return cell;
}

#pragma mark - Button target

- (void)continueButtonPressed:(UIButton *) button {
    
    WAAuthCheckEmailTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    self.emailAddress = cell.emailAddressTextField.text;
    
    NSLog(@"Check email address: %@", self.emailAddress);
    
    NSString *schoolIdentifier = [WAServer schoolIdentifierFromEmail:self.emailAddress];
    
    if ([self.emailAddress isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Incomplete" message:@"Please enter an email address." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:true completion:nil];
    }
    else if ([schoolIdentifier isEqualToString:@""]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Use School Email" message:@"You must use your school email address." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:true completion:nil];
    }
    else {
        [[FIRAuth auth] fetchProvidersForEmail:self.emailAddress completion:^(NSArray *providers, NSError *error) {
            
            if (error) {
                if (error.code == FIRAuthErrorCodeNetworkError) {
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Network Error" message:@"There was a problem communicating with our servers. Please make sure you are connected to the internet and try again." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
                    [alert addAction:cancelAction];
                    [self presentViewController:alert animated:true completion:nil];
                }
                else if (error.code == FIRAuthErrorCodeInvalidEmail) {
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Email Address" message:@"The email address you entered is not valid." preferredStyle:UIAlertControllerStyleAlert];
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
                
                NSLog(@"Check Email Error: %@", error);
            }
            else {
                if ([providers count] > 0) {
                    NSLog(@"Account exists");
                    
                    [self performSegueWithIdentifier:@"openLogin" sender:self];
                }
                else {
                    NSLog(@"Account does not exist");
                    
                    [self performSegueWithIdentifier:@"openSignup" sender:self];
                }
            }
            
        }];
    }
}

#pragma mark - Text field delegate

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
    
    self.emailAddress = textField.text;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    self.emailAddress = textField.text;
    
    return true;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    [self continueButtonPressed:nil];
    
    return false;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"openLogin"]) {
        
        WAAuthLoginTableViewController *destinationController = (WAAuthLoginTableViewController *) [segue destinationViewController];
        destinationController.emailAddress = self.emailAddress;
    }
    else if ([segue.identifier isEqualToString:@"openSignup"]) {
        
        WAAuthSignupTableViewController *destinationController = (WAAuthSignupTableViewController *) [segue destinationViewController];
        destinationController.emailAddress = self.emailAddress;
    }
}

@end
