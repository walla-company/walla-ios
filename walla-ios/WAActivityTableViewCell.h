//
//  WAActivityTableViewCell.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/15/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WAActivityTabsHeaderView.h"

@interface WAActivityTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet WAActivityTabsHeaderView *headerView;

@end
