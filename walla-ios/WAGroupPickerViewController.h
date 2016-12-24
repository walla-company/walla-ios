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

@interface WAGroupPickerViewController : UIViewController <WAGroupPickerViewDelegate>

@property WAGroupPickerView *groupPicker;

@property id <WAGroupPickerViewControllerDelegate> delegate;

@property NSString *groupPickerTitle;
@property NSArray *selectedGroups;
@property NSArray *allGroups;

- (id)initWithTitle:(NSString *)title selectedGroups:(NSArray *)selectedGroups allGroups:(NSArray *)allGroups;

- (void)setTitle:(NSString *)title;

- (void)setSelectedGroupsArray:(NSArray *)groups;

- (void)setCanSelectMultipleGroups:(BOOL)canSelectMultipleGroups;

@end
