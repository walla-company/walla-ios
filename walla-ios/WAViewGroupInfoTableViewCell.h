//
//  WAViewGroupInfoTableViewCell.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/27/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WAViewGroupInfoTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *groupNameLabel;

@property (strong, nonatomic) IBOutlet UIView *groupTagView;

@property (strong, nonatomic) IBOutlet UILabel *groupTagViewLabel;

@property (strong, nonatomic) IBOutlet UILabel *infoLabel;

@property (strong, nonatomic) IBOutlet UIButton *joinButton;

@property (strong, nonatomic) IBOutlet UIView *joinView;

@end
