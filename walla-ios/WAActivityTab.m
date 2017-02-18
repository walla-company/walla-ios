//
//  WAActivityTab.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/17/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WAActivityTab.h"

@implementation WAActivityTab

- (void)initialize:(NSString *)text fillColor:(UIColor *)fillColor textColor:(UIColor *)textColor {
    
    self.shadowRadius = 4.0;
    self.cornerRadius = 8.0;
    self.fillColor = fillColor;
    self.shadowColor = [[UIColor alloc] initWithWhite:0.0 alpha:0.1];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.corners = UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerTopRight | UIRectCornerTopLeft;
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 8.0, 60.0, 22.0)];
    
    textLabel.minimumScaleFactor = 0.5;
    textLabel.adjustsFontSizeToFitWidth = true;
    textLabel.text = text;
    textLabel.textColor = textColor;
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.minimumScaleFactor = 0.5;
    textLabel.font = [textLabel.font fontWithSize:14.0];
    
    [self addSubview:textLabel];
}

- (id)initWithFrame:(CGRect)frame tabText:(NSString *)text fillColor:(UIColor *)fillColor textColor:(UIColor *)textColor {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initialize:text fillColor:fillColor textColor:textColor];
    }
    
    return self;
    
}

@end
