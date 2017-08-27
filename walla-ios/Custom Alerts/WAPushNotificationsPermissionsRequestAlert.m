//
//  WAPushNotificationsPermissionsRequestAlert.m
//  walla-ios
//
//  Created by Stas Tomych on 8/17/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import "WAPushNotificationsPermissionsRequestAlert.h"
#import "AppDelegate.h"

@interface WAPushNotificationsPermissionsRequestAlert ()

@end

@implementation WAPushNotificationsPermissionsRequestAlert

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)doneButtonClicked:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] setBool: YES forKey:@"APNSPermissionsAsked"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    AppDelegate *delegate = (AppDelegate *)UIApplication.sharedApplication.delegate;
    [delegate setupNotifications];
    [self dismissViewControllerAnimated:YES completion:nil];

}

+ (void) presentFromViewController:(UIViewController *)viewController {
    UIStoryboard *alerts = [UIStoryboard storyboardWithName:@"Alerts" bundle:[NSBundle mainBundle]];
    
    WAPushNotificationsPermissionsRequestAlert *alert = [alerts instantiateViewControllerWithIdentifier:NSStringFromClass([WAPushNotificationsPermissionsRequestAlert class])];
    
    viewController.definesPresentationContext = YES;
    alert.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    alert.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [viewController presentViewController:alert animated:YES completion:nil];
}

@end
