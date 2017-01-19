//
//  WAViewActivityViewController.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/26/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WAViewActivityInfoTableViewCell.h"
#import "WAViewActivityLocationTableViewCell.h"
#import "WAViewActivityAttendeesTableViewCell.h"
#import "WAViewActivityButtonsTableViewCell.h"
#import "WAViewActivityHostTableViewCell.h"
#import "WAViewActivityDetailsTableViewCell.h"

#import "WAActivityTabsHeaderView.h"

#import "WAGroupPickerViewController.h"
#import "WAUserPickerViewController.h"

#import "WAActivity.h"

@interface WAViewActivityViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, WAActivityTabDelegate, WAGroupPickerViewControllerDelegate, WAUserPickerViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *viewActivityTableView;

@property NSString *viewingActivityID;

@property WAActivity *viewingActivity;

@property NSMutableDictionary *userInfoDictionary;

@property NSString *activityHostName;
@property NSString *activityHostDetails;
@property UIImage *activityHostImage;

@property NSMutableArray *invitedUserIDs;
@property NSMutableArray *invitedGroupIDs;

@property NSArray *userFriends;
@property NSArray *userGroups;

@end
