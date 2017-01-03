//
//  WAServer.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/28/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import "WAActivity.h"
#import "WAGroup.h"
#import "WAUser.h"

@interface WAServer : NSObject

// Activities

+ (void)getActivityWithID:(NSString *)auid completion:(void (^) (WAActivity *activity))completionBlock;

+ (void)getActivitisFromLastHours:(double)hours completion:(void (^) (NSArray *activities))completionBlock;

// User

+ (void)getUserWithID:(NSString *)uid completion:(void (^) (WAUser *activity))completionBlock;

+ (void)addUser:(NSString *)uid firstName:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email academicLevel:(NSString *)academicLevel major:(NSString *)major graduationYear:(NSInteger)graduationYear completion:(void (^) (BOOL success))completionBlock;

+ (void)updateUserFirstName:(NSString *)firstName completion:(void (^) (BOOL success))completionBlock;

+ (void)updateUserLastName:(NSString *)lastName completion:(void (^) (BOOL success))completionBlock;

+ (void)updateUserEmail:(NSString *)email completion:(void (^) (BOOL success))completionBlock;

+ (void)updateUserAcademicLevel:(NSString *)academicLevel completion:(void (^) (BOOL success))completionBlock;

+ (void)updateUserInterests:(NSArray *)userInterests completion:(void (^) (BOOL success))completionBlock;

+ (void)updateUserMajor:(NSString *)major completion:(void (^) (BOOL success))completionBlock;

+ (void)updateUserGraduationYear:(NSInteger)graduationYear completion:(void (^) (BOOL success))completionBlock;

+ (void)updateUserHometown:(NSString *)hometown completion:(void (^) (BOOL success))completionBlock;

+ (void)updateUserDescription:(NSString *)description completion:(void (^) (BOOL success))completionBlock;

+ (void)updateUserProfileImageURL:(NSString *)profileImageURL completion:(void (^) (BOOL success))completionBlock;

+ (void)updateUserLastLogon;

// Other

+ (BOOL)userAuthenticated;

+ (NSString *)schoolIdentifier;

+ (NSString *)schoolIdentifierFromEmail:(NSString *)email;

+ (void)loadAllowedDomains;

@end
