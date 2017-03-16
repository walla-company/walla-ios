//
//  WAViewActivityTextTableViewCell.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 3/12/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WAViewActivityTextTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *discussionTextLabel;

@end
