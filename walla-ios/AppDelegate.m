//
//  AppDelegate.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/13/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "AppDelegate.h"

#import "WAServer.h"

@import GoogleMaps;
@import GooglePlaces;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [GMSServices provideAPIKey:@"AIzaSyD_fZgsJ97lWBCg-IaljG8xU9fU8ywJ0yk"];
    [GMSPlacesClient provideAPIKey:@"AIzaSyD_fZgsJ97lWBCg-IaljG8xU9fU8ywJ0yk"];
    
    [FIRApp configure];
    
    [WAServer loadAllowedDomains];
    
    // Defualt to displaying app
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *tabBarController = [mainStoryboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
    NSLog(@"delegate tabbarController: %@", tabBarController);
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarController;
    
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    
    // Setup default values
    
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"openEditProfile"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.currentView = kViewingApp;
    
    self.underMaintenance = false;
    self.versionTooOld = false;
    self.userSignedIn = true;
    self.userSuspended = false;
    self.userVerified = true;
    self.introComplete = true;
    
    self.firstLogin = true;
    
    [[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth *auth, FIRUser *user) {
        
        if (user) {
            self.userSignedIn = true;
            
            [WAServer updateUserLastLogon];
        }
        else {
            self.userSignedIn = false;
            self.firstLogin = true;
        }
        
        [self displayAppropriateView];
        
        if (user && self.firstLogin) {
            self.firstLogin = false;
            
            FIRDatabaseReference *ref = [[FIRDatabase database] reference];
            
            [[ref child:[NSString stringWithFormat:@"schools/%@/users/%@/suspended", [WAServer schoolIdentifier], [FIRAuth auth].currentUser.uid]] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
                
                if ([snapshot value] != [NSNull null]) self.userSuspended = [[snapshot value] boolValue];
                else self.userSuspended = false;
                NSLog(@"userSuspended: %@", (self.userSuspended) ? @"true" : @"false");
                
                [self displayAppropriateView];
            }];
            
            [[ref child:[NSString stringWithFormat:@"schools/%@/users/%@/verified", [WAServer schoolIdentifier], [FIRAuth auth].currentUser.uid]] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
                
//                if ([snapshot value] != [NSNull null]) self.userVerified = [[snapshot value] boolValue];
//                else self.userVerified = false;
                self.userVerified = true;
                NSLog(@"userVerified: %@", (self.userVerified) ? @"true" : @"false");
                
                [self displayAppropriateView];
            }];
            
            [[ref child:[NSString stringWithFormat:@"schools/%@/users/%@/intro_complete", [WAServer schoolIdentifier], [FIRAuth auth].currentUser.uid]] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
                
                if ([snapshot value] != [NSNull null]) self.introComplete = [[snapshot value] boolValue];
                else self.introComplete = false;
                NSLog(@"introComplete: %@", (self.introComplete) ? @"true" : @"false");
                
                [self displayAppropriateView];
            }];
        }
    }];
    
    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    
    [[ref child:@"app_settings/under_maintenance"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        self.underMaintenance = [[snapshot value] boolValue];
        NSLog(@"underMaintenance: %@", (self.underMaintenance) ? @"true" : @"false");
        
        [self displayAppropriateView];
    }];
    
    [[ref child:@"app_settings/min_version/ios"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        NSString *verison = [snapshot value];
        NSLog(@"supported verison: %@", verison);
        
        self.versionTooOld = ![self checkMinimumVersion:verison];
        
        NSLog(@"version too old: %@", (self.versionTooOld) ? @"true" : @"false");
        
        [self displayAppropriateView];
    }];
     
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signupComplete) name:@"SignupComplete" object:nil];
    
    [self setupNotifications];
    
    return YES;
}

- (void)setupNotifications {
    UNAuthorizationOptions authOptions =
    UNAuthorizationOptionAlert
    | UNAuthorizationOptionSound
    | UNAuthorizationOptionBadge;
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
    }];
    
    // For iOS 10 display notification (sent via APNS)
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    // For iOS 10 data message (sent via FCM)
    [FIRMessaging messaging].remoteMessageDelegate = self;
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    NSString *token = [[FIRInstanceID instanceID] token];
    NSLog(@"Messaging instanceID token: %@", token);
    
    if (token != nil && ![token isEqualToString:@""]) {
        [WAServer addNotificationToken:token completion:nil];
    }
    
}

- (void)signupComplete {
    
    NSLog(@"signupComplete");
    
    [self displayAppropriateView];
}

