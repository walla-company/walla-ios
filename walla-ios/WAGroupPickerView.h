//
//  WAGroupPickerView.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/23/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WAGroupTableViewCell.h"

typedef void(^animationCompletion)(void);

@protocol WAGroupPickerViewDelegate <NSObject>

- (void)doneButtonPressed;

- (void)groupsChanged:(NSArray *)groups;

@end

@interface WAGroupPickerView : UIView <UITableViewDelegate, UITableViewDataSource>

@property UILabel *titleLabel;

@property UIButton *doneButton;

@property CGRect superViewFrame;

@property UIView *primaryView;
@property UIView *secondaryView;

@property UITableView *groupsTableView;

@property BOOL canSelectMultipleGroups;

@property NSMutableArray *selectedGroups;
@property NSArray *userGroupIDs;

@property NSMutableDictionary *groupsDictionary;

@property id <WAGroupPickerViewDelegate> delegate;

- (id)initWithSuperViewFrame:(CGRect)frame title:(NSString *)title selectedGroups:(NSArray *)selectedGroups userGroupIDs:(NSArray *)userGroupIDs canSelectMultipleGroups:(BOOL)canSelectMultipleGroups;

- (void)animateUp:(CGRect)frame;

- (void)animateDown:(CGRect)frame completion:(animationCompletion) completionBlock;

@end
