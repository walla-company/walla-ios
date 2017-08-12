//
//  VDDatePicker.m
//  Picker
//
//  Created by Vdovichenko on 3/19/15.
//  Copyright (c) 2015 CodeIT. All rights reserved.
//

#import "VDDatePicker.h"

@interface VDDatePicker ()
@end

@implementation VDDatePicker
{
    void (^_selectionBlock)(NSDate *selectedDate);
    void (^_cancelBlock)();
    
    UIView *_overlayView;
    NSArray *_dataSource;
}

//--------------------------------------------------------------------------------------------------
#pragma mark - Init views
//--------------------------------------------------------------------------------------------------

+ (instancetype) interfacePicker
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                 owner:self
                                               options:nil];
    return [nib firstObject];
}

+ (UIView *) overlayViewWithFrame:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor clearColor];
    view.userInteractionEnabled = YES;
    view.alpha = 0.0f;
    return view;
}

//--------------------------------------------------------------------------------------------------
#pragma mark - Presentation
//--------------------------------------------------------------------------------------------------

+ (void) showInView:(UIView *)view
 withSelectionBlock:(void (^)(NSDate *selectedDate))selectionBlock
        cancelBlock:(void (^)())cancelBlock
{
    
    VDDatePicker *picker = [VDDatePicker interfacePicker];
    picker->_overlayView = [VDDatePicker overlayViewWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    picker->_selectionBlock = [selectionBlock copy];
    picker->_cancelBlock = [cancelBlock copy];
    CGRect currnentPickerFrame = picker.frame;
    
    //change picker frame
    currnentPickerFrame.size.width = view.frame.size.width;
    currnentPickerFrame.origin.x = 0.0f;
    currnentPickerFrame.origin.y = view.frame.size.height;
    picker.frame = currnentPickerFrame;
    
    //add as subview
    [view addSubview:picker->_overlayView];
    [view addSubview:picker];
    
    
    //animate position
    currnentPickerFrame.origin.y = view.frame.size.height - picker.frame.size.height;\
    [UIView animateWithDuration:0.25f animations:^{
        
        picker.frame = currnentPickerFrame;
        picker->_overlayView.alpha = 0.8f;
        
    }];
}

+ (void) showInView:(UIView *)view
      withMinPicker:(BOOL)isMin
 withSelectionBlock:(void (^)(NSDate *selectedDate))selectionBlock
        cancelBlock:(void (^)())cancelBlock
{
    VDDatePicker *picker = [VDDatePicker interfacePicker];
    picker->_overlayView = [VDDatePicker overlayViewWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    picker->_selectionBlock = [selectionBlock copy];
    picker->_cancelBlock = [cancelBlock copy];
    CGRect currnentPickerFrame = picker.frame;
    if (isMin) {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
        components.year -= 1;
        picker.datePicker.datePickerMode = UIDatePickerModeDate;
        NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:components];
        picker.datePicker.minimumDate = date;
        picker.datePicker.maximumDate = [NSDate date];
        picker.datePicker.date = date;
    }
    else {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
        components.year -= 1;
        NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:components];
        picker.datePicker.minimumDate = date;
        picker.datePicker.maximumDate = [NSDate date];
        picker.datePicker.date = [NSDate date];

    }
    //change picker frame
    currnentPickerFrame.size.width = view.frame.size.width;
    currnentPickerFrame.origin.x = 0.0f;
    currnentPickerFrame.origin.y = view.frame.size.height;
    picker.frame = currnentPickerFrame;
    
    //add as subview
    [view addSubview:picker->_overlayView];
    [view addSubview:picker];
    
    
    //animate position
    currnentPickerFrame.origin.y = view.frame.size.height - picker.frame.size.height;\
    [UIView animateWithDuration:0.25f animations:^{
        
        picker.frame = currnentPickerFrame;
        picker->_overlayView.alpha = 0.8f;
        
    }];
}
- (void) _hide
{
    CGRect currentPickerFrame = self.frame;
    currentPickerFrame.origin.y += self.frame.size.height;
    
    [UIView animateWithDuration:0.25f
                     animations:^{
                         
                         self.frame = currentPickerFrame;
                         _overlayView.alpha = 0.0f;
                         
                     }
                     completion:^(BOOL finished) {
                         
                         [self removeFromSuperview];
                         [_overlayView removeFromSuperview];
                         
                     }];
}

//--------------------------------------------------------------------------------------------------
#pragma mark - Actions
//--------------------------------------------------------------------------------------------------

- (IBAction)_cancelAction:(UIButton *)sender
{
    if (_cancelBlock)
    {
        _cancelBlock();
    }
    
    _cancelBlock = nil;
    _selectionBlock = nil;
    
    [self _hide];
}

- (IBAction)_selectAction:(UIButton *)sender
{
    if (_selectionBlock)
    {
        _selectionBlock([self.datePicker date]);
    }
    
    _cancelBlock = nil;
    _selectionBlock = nil;
    
    [self _hide];
}

@end
