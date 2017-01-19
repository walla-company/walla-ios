//
//  WAValues.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/27/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface WAValues : NSObject

// Colors

+ (UIColor *)wallaOrangeColor;

+ (UIColor *)defaultTableViewBackgroundColor;
+ (UIColor *)loginSignupTableViewBackgroundColor;

+ (UIColor *)loginSignupCellBackgroundColor;

+ (UIColor *)selectedCellColor;

+ (UIColor *)selectedTextColor;
+ (UIColor *)notSelectedTextColor;

+ (UIColor *)tabTextColorLightGray;
+ (UIColor *)tabColorOrange;
+ (UIColor *)tabColorOffWhite;

+ (UIColor *)buttonBlueColor;
+ (UIColor *)buttonInterestedColor;
+ (UIColor *)buttonGoingColor;
+ (UIColor *)buttonGrayColor;

// Others

+ (NSArray *)interestsArray;

+ (UIColor *)colorFromHexString:(NSString *)hexString;

@end
