//
//  WAActivityTab.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/17/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WAShadowView.h"

@interface WAActivityTab : WAShadowView

- (id)initWithFrame:(CGRect)frame tabText:(NSString *)text fillColor:(UIColor *)fillColor textColor:(UIColor *)textColor;

@end
