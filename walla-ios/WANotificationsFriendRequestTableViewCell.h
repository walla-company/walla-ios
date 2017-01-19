//
//  WANotificationsFriendRequestTableViewCell.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/29/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WANotificationsFriendRequestTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;

@property (strong, nonatomic) IBOutlet UILabel *infoLabel;

@property (strong, nonatomic) IBOutlet UIView *acceptView;
@property (strong, nonatomic) IBOutlet UIButton *acceptButton;

@property (strong, nonatomic) IBOutlet UIView *ignoreView;
@property (strong, nonatomic) IBOutlet UIButton *ignoreButton;

@end
