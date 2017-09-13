//
//  UITableView+Walla.m
//  walla-ios
//
//  Created by Stas Tomych on 9/13/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import "UITableView+Walla.h"

@implementation UITableView (Walla)

- (void)setUpFadedBackgroundView {
    //UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"tutorial_background"]];
    //self.backgroundColor = background;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tutorial_background"]];
    imageView.frame = self.bounds;
    self.backgroundView = imageView;
}

@end
