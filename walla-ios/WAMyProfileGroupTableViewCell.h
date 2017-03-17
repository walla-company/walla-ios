//
//  WAMyProfileGroupTableViewCell.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 3/16/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WAMyProfileGroupTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *groupNameLabel;

@property (strong, nonatomic) IBOutlet UIView *groupTagView;

@property (strong, nonatomic) IBOutlet UILabel *groupTagViewLabel;

@end
