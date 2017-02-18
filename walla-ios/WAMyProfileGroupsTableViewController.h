//
//  WAMyProfileGroupsTableViewController.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/27/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WAGroupShadowTableViewCell.h"

@interface WAMyProfileGroupsTableViewController : UITableViewController

@property NSMutableArray *userGroupsArray;

@property NSArray *userGroupIDs;

@property NSString *openGroupID;

@end