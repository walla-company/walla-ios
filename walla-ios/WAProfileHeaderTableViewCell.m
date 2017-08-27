//
//  WAProfileHeaderTableViewCell.m
//  walla-ios
//
//  Created by Stas Tomych on 8/21/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import "WAProfileHeaderTableViewCell.h"

@implementation WAProfileHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.userImageView.layer.borderColor = [UIColor colorWithRed:255/255.0 green:162./255.0 blue:71./255.0 alpha:1.0].CGColor;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
