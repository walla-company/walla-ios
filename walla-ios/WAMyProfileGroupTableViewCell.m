//
//  WAMyProfileGroupTableViewCell.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 3/16/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import "WAMyProfileGroupTableViewCell.h"

@implementation WAMyProfileGroupTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.groupTagView.layer.cornerRadius = 8.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
