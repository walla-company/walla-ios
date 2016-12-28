//
//  WAViewUserGroupTableViewCell.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/27/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WAViewUserGroupTableViewCell.h"

@implementation WAViewUserGroupTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.groupTagView.layer.cornerRadius = 8.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
