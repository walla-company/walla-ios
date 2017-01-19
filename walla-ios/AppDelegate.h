//
//  AppDelegate.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/13/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Firebase;
@import FirebaseDatabase;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property BOOL userSignedIn;

@property BOOL underMaintenance;

@property BOOL versionTooOld;

@end

