//
//  WACreateActivityTableViewController.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/17/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WACreateActivityAudienceTableViewCell.h"
#import "WACreateActivityTitleTableViewCell.h"
#import "WACreateActivityTimeTableViewCell.h"
#import "WACreateActivityLocationTableViewCell.h"
#import "WACreateActivityDetailsTableViewCell.h"
#import "WACreateActivityHostTableViewCell.h"
#import "WACreateActivityInterestsTableViewCell.h"
#import "WACreateActivityInviteGroupsTableViewCell.h"
#import "WACreateActivityInviteFriendsTableViewCell.h"
#import "WACreateActivityCanInviteTableViewCell.h"
#import "WACreateActivityPostTableViewCell.h"

#import "WADatePickerViewController.h"
#import "WAGroupPickerViewController.h"
#import "WAUserPickerViewController.h"

#import "WAGroup.h"
#import "WAUser.h"

@interface WACreateActivityTableViewController : UITableViewController <WADatePickerViewControllerDelegate, WAGroupPickerViewControllerDelegate, WAUserPickerViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate>


// Required
@property BOOL activityPublic;
@property NSString *activityTitle;
@property NSDate *activityStartTime;
@property NSDate *activityEndTime;
@property NSString *activityLocationString;
@property NSArray *activityInterests;
@property BOOL guestsCanInviteOthers;

// Optional
@property NSString *activityDetails;
@property NSArray *activityHostGroup;
@property NSArray *activityInvitedGroups;
@property NSArray *activityInvitedFriends;

@property UIColor *notSelectedColor;
@property UIColor *selectedColor;

typedef NS_ENUM(NSUInteger, ShapeType) {
    kAudienceCellRow = 0,
    kTitleCellRow = 1,
    kTimeCellRow = 2,
    kLocationCellRow = 3,
    kInterestsCellRow = 4,
    kDetailsCellRow = 5,
    kHostCellRow = 6,
    kInviteGroupsCellRow = 7,
    kInviteFriendsCellRow = 8,
    kCanInviteCellRow = 9,
    kPostCellRow = 10,
};


@end
