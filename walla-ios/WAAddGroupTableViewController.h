//
//  WAAddGroupTableViewController.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 3/17/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WAAddGroupTableViewController : UITableViewController <UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate>

@property NSArray *allGroupsArray;

@property NSMutableArray *filteredGroupArray;

@property UISearchController *searchController;

@property BOOL shouldShowSearchResults;

@property NSMutableDictionary *groupsDictionary;

@end
