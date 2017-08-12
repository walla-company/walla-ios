//
//  WACreateActivityDetailsTableViewCell.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/23/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WACreateActivityDetailsTableViewCell.h"

NSString * const WAMaximumCharactersText = @"%ld/200 chars";

@interface WACreateActivityDetailsTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *maximumCharactersLabel;

@end

@implementation WACreateActivityDetailsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setMaximumCharactersLabelCurrent:(NSInteger)current {
    self.maximumCharactersLabel.text = [NSString stringWithFormat:WAMaximumCharactersText, (long)current];
}


@end
