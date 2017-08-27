//
//  WAProfileHeaderTableViewCell.h
//  walla-ios
//
//  Created by Stas Tomych on 8/21/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WAProfileHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIView *imageEditView;
@property (weak, nonatomic) IBOutlet UIView *imageContainerView;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *incompleteAlertViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *emojiLabel;

@end
