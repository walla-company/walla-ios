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

// Other

+ (BOOL)userAuthenticated;

+ (NSString *)schoolIdentifier;

+ (void)loadAllowedDomains;

@end
