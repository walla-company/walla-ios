//
//  WAEditProfileTableViewCell.h
//  walla-ios
//
//  Created by Stas Tomych on 8/21/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WAEditProfileTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *charsLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;

@end
