//
//  WAActivityTabsHeaderView.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/17/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WAActivityTab.h"

@protocol WAActivityTabDelegate <NSObject>

- (void)activityTabButtonPressed:(NSString *)groupID;

@end

@interface WAActivityTabsHeaderView : UIView

@property NSMutableArray *respondToTapArray;

@property NSString *groupID;

@property id <WAActivityTabDelegate> delegate;

- (void)setTabs:(NSArray *) tabsArray;

@end
