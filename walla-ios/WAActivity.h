//
//  WAActivity.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/26/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import "WAGroup.h"
#import "WAUser.h"

@interface WAActivity : NSObject

@property NSString *activityID;

@property WAUser *host;

@property NSString *title;
@property NSDate *startTime;
@property NSDate *endTime;

@property BOOL activityPublic;

@property NSInteger numberInterested;
@property NSInteger numberGoing;

@property WAGroup *hostGroup;

@property NSArray *interests;

@end
