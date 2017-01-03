//
//  WASignupUploadPhotoTableViewCell.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 1/2/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WAShadowView.h"

@interface WASignupUploadPhotoTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet WAShadowView *shadowView;

@property (strong, nonatomic) IBOutlet UIButton *choosePhotoButton;

@property (strong, nonatomic) IBOutlet UIImageView *profilePhotoView;

@end
