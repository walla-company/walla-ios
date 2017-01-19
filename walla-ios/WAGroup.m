//
//  WAGroup.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/23/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WAGroup.h"

#import "WAValues.h"

@implementation WAGroup

- (id)init {
    self = [super init];
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super init];
    
    if (self) {
        
        self.name = dictionary[@"name"];
        self.shortName = dictionary[@"short_name"];
        self.groupID = dictionary[@"group_id"];
        self.groupColor = [WAValues colorFromHexString: dictionary[@"color"]];
        self.details = dictionary[@"details"];
        
        self.activities = [[NSMutableArray alloc] init];
        self.members = [[NSMutableArray alloc] init];
        
        NSDictionary *activitiesDictionary = dictionary[@"activities"];
        
        if (activitiesDictionary) {
            for (NSString *key in [activitiesDictionary allKeys]) {
                [self.activities addObject:key];
            }
        }
        
        NSDictionary *membersDictionary = dictionary[@"members"];
        
        if (membersDictionary) {
            for (NSString *key in [membersDictionary allKeys]) {
                [self.members addObject:key];
            }
        }
        
    }
    
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
