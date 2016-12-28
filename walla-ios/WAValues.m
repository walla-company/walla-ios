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
    
    return @[@[@"Movies"], @[@"Free Food"], @[@"Academic"],
             @[@"Study"], @[@"Sports"], @[@"Rides"],
             @[@"Exhibition"], @[@"Music"], @[@"Games"],
             @[@"Dance"], @[@"Socialize"], @[@"Volunteer"]];
}

@end
