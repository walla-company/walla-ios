//
//  WAActivity.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/26/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>

#import "WAGroup.h"
#import "WAUser.h"

@interface WAActivity : NSObject

@property NSString *activityID;

@property NSDate *startTime;
@property NSDate *endTime;

@property NSString *title;
@property NSString *details;

@property BOOL activityPublic;

@property NSArray *interests;

@property NSString *locationName;
@property NSString *locationAddress;
@property CLLocation *location;

@property NSString *host;
@property NSString *hostGroupID;
@property NSString *hostGroupName;
@property NSString *hostGroupShortName;

@property BOOL canOthersInvite;

@property NSDictionary *repliesDictionary;

@property NSMutableArray *interestedUserIDs;
@property NSMutableArray *goingUserIDs;

@property NSInteger numberInterested;
@property NSInteger numberGoing;

@property NSMutableArray *invitedUserIDs;
@property NSMutableArray *invitedGroupIDs;

@property BOOL activityDeleted;

@property BOOL freeFood;

- (id)init;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
