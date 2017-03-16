//
//  WAValues.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/27/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WAValues.h"

@implementation WAValues

#pragma mark

+ (NSString *)dayOfWeekFromDate:(NSDate *)date {
    
    if ([[NSCalendar currentCalendar] isDateInToday:date]) return @"Today";
    if ([[NSCalendar currentCalendar] isDateInTomorrow:date]) return @"Tomorrow";
    
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat: @"EEEE"];
    
    return [dayFormatter stringFromDate:date];
}

#pragma mark - Colors

+ (UIColor *)wallaOrangeColor {
    
    return [[UIColor alloc] initWithRed:255.0/255.0 green:162.0/255.0 blue:71.0/255.0 alpha:1.0];
}

+ (UIColor *)defaultTableViewBackgroundColor {
    
    return [[UIColor alloc] initWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
}

+ (UIColor *)loginSignupTableViewBackgroundColor {
    
    return [[UIColor alloc] initWithRed:255.0/255.0 green:163.0/255.0 blue:74.0/255.0 alpha:1.0];
}

+ (UIColor *)loginSignupCellBackgroundColor {
    
    return [[UIColor alloc] initWithRed:253.0/255.0 green:225.0/255.0 blue:209.0/255.0 alpha:1.0];
}

+ (UIColor *)selectedCellColor {
    
    return [[UIColor alloc] initWithRed:255.0/255.0 green:243.0/255.0 blue:229.0/255.0 alpha:1.0];
}

+ (UIColor *)selectedTextColor {
    
    return [[UIColor alloc] initWithRed:143.0/255.0 green:142.0/255.0 blue:148.0/255.0 alpha:1.0];
}

+ (UIColor *)notSelectedTextColor {

    return [[UIColor alloc] initWithRed:189.0/255.0 green:189.0/255.0 blue:195.0/255.0 alpha:1.0];
}

+ (UIColor *)tabTextColorLightGray {
    
    return [[UIColor alloc] initWithRed:97.0/255.0 green:97.0/255.0 blue:97.0/255.0 alpha:1.0];
}

+ (UIColor *)tabColorOrange {
    
    return [[UIColor alloc] initWithRed:244.0/255.0 green:201.0/255.0 blue:146.0/255.0 alpha:1.0];
}

+ (UIColor *)tabColorOffWhite {
    
    return [[UIColor alloc] initWithRed:251.0/255.0 green:251.0/255.0 blue:251.0/255.0 alpha:1.0];
}

+ (UIColor *)buttonBlueColor {
    
    return [[UIColor alloc] initWithRed:99.0/255.0 green:201.0/255.0 blue:249.0/255.0 alpha:1.0];
}

+ (UIColor *)buttonInterestedColor {
    
    return [[UIColor alloc] initWithRed:255.0/255.0 green:213.0/255.0 blue:75.0/255.0 alpha:1.0];
}

+ (UIColor *)buttonGoingColor {
    
    return [[UIColor alloc] initWithRed:255.0/255.0 green:137.0/255.0 blue:137.0/255.0 alpha:1.0];
}

+ (UIColor *)buttonGrayColor {
    
    return [[UIColor alloc] initWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
}

+ (UIColor *)barHighlightColor {
    
    return [[UIColor alloc] initWithRed:252.0/255.0 green:208.0/255.0 blue:152.0/255.0 alpha:1.0];
}

#pragma  mark - Other

+ (NSArray *)interestsArray {
    
    return @[@[@"Movies", @"InterestIcon_Movies"], @[@"Free Food", @"InterestIcon_FreeFood"], @[@"Academic", @"InterestIcon_Academic"],
             @[@"Study", @"InterestIcon_Study"], @[@"Sports", @"InterestIcon_Sports"], @[@"Rides", @"InterestIcon_Rides"],
             @[@"Exhibition", @"InterestIcon_Exhibition"], @[@"Music", @"InterestIcon_Music"], @[@"Games", @"InterestIcon_Games"],
             @[@"Dance", @"InterestIcon_Dance"], @[@"Socialize", @"InterestIcon_Socialize"], @[@"Volunteer", @"InterestIcon_Volunteer"]];
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
