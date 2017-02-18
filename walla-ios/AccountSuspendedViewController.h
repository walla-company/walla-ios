//
//  AccountSuspendedViewController.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 2/12/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountSuspendedViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *buttonView;

- (IBAction)logoutButtonPressed:(UIButton *)sender;

@end
