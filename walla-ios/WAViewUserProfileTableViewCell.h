//
//  WAViewUserProfileTableViewCell.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/27/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WAViewUserGroupTableViewCell.h"
#import "WAViewUserGroupMoreLessTableViewCell.h"

#import "WAGroup.h"

@protocol WAViewUserProfileTableViewCellDelegate <NSObject>

- (void)showMoreLessButtonPressed;

- (void)userGroupSelected:(NSString *)groupID;

@end

@interface WAViewUserProfileTableViewCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource>

@property id <WAViewUserProfileTableViewCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UILabel *infoLabel;

@property (strong, nonatomic) IBOutlet UILabel *locationLabel;

@property (strong, nonatomic) IBOutlet UIView *addFriendView;
@property (strong, nonatomic) IBOutlet UIButton *addFriendButton;

@property (strong, nonatomic) IBOutlet UITableView *groupsTableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *groupsTableViewHeight;

@property BOOL showMore;
@property NSArray *grouspArray;

@end
