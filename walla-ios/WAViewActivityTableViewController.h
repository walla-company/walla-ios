//
//  WAViewActivityTableViewController.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 2/4/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WAViewActivityInfoTableViewCell.h"
#import "WAViewActivityLocationTableViewCell.h"
#import "WAViewActivityAttendeesTableViewCell.h"
#import "WAViewActivityButtonsTableViewCell.h"
#import "WAViewActivityHostTableViewCell.h"
#import "WAViewActivityDetailsTableViewCell.h"
#import "WAViewActivityDiscussionTableViewCell.h"
#import "WAViewActivityPostDiscussionTableViewCell.h"

#import "WAActivityTabsHeaderView.h"

#import "WAGroupPickerViewController.h"
#import "WAUserPickerViewController.h"

#import "WAActivity.h"

@interface WAViewActivityTableViewController : UITableViewController <WAActivityTabDelegate, WAGroupPickerViewControllerDelegate, WAUserPickerViewControllerDelegate, UITextViewDelegate>

@property BOOL userVerified;

@property NSString *viewingActivityID;

@property WAActivity *viewingActivity;

@property NSMutableDictionary *profilesImagesDictionary;
@property NSMutableDictionary *userInfoDictionary;
@property NSMutableDictionary *userInfoDiscussionsDictionary;

@property NSString *activityHostName;
@property NSString *activityHostDetails;
@property UIImage *activityHostImage;

@property NSMutableArray *invitedUserIDs;
@property NSMutableArray *invitedGroupIDs;

@property NSArray *userFriends;
@property NSArray *userGroups;

@property (strong, nonatomic) IBOutlet UIView *keyboardView;

@property NSString *discussionPostText;

@property NSArray *discussions;

@end
