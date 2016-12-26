//
//  WAUser.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/25/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WAUser.h"

@implementation WAUser

- (id)init {
    self = [super init];
    
    return self;
}

- (id)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName userID:(NSString *)userID classYear:(NSString *)classYear major:(NSString *)major image:(UIImage *)image {
    self = [super init];
    
    if (self) {
        self.firstName = firstName;
        self.lastName = lastName;
        self.userID = userID;
        
        self.classYear = classYear;
        self.major = major;
        
        self.profileImage = (image == nil) ? [UIImage imageNamed:@"BlankCircle"] : image;
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
