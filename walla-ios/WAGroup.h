//
//  WAGroup.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/23/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface WAGroup : NSObject

@property NSString *name;
@property NSString *shortName;
@property NSString *groupID;
@property UIColor *groupColor;

- (id)init;

- (id)initWithName:(NSString *)name shortName:(NSString *)shortName groupID:(NSString *)groupID color:(UIColor *)groupColor;

@end
