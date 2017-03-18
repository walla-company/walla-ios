//
//  WAIntroViewController.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 3/17/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WAIntroViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *nextButtonView;

- (IBAction)next:(id)sender;

@end
