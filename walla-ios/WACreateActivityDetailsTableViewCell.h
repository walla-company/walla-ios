//
//  WACreateActivityDetailsTableViewCell.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/23/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WACreateActivityDetailsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UITextView *titleTextView;

- (void)setMaximumCharactersLabelCurrent:(NSInteger)current;

@end
