//
//  WAValues.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/27/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WAValues.h"

@implementation WAValues

#pragma mark - Colors

+ (UIColor *)defaultTableViewBackgroundColor {
    
    return [[UIColor alloc] initWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
}

+ (UIColor *)selectedCellColor {
    
    return [[UIColor alloc] initWithRed:255.0/255.0 green:243.0/255.0 blue:229.0/255.0 alpha:1.0];
}

#pragma  mark - Other

+ (NSArray *)interestsArray {
    
    return @[@[@"Movies", @"InterestIcon_Movies"], @[@"Free Food", @"InterestIcon_FreeFood"], @[@"Academic", @"InterestIcon_Academic"],
             @[@"Study", @"InterestIcon_Study"], @[@"Sports", @"InterestIcon_Sports"], @[@"Rides", @"InterestIcon_Rides"],
             @[@"Exhibition", @"InterestIcon_Exhibition"], @[@"Music", @"InterestIcon_Music"], @[@"Games", @"InterestIcon_Games"],
             @[@"Dance", @"InterestIcon_Dance"], @[@"Socialize", @"InterestIcon_Socialize"], @[@"Volunteer", @"InterestIcon_Volunteer"]];
}

@end