- (void)displayAppropriateView {
    
    NSLog(@"displayAppropriateView");
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    BOOL inSignup = [[NSUserDefaults standardUserDefaults] boolForKey:@"inSignup"];
    
    NSLog(@"inSignup: %@", (inSignup) ? @"true" : @"false");
    
    if (self.underMaintenance) {                    // Display under maintenance view
        
        NSLog(@"Display under maintenance view");
        
        if (self.currentView != kViewingUnderMaintenance) {
            UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"UnderMaintenanceViewController"];
            NSLog(@"delegate viewController: %@", viewController);
            [UIApplication sharedApplication].keyWindow.rootViewController = viewController;
            
            self.window.rootViewController = viewController;
            
            self.currentView = kViewingUnderMaintenance;
        }
        
    }
    else if (self.versionTooOld) {                  // Display verison too old view
        
        NSLog(@"Display verison too old view");
        
        if (self.currentView != kViewingVersionTooOld) {
            UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"OldVersionViewController"];
            NSLog(@"delegate viewController: %@", viewController);
            [UIApplication sharedApplication].keyWindow.rootViewController = viewController;
            
            self.window.rootViewController = viewController;
            
            self.currentView = kViewingVersionTooOld;
        }
        
    }
    else if (!self.userSignedIn && !inSignup) {     // Display login/signup view
        
        NSLog(@"Display login/signup view");
        
        if (self.currentView != kViewingLoginSignup) {
            
            UINavigationController *navigationController = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginSignUpNavigationController"];
            NSLog(@"delegate navigationController: %@", navigationController);
            [UIApplication sharedApplication].keyWindow.rootViewController = navigationController;
            
            self.window.rootViewController = navigationController;
            
            self.currentView = kViewingLoginSignup;
        }
        
    }
    else if (self.userSuspended && !inSignup) {     // Display user suspended view
        
        NSLog(@"Display user suspended view");
        
        if (self.currentView != kViewingUserSuspended) {
            
            UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"AccountSuspendedViewController"];
            NSLog(@"delegate viewController: %@", viewController);
            [UIApplication sharedApplication].keyWindow.rootViewController = viewController;
            
            self.window.rootViewController = viewController;
            
            self.currentView = kViewingUserSuspended;
        }
        
    }
    else if (!self.userVerified && !inSignup) {     // Display verify email view
        
        NSLog(@"Display verify email view");
        
        if (self.currentView != kViewingUserNotVerified) {
            UITableViewController *tableViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"ConfirmEmailTableViewController"];
            NSLog(@"delegate tableViewController: %@", tableViewController);
            [UIApplication sharedApplication].keyWindow.rootViewController = tableViewController;
            
            self.window.rootViewController = tableViewController;
            
            self.currentView = kViewingUserNotVerified;
        }
        
    }
    else if (!self.introComplete && !inSignup) {    // Display intro
        
        NSLog(@"Display intro");
        
        if (self.currentView != kViewingUserIntroNotComplete) {
            UINavigationController *navigationController = [mainStoryboard instantiateViewControllerWithIdentifier:@"IntroNavigationController"];
            NSLog(@"delegate navigationController: %@", navigationController);
            [UIApplication sharedApplication].keyWindow.rootViewController = navigationController;
            
            self.window.rootViewController = navigationController;
            
            self.currentView = kViewingUserIntroNotComplete;
        }
        
    }
    else {                                          // Display app
        
        NSLog(@"Display app");
        
        if (self.currentView != kViewingApp) {
            
            UITabBarController *tabBarController = [mainStoryboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
            NSLog(@"delegate tabbarController: %@", tabBarController);
            [UIApplication sharedApplication].keyWindow.rootViewController = tabBarController;
            
            self.window.rootViewController = tabBarController;
            
            self.currentView = kViewingApp;
        }
        
    }
    
}

- (BOOL)checkMinimumVersion:(NSString *)minimumVersion {
    
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    NSArray *checkArray = [currentVersion componentsSeparatedByString:@"."];
    NSArray *minimumArray = [minimumVersion componentsSeparatedByString:@"."];
    
    if ([[checkArray objectAtIndex:0] integerValue] > [[minimumArray objectAtIndex:0] integerValue]) return true;
    if ([[checkArray objectAtIndex:0] integerValue] < [[minimumArray objectAtIndex:0] integerValue]) return false;
    
    if ([[checkArray objectAtIndex:1] integerValue] > [[minimumArray objectAtIndex:1] integerValue]) return true;
    if ([[checkArray objectAtIndex:1] integerValue] < [[minimumArray objectAtIndex:1] integerValue]) return false;
    
    if ([[checkArray objectAtIndex:2] integerValue] >= [[minimumArray objectAtIndex:2] integerValue]) return true;
    if ([[checkArray objectAtIndex:2] integerValue] < [[minimumArray objectAtIndex:2] integerValue]) return false;
    
    return false;
}

- (void)applicationReceivedRemoteMessage:(FIRMessagingRemoteMessage *)remoteMessage {
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
