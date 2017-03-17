//
//  WAAddGroupTableViewCell.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 3/17/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import "WAAddGroupTableViewCell.h"

@implementation WAAddGroupTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.groupTagView.layer.cornerRadius = 8.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
