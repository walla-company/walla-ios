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

@property WAUser *host;
@property NSString *hostGroupID;
@property NSString *hostGroupName;
@property NSString *hostGroupShortName;

@property BOOL canOthersInvite;

@property NSDictionary *repliesDictionary;

@property NSMutableArray *interestedUsers;
@property NSMutableArray *goingUsers;

@property NSInteger numberInterested;
@property NSInteger numberGoing;

- (id)init;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
