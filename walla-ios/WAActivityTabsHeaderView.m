//
//  WAActivityTabsHeaderView.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/17/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WAActivityTabsHeaderView.h"

@implementation WAActivityTabsHeaderView

- (void)initialize {
    
    self.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self addGestureRecognizer:singleFingerTap];
    
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self];
    
    UIView *tappedView = [self hitTest:location withEvent:nil];
    
    if ([tappedView isKindOfClass:[WAActivityTab class]]) {
        
        BOOL respondToTap = [self.respondToTapArray[tappedView.tag] boolValue];
        
        if (respondToTap) {
            
            [self.delegate activityTabButtonPressed:self.groupID];
        }
    }
}

- (void)setTabs:(NSArray *) tabsArray {
    
    // tabArray
    // index 0: text
    // index 1: fill color
    // index 2: text color
    // index 3: respond to button
    
    [self removeAllSubview];
    
    self.respondToTapArray = [[NSMutableArray alloc] init];
    
    CGFloat xCoordinate = 0;
    
    int tagCount = 0;
    
    for (NSArray *tabInfo in tabsArray) {
        WAActivityTab *activityTab = [[WAActivityTab alloc] initWithFrame:CGRectMake(xCoordinate, 0, 90.0, 50.0) tabText:tabInfo[0] fillColor:tabInfo[1] textColor:tabInfo[2]];
        
        activityTab.tag = tagCount;
        
        [self addSubview:activityTab];
        
        [self sendSubviewToBack:activityTab];
        
        [self.respondToTapArray addObject:tabInfo[3]];
        
        xCoordinate = activityTab.frame.origin.x + 75.0;
        tagCount++;
    }
}

- (void)removeAllSubview {
    
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    
}

- (id)init {
    
    self = [super init];
    
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initialize];
    }
    
    return self;
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self initialize];
    }
    
    return self;
}

@end
