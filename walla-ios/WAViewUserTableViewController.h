//
//  WAViewUserTableViewController.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/27/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WAViewUserProfileTableViewCell.h"
#import "WAViewUserDetailsTableViewCell.h"
#import "WAActivityTableViewCell.h"

#import "WAActivityTabsHeaderView.h"

#import "WAUser.h"

@interface WAViewUserTableViewController : UITableViewController <WAActivityTabDelegate, WAViewUserProfileTableViewCellDelegate>

@property NSString *viewingUserID;

@property UIColor *tabColorLightGray;
@property UIColor *tabColorOrange;
@property UIColor *tabColorOffwhite;

@property WAUser *viewingUser;

@property UIImage *viewingUserProfileImage;

@property NSMutableDictionary *groupInfoDictionary;

@property NSMutableDictionary *activitiesDictionary;
@property NSMutableSet *loadingActivitiesSet;

@property NSMutableDictionary *userInfoDictionary;

@property NSArray *userFriendsArray;
@property NSArray *userSentFriendRequestsArray;
@property NSArray *userReceivedFriendRequestsArray;

@end
