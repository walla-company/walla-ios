//
//  WASignupPopupTableViewCell.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 1/2/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import "WASignupPopupTableViewCell.h"

#import "WAValues.h"

@implementation WASignupPopupTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.shadowView changeFillColor:[WAValues loginSignupCellBackgroundColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
