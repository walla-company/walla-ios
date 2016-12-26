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

- (id)initWithName:(NSString *)name shortName:(NSString *)shortName groupID:(NSString *)groupID color:(UIColor *)groupColor {
    self = [super init];
    
    if (self) {
        self.name = name;
        self.shortName = shortName;
        self.groupID = groupID;
        self.groupColor = groupColor;
    }
    
    return self;
}

- (BOOL)isEqual:(WAGroup *)other {
    if (other == self)
        return true;
    if (!other || ![other isKindOfClass:[self class]])
        return false;
    if (self.groupID != other.groupID)
        return false;
    return true;
}

@end
