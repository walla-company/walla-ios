//
//  WALoginSignupButtonTableViewCell.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 1/2/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import "WALoginSignupButtonTableViewCell.h"

#import "WAValues.h"

@implementation WALoginSignupButtonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.buttonView.layer.cornerRadius = 8.0;
    
    [self.shadowView changeFillColor:[WAValues loginSignupCellBackgroundColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
