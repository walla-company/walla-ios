//
//  VDDatePicker.h
//  Picker
//
//  Created by Vdovichenko on 3/19/15.
//  Copyright (c) 2015 CodeIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VDDatePicker : UIView

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;


+ (void) showInView:(UIView *)view
         withSelectionBlock:(void (^)(NSDate *selectedDate))selectionBlock
                cancelBlock:(void (^)())cancelBlock;

+ (void) showInView:(UIView *)view
      withMinPicker:(BOOL)isMin
 withSelectionBlock:(void (^)(NSDate *selectedDate))selectionBlock
        cancelBlock:(void (^)())cancelBlock;

@end
