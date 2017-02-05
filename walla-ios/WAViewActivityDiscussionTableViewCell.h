//
//  WAViewActivityDiscussionTableViewCell.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 2/4/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WAViewActivityDiscussionTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UILabel *discussionTextLabel;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@end
