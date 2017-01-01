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
        self.activityID = dictionary[@"activity_id"];
        
        self.startTime = [NSDate dateWithTimeIntervalSinceReferenceDate:[dictionary[@"start_time"] doubleValue]];
        self.endTime = [NSDate dateWithTimeIntervalSinceReferenceDate:[dictionary[@"end_time"] doubleValue]];
        
        self.title = dictionary[@"title"];
        self.details = dictionary[@"details"];
        
        self.activityPublic = [dictionary[@"public"] boolValue];
        
        self.interests = dictionary[@"interests"];
        
        self.locationName = dictionary[@"location"][@"name"];
        self.locationAddress = dictionary[@"location"][@"address"];
        self.location = [[CLLocation alloc] initWithLatitude:[dictionary[@"location"][@"lat"] doubleValue] longitude:[dictionary[@"location"][@"long"] doubleValue]];
        
        self.host = [[WAUser alloc] initWithFirstName:@"Ben" lastName:@"Yang" userID:@"1" classYear:@"Freshman" major:@"Computer Science" image:nil];
        
        self.hostGroupID = dictionary[@"host_group"];
        //self.hostGroupName = dictionary[@"host_group_name"];
        //self.hostGroupShortName = dictionary[@"host_group_short_name"];
        self.hostGroupName = @"Group Name";
        self.hostGroupShortName = @"GNAME";
        
        self.canOthersInvite = [dictionary[@"can_others_invite"] boolValue];
        
        self.repliesDictionary = dictionary[@"replies"];
        
        [self processReplies];
    }
    
    return self;
    
}

- (void)processReplies {
    
    self.interestedUsers = [[NSMutableArray alloc] init];
    self.goingUsers = [[NSMutableArray alloc] init];
    
    for (NSString *uid in [self.repliesDictionary allKeys]) {
        if ([self.repliesDictionary[uid] isEqualToString:@"interested"]) self.numberInterested++;
        else self.numberGoing++;
        
        // load user
    }
    
    //@property NSArray *interestedUsers;
    //@property NSArray *goingUsers;
}

@end
