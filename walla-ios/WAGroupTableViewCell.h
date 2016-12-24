//
//  WAGroupTableViewCell.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/24/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WAGroupTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *groupNameLabel;

@property (strong, nonatomic) IBOutlet UIView *groupTagView;

@property (strong, nonatomic) IBOutlet UILabel *groupTagViewLabel;

@end
