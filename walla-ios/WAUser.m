//
//  WAUser.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/25/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WAUser.h"

@import Firebase;

@implementation WAUser

- (id)init {
    self = [super init];
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super init];
    
    if (self) {
        
        self.userID = [dictionary objectForKey:@"user_id"];
        
        self.firstName = [dictionary objectForKey:@"first_name"];
        self.lastName = [dictionary objectForKey:@"last_name"];
        
        self.academicLevel = [dictionary objectForKey:@"academic_level"];
        
        self.graduationYear = [NSString stringWithFormat:@"%ld", (long)[[dictionary objectForKey:@"graduation_year"] integerValue]];
        self.major = [dictionary objectForKey:@"major"];
        
        self.profileImageURL = [dictionary objectForKey:@"profile_image_url"];
        
        self.details = [dictionary objectForKey:@"description"];
        self.hometown = [dictionary objectForKey:@"hometown"];
        
        self.friends = [[dictionary objectForKey:@"friends"] allKeys];
        if (self.friends == nil) self.friends = [[NSArray alloc] init];
        
        self.groups = [[dictionary objectForKey:@"groups"] allKeys];
        if (self.groups == nil) self.groups = [[NSArray alloc] init];
        
        self.interests = [dictionary objectForKey:@"interests"];
        if (self.interests == nil) self.interests = [[NSArray alloc] init];
        
        self.activities = [[dictionary objectForKey:@"activities"] allKeys];
        if (self.activities == nil) self.activities = [[NSArray alloc] init];
        
        self.calendar = [[dictionary objectForKey:@"calendar"] allKeys];
        if (self.calendar == nil) self.calendar = [[NSArray alloc] init];
        
        self.pendingFriendRequests = [dictionary objectForKey:@"pending_friend_requests"];
        if (self.pendingFriendRequests == nil) self.pendingFriendRequests = [[NSDictionary alloc] init];
        
    }
    
    return self;
    
}

- (id)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName userID:(NSString *)userID classYear:(NSString *)classYear major:(NSString *)major image:(UIImage *)image {
    self = [super init];
    
    if (self) {
        self.firstName = firstName;
        self.lastName = lastName;
        self.userID = userID;
        
        self.graduationYear = classYear;
        self.major = major;
    }
    
    return self;
}

- (BOOL)isEqual:(WAUser *)other {
    if (other == self)
        return true;
    if (!other || ![other isKindOfClass:[self class]])
        return false;
    if (self.userID != other.userID)
        return false;
    return true;
}

@end
