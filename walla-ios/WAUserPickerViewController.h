//
//  WAUserPickerViewController.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/25/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WAUserPickerView.h"

@protocol WAUserPickerViewControllerDelegate <NSObject>

- (void)userPickerViewUserSelected:(NSArray *)users tag:(NSInteger)tag;

@end

@interface WAUserPickerViewController : UIViewController <WAUserPickerViewDelegate, UIGestureRecognizerDelegate>

@property WAUserPickerView *userPicker;

@property id <WAUserPickerViewControllerDelegate> delegate;

@property NSString *userPickerTitle;
@property NSArray *selectedUsers;
@property NSArray *allUsers;

- (id)initWithTitle:(NSString *)title selectedUsers:(NSArray *)selectedUsers allUsers:(NSArray *)allUsers;

@end
