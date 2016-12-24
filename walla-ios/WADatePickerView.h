//
//  WADatePickerView.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/18/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WAShadowView.h"

typedef void(^animationCompletion)(void);

@protocol WADatePickerViewDelegate <NSObject>

- (void)doneButtonPressed;

- (void)dateChanged:(NSDate *)date;

@end

@interface WADatePickerView : UIView

@property UILabel *titleLabel;

@property UIDatePicker *datePicker;

@property UIButton *doneButton;

@property CGRect superViewFrame;

@property UIView *primaryView;
@property UIView *secondaryView;

@property id <WADatePickerViewDelegate> delegate;

- (id)initWithSuperViewFrame:(CGRect)frame title:(NSString *)title date:(NSDate *)date;

- (void)animateUp:(CGRect)frame;

- (void)animateDown:(CGRect)frame completion:(animationCompletion) completionBlock;

- (void)setTitle:(NSString *)title;

- (void)setDate:(NSDate *)date;

@end
