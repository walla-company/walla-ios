//
//  WAViewActivityViewController.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/26/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WAViewActivityInfoTableViewCell.h"
#import "WAViewActivityLocationTableViewCell.h"
#import "WAViewActivityAttendeesTableViewCell.h"
#import "WAViewActivityButtonsTableViewCell.h"
#import "WAViewActivityHostTableViewCell.h"
#import "WAViewActivityDetailsTableViewCell.h"

#import "WAActivityTabsHeaderView.h"

@interface WAViewActivityViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, WAActivityTabDelegate>

@property (strong, nonatomic) IBOutlet UITableView *viewActivityTableView;

@property UIColor *tabColorLightGray;
@property UIColor *tabColorOrange;
@property UIColor *tabColorOffwhite;

@end
