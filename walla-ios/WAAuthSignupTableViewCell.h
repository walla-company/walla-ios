//
//  WAAuthSignupTableViewCell.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 3/17/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WAAuthSignupTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *choosePhotoButton;

@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;

@property (strong, nonatomic) IBOutlet UILabel *emailAddressLabel;

@property (strong, nonatomic) IBOutlet UITextField *firstNametextField;

@property (strong, nonatomic) IBOutlet UITextField *lastNameTextField;

@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) IBOutlet UIButton *signupButton;

@property (strong, nonatomic) IBOutlet UIButton *backButton;

@end
