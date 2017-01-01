//
//  WAViewActivityInfoTableViewCell.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/26/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WAActivityTabsHeaderView.h"

@interface WAViewActivityInfoTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet WAActivityTabsHeaderView *activityHeaderView;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;


@end
