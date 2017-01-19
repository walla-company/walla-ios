//
//  WAGroupPickerViewController.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/23/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WAGroupPickerView.h"

@protocol WAGroupPickerViewControllerDelegate <NSObject>

- (void)groupPickerViewGroupSelected:(NSArray *)groups tag:(NSInteger)tag;

@end

@interface WAGroupPickerViewController : UIViewController <WAGroupPickerViewDelegate, UIGestureRecognizerDelegate>

@property WAGroupPickerView *groupPicker;

@property id <WAGroupPickerViewControllerDelegate> delegate;

@property NSString *groupPickerTitle;
@property NSArray *selectedGroups;
@property NSArray *userGroupIDs;
@property BOOL canSelectMultipleGourps;

- (id)initWithTitle:(NSString *)title selectedGroups:(NSArray *)selectedGroups userGroupIDs:(NSArray *)userGroupIDs canSelectMultipleGourps:(BOOL)canSelectMultipleGourps;

@end
