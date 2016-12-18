//
//  WAShadowView.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/15/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface WAShadowView : UIView

@property CGFloat shadowRadius;

@property CGFloat cornerRadius;

@property UIColor *fillColor;

@property UIColor *shadowColor;

@property UIRectCorner corners;

@end
