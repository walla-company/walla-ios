//
//  WAAuthLoginTableViewCell.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 3/17/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WAAuthLoginTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *emailAddressLabel;

@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) IBOutlet UIButton *loginButton;

@property (strong, nonatomic) IBOutlet UIButton *backButton;

@end
