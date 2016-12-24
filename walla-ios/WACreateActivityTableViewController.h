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
#import "WACreateActivityExtraTableViewCell.h"

#import "WADatePickerViewController.h"
#import "WAGroupPickerViewController.h"

@interface WACreateActivityTableViewController : UITableViewController <WADatePickerViewControllerDelegate, WAGroupPickerViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate>

@property BOOL activityPublic;

@property NSString *activityTitle;

@property NSDate *activityStartTime;

@property NSDate *activityEndTime;

@property NSString *activityLocationString;

@property NSString *activityDetails;

@property NSString *activityHostGroupID;
@property NSString *activityHostGroupName;

@property NSMutableArray *activityInterests;

@property NSMutableArray *activityInvitedGroups;

@property NSMutableArray *activityInvitedFriends;

@property UIColor *notSelectedColor;
@property UIColor *selectedColor;

@end
