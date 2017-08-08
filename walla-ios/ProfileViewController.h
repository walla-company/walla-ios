//
//  ProfileViewController.h
//  walla-ios
//
//  Created by Stas Tomych on 8/8/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WAUser.h"

@interface ProfileViewController : UITableViewController

@property (nonatomic, strong) NSArray <NSString *> *titlesArray;

@property (nonatomic, strong)  WAUser *user;

@property (nonatomic, strong)  UIImage *profileImage;

@property (nonatomic, strong)  NSMutableDictionary *groupsDictionary;

@end
