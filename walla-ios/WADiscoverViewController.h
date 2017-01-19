//
//  WADiscoverViewController.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/27/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WADiscoverFriendSuggestionsTableViewCell.h"
#import "WADiscoverSuggestedGroupTableViewCell.h"

@interface WADiscoverViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, WADiscoverFriendSuggestionsTableViewCellDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate>

@property NSString *openUserID;
@property NSString *openGroupID;

@property (strong, nonatomic) IBOutlet UITableView *discoverTableView;

@property NSArray *suggestedGroups;

@property NSDictionary *searchGroupsDictionary;
@property NSDictionary *searchUsersDictionary;

@property NSMutableArray *filteredUserArray;
@property NSMutableArray *filteredGroupArray;

@property UISearchController *searchController;

@property BOOL shouldShowSearchResults;

@property NSMutableDictionary *userInfoDictionary;
@property NSMutableDictionary *userProfileImageDictionary;
@property NSMutableDictionary *groupsDictionary;

@end
