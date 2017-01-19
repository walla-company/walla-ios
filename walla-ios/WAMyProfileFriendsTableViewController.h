//
//  WAMyProfileFriendsTableViewController.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/27/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WAUserShadowTableViewCell.h"

@interface WAMyProfileFriendsTableViewController : UITableViewController

@property NSMutableArray *userFriendsArray;

@property NSArray *userFriendIDs;

@property NSString *openUserID;

@property NSMutableDictionary *profileImages;

@end
