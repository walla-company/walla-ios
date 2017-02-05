//
//  WAServer.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/28/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "WAActivity.h"
#import "WAGroup.h"
#import "WAUser.h"

@interface WAServer : NSObject

// Activities

+ (void)getActivityWithID:(NSString *)auid completion:(void (^) (WAActivity *activity))completionBlock;

+ (void)getActivitisFromLastHours:(double)hours completion:(void (^) (NSArray *activities))completionBlock;

+ (void)createActivity:(NSString *)title startTime:(NSDate *)startTime endTime:(NSDate *)endTime locationName:(NSString *)locationName locationAddress:(NSString *)locationAddress location:(CLLocation *)location interests:(NSArray *)interests details:(NSString *)details hostGroupID:(NSString *)hostGroupID hostGroupName:(NSString *)hostGroupName hostGroupShortName:(NSString *)hostGroupShortName invitedUsers:(NSArray *)invitedUsers invitedGroups:(NSArray *)invitedGroups activityPublic:(BOOL)activityPublic guestsCanInviteOthers:(BOOL)guestsCanInviteOthers completion:(void (^) (BOOL success))completionBlock;

+ (void)activityInterested:(NSString *)uid activityID:(NSString *)auid completion:(void (^) (BOOL success))completionBlock;

+ (void)activityGoing:(NSString *)uid activityID:(NSString *)auid completion:(void (^) (BOOL success))completionBlock;

+ (void)activityRemoveUser:(NSString *)uid activityID:(NSString *)auid completion:(void (^) (BOOL success))completionBlock;

+ (void)activityInviteUserWithID:(NSString *)uid toActivity:(NSString *)auid completion:(void (^) (BOOL success))completionBlock;

+ (void)activityInviteGroupWithID:(NSString *)guid toActivity:(NSString *)auid completion:(void (^) (BOOL success))completionBlock;

// User

+ (void)addUser:(NSString *)uid firstName:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email academicLevel:(NSString *)academicLevel major:(NSString *)major graduationYear:(NSInteger)graduationYear completion:(void (^) (BOOL success))completionBlock;

+ (void)getUserWithID:(NSString *)uid completion:(void (^) (WAUser *user))completionBlock;

+ (void)getUserBasicInfoWithID:(NSString *)uid completion:(void (^) (NSDictionary *user))completionBlock;

+ (void)getUserFriendsWithID:(NSString *)uid completion:(void (^) (NSArray *friends))completionBlock;

+ (void)getUserInterestsWithID:(NSString *)uid completion:(void (^) (NSArray *interests))completionBlock;

+ (void)getUserGroupsWithID:(NSString *)uid completion:(void (^) (NSArray *groups))completionBlock;

+ (void)getUserCalendarWithID:(NSString *)uid completion:(void (^) (NSArray *groups))completionBlock;

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

+ (void)getUserVerified:(void (^) (BOOL verified))completionBlock;

+ (void)sendVerificationEmail:(void (^) (BOOL success))completionBlock;

// Groups

+ (void)getGroupWithID:(NSString *)guid completion:(void (^) (WAGroup *group))completionBlock;

+ (void)getGroupBasicInfoWithID:(NSString *)guid completion:(void (^) (NSDictionary *group))completionBlock;

+ (void)joinGroup:(NSString *)guid completion:(void (^) (BOOL success))completionBlock;

+ (void)leaveGroup:(NSString *)guid completion:(void (^) (BOOL success))completionBlock;

// Friends

+ (void)requestFriendRequestWithUID:(NSString *)uid completion:(void (^) (BOOL success))completionBlock;

+ (void)acceptFriendRequestWithUID:(NSString *)uid completion:(void (^) (BOOL success))completionBlock;

+ (void)ignoreFriendRequestWithUID:(NSString *)uid completion:(void (^) (BOOL success))completionBlock;

+ (void)getSentFriendRequests:(void (^) (NSArray *sentFriendRequests))completionBlock;

+ (void)getRecievedFriendRequests:(void (^) (NSArray *srecievedFriendRequests))completionBlock;

// Notifications

+ (void)getNotifications:(void (^) (NSArray *notifications))completionBlock;

+ (void)updateNotificationRead:(NSString *)notificationID completion:(void (^) (BOOL success))completionBlock;

+ (void)addNotificationToken:(NSString *)token completion:(void (^) (BOOL success))completionBlock;

+ (void)removeNotificationToken:(NSString *)token completion:(void (^) (BOOL success))completionBlock;

// Discover

+ (void)getSuggestedGroups:(void (^) (NSArray *groups))completionBlock;

+ (void)getSuggestedUsers:(void (^) (NSArray *users))completionBlock;

+ (void)getSearchUserDictionary:(void (^) (NSDictionary *users))completionBlock;

+ (void)getSearchGroupDictionary:(void (^) (NSDictionary *groups))completionBlock;

// Discussions

+ (void)postDiscussion:(NSString *)text activityID:(NSString *)activityID completion:(void (^) (BOOL success))completionBlock;

+ (void)getDiscussions:(NSString *)activityID completion:(void (^) (NSArray *discussions))completionBlock;

// Other

+ (BOOL)userAuthenticated;

+ (NSString *)schoolIdentifier;

+ (NSString *)schoolIdentifierFromEmail:(NSString *)email;

+ (void)loadAllowedDomains;

@end
