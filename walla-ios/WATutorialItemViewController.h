//
//  WATutorialItemViewController.h
//  walla-ios
//
//  Created by Sergiy Kostrykin on 8/16/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WAItemPageViewController.h"

@interface WATutorialItemViewController : WAItemPageViewController

@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) NSString *imageTitle;

@property (nonatomic) BOOL isLastItem;

@end
