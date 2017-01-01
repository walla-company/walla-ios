//
//  WAViewActivityButtonsTableViewCell.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/26/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WAViewActivityButtonsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *interestedView;
@property (strong, nonatomic) IBOutlet UIButton *interestedButton;

@property (strong, nonatomic) IBOutlet UIView *goingView;
@property (strong, nonatomic) IBOutlet UIButton *goingButton;

@property (strong, nonatomic) IBOutlet UIView *inviteView;
@property (strong, nonatomic) IBOutlet UIButton *inviteButton;

@property (strong, nonatomic) IBOutlet UIView *shareView;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;

@property (strong, nonatomic) IBOutlet UILabel *invitedPeopleHeaderLabel;
@property (strong, nonatomic) IBOutlet UILabel *invitedPeopleLabel;

@end
