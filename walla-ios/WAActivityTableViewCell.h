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

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UIImageView *audienceImageView;

@property (strong, nonatomic) IBOutlet UILabel *interestedCountLabel;

@property (strong, nonatomic) IBOutlet UILabel *goingCountLabel;

@property (strong, nonatomic) IBOutlet UILabel *goinNamesLabel;

@end
