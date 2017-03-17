//
//  WAViewActivityTableViewController.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 2/4/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WAViewActivityReplyTableViewCell.h"
#import "WAViewActivityTextTableViewCell.h"
#import "WAViewActivityMapTableViewCell.h"
#import "WAViewActivityPostDiscussionTableViewCell.h"
#import "WAViewActivityExtraTableViewCell.h"

#import "WAActivity.h"

@interface WAViewActivityTableViewController : UITableViewController <UITextViewDelegate>

@property BOOL userVerified;

@property NSString *viewingActivityID;

@property WAActivity *viewingActivity;

@property NSString *discussionPostText;

@property NSArray *discussions;

@property NSMutableDictionary *userNamesDictionary;
@property NSMutableDictionary *profileImagesDictionary;

@end
