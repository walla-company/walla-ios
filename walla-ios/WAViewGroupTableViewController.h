//
//  WAViewGroupTableViewController.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/27/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WAViewGroupInfoTableViewCell.h"
#import "WAViewGroupDetailsTableViewCell.h"
#import "WAActivityTableViewCell.h"

#import "WAActivityTabsHeaderView.h"

#import "WAGroup.h"

@interface WAViewGroupTableViewController : UITableViewController <WAActivityTabDelegate>

@property NSString *viewingGroupID;

@property WAGroup *viewingGroup;

@property NSMutableDictionary *activitiesDictionary;
@property NSMutableSet *loadingActivitiesSet;

@property NSMutableDictionary *userInfoDictionary;

@property NSMutableArray *userGroups;

@end
