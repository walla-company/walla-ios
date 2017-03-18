//
//  AppDelegate.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/13/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

@import Firebase;
@import FirebaseDatabase;

@interface AppDelegate : UIResponder <UIApplicationDelegate, FIRMessagingDelegate, UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;

@property NSUInteger currentView;

@property BOOL underMaintenance;
@property BOOL versionTooOld;
@property BOOL userSignedIn;
@property BOOL userSuspended;
@property BOOL userVerified;
@property BOOL introComplete;

@property BOOL firstLogin;

typedef NS_ENUM(NSUInteger, ShapeType) {
    kViewingUnderMaintenance = 0,
    kViewingVersionTooOld = 1,
    kViewingLoginSignup = 2,
    kViewingUserSuspended = 3,
    kViewingUserNotVerified = 4,
    kViewingUserIntroNotComplete = 5,
    kViewingApp = 6,
};

@end

