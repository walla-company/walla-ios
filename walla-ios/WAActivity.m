//
//  WAActivity.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/26/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WAActivity.h"

@implementation WAActivity

- (id)init {
    self = [super init];
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super init];
    
    if (self) {
        
        self.activityDeleted = [[dictionary objectForKey:@"deleted"] boolValue];
        
        self.activityID = dictionary[@"activity_id"];
        
        self.startTime = [NSDate dateWithTimeIntervalSince1970:[dictionary[@"start_time"] doubleValue]];
        self.endTime = [NSDate dateWithTimeIntervalSince1970:[dictionary[@"end_time"] doubleValue]];
        
        self.title = dictionary[@"title"];
        self.details = dictionary[@"details"];
        
        self.activityPublic = [dictionary[@"public"] boolValue];
        
        self.interests = dictionary[@"interests"];
        
        self.locationName = dictionary[@"location"][@"name"];
        self.locationAddress = dictionary[@"location"][@"address"];
        self.location = [[CLLocation alloc] initWithLatitude:[dictionary[@"location"][@"lat"] doubleValue] longitude:[dictionary[@"location"][@"long"] doubleValue]];
        
        self.host = dictionary[@"host"];
        
        self.hostGroupID = dictionary[@"host_group"];
        self.hostGroupName = dictionary[@"host_group_name"];
        self.hostGroupShortName = dictionary[@"host_group_short_name"];
        
        self.canOthersInvite = [dictionary[@"can_others_invite"] boolValue];
        
        self.invitedUserIDs = [[NSMutableArray alloc] init];
        self.invitedGroupIDs = [[NSMutableArray alloc] init];
        
        NSDictionary *invitedUsers = dictionary[@"invited_users"];
        if (invitedUsers) self.invitedUserIDs = [[NSMutableArray alloc] initWithArray:[invitedUsers allKeys]];
        
        NSDictionary *invitedGroups = dictionary[@"invited_groups"];
        if (invitedGroups) self.invitedGroupIDs = [[NSMutableArray alloc] initWithArray:[invitedGroups allKeys]];
        
        self.repliesDictionary = dictionary[@"replies"];
        
        self.freeFood = [dictionary[@"free_food"] boolValue];
        
        [self processReplies];
    }
    
    return self;
    
}

- (void)processReplies {
    
    self.interestedUserIDs = [[NSMutableArray alloc] init];
    self.goingUserIDs = [[NSMutableArray alloc] init];
    
    self.numberInterested = 0;
    self.numberGoing = 0;
    
    for (NSString *uid in [self.repliesDictionary allKeys]) {
        if ([self.repliesDictionary[uid] isEqualToString:@"interested"]) {
            [self.interestedUserIDs addObject:uid];
        }
        else {
            [self.goingUserIDs addObject:uid];
        }
    }
    
    self.numberInterested = [self.interestedUserIDs count];
    self.numberGoing = [self.goingUserIDs count];
}

@end
