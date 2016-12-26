//
//  WAUserPickerView.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/25/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WAUserTableViewCell.h"

#import "WAUser.h"

typedef void(^animationCompletion)(void);

@protocol WAUserPickerViewDelegate <NSObject>

- (void)doneButtonPressed;

- (void)usersChanges:(NSArray *)users;

@end

@interface WAUserPickerView : UIView <UITableViewDelegate, UITableViewDataSource>

@property UILabel *titleLabel;

@property UIButton *doneButton;

@property CGRect superViewFrame;

@property UIView *primaryView;
@property UIView *secondaryView;

@property UITableView *usersTableView;

@property NSMutableArray *selectedUsers;
@property NSArray *allUsers;

@property id <WAUserPickerViewDelegate> delegate;

- (id)initWithSuperViewFrame:(CGRect)frame title:(NSString *)title selectedUsers:(NSArray *)selectedUsers allUsers:(NSArray *)allUsers;

- (void)animateUp:(CGRect)frame;

- (void)animateDown:(CGRect)frame completion:(animationCompletion) completionBlock;

@end
