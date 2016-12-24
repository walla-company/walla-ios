//
//  WAGroup.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/23/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WAGroup.h"

@implementation WAGroup

- (id)init {
    self = [super init];
    
    return self;
}

- (id)initWithName:(NSString *)name groupID:(NSString *)groupID color:(UIColor *)groupColor {
    self = [super init];
    
    if (self) {
        self.name = name;
        self.groupID = groupID;
        self.groupColor = groupColor;
    }
    
    return self;
}

@end
