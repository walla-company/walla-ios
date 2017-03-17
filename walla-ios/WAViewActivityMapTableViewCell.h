//
//  WAViewActivityMapTableViewCell.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 3/12/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WARoundedView.h"

@import GoogleMaps;

@interface WAViewActivityMapTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *discussionTextLabel;

@property (strong, nonatomic) IBOutlet GMSMapView *locationMapView;

@property (strong, nonatomic) IBOutlet WARoundedView *discussionView;

@end
