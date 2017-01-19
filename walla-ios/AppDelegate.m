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
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [GMSServices provideAPIKey:@"AIzaSyD_fZgsJ97lWBCg-IaljG8xU9fU8ywJ0yk"];
    [GMSPlacesClient provideAPIKey:@"AIzaSyD_fZgsJ97lWBCg-IaljG8xU9fU8ywJ0yk"];
    
    [FIRApp configure];
    
    [WAServer loadAllowedDomains];
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *tabBarController = [mainStoryboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
    NSLog(@"delegate tabbarController: %@", tabBarController);
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarController;
    
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    
    self.userSignedIn = true;
    self.underMaintenance = false;
    self.versionTooOld = false;
    
    [[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth *auth, FIRUser *user) {
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        BOOL inSignup = [[NSUserDefaults standardUserDefaults] boolForKey:@"inSignup"];
        
        if (user && !inSignup) {
            NSLog(@"delegate signed in");
            if (!self.userSignedIn && !self.underMaintenance) {
                
                [WAServer updateUserLastLogon];
                
                UITabBarController *tabBarController = [mainStoryboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
                NSLog(@"delegate tabbarController: %@", tabBarController);
                [UIApplication sharedApplication].keyWindow.rootViewController = tabBarController;
                
                self.window.rootViewController = tabBarController;
            }
            self.userSignedIn = true;
        }
        else if (!self.underMaintenance) {
            NSLog(@"delegate not signed in");
            if (self.userSignedIn) {
                UINavigationController *navigationController = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginSignUpNavigationController"];
                NSLog(@"delegate navigationController: %@", navigationController);
                [UIApplication sharedApplication].keyWindow.rootViewController = navigationController;
                
                self.window.rootViewController = navigationController;
            }
            self.userSignedIn = false;
        }
        
    }];
    
    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    
    [[[ref child:@"app_settings"] child:@"under_maintenance"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        BOOL maintenance = [[snapshot value] boolValue];
        NSLog(@"underMaintenance: %@", (maintenance) ? @"true" : @"false");
        
        if (maintenance && !self.underMaintenance && !self.versionTooOld) {
            UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"UnderMaintenanceViewController"];
            NSLog(@"delegate viewController: %@", viewController);
            [UIApplication sharedApplication].keyWindow.rootViewController = viewController;
            
            self.window.rootViewController = viewController;
        }
        else if (self.versionTooOld) {
            UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"OldVersionViewController"];
            NSLog(@"delegate viewController: %@", viewController);
            [UIApplication sharedApplication].keyWindow.rootViewController = viewController;
            
            self.window.rootViewController = viewController;
        }
        else if ([FIRAuth auth].currentUser && self.userSignedIn && self.underMaintenance) {
            UITabBarController *tabBarController = [mainStoryboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
            NSLog(@"delegate tabbarController: %@", tabBarController);
            [UIApplication sharedApplication].keyWindow.rootViewController = tabBarController;
            
            self.window.rootViewController = tabBarController;
        }
        else if (!self.userSignedIn && self.underMaintenance) {
            UINavigationController *navigationController = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginSignUpNavigationController"];
            NSLog(@"delegate navigationController: %@", navigationController);
            [UIApplication sharedApplication].keyWindow.rootViewController = navigationController;
            
            self.window.rootViewController = navigationController;
        }
        
        self.underMaintenance = maintenance;
    }];
    
    [[[[ref child:@"app_settings"] child:@"min_version"] child:@"ios"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        NSString *verison = [snapshot value];
        NSLog(@"supported verison: %@", verison);
        
        BOOL tooOld = ![self checkMinimumVersion:verison];
        
        NSLog(@"version too old: %@", (tooOld) ? @"true" : @"false");
        
        if (tooOld && !self.versionTooOld) {
            UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"OldVersionViewController"];
            NSLog(@"delegate viewController: %@", viewController);
            [UIApplication sharedApplication].keyWindow.rootViewController = viewController;
            
            self.window.rootViewController = viewController;
        }
        else if (self.underMaintenance) {
            UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"UnderMaintenanceViewController"];
            NSLog(@"delegate viewController: %@", viewController);
            [UIApplication sharedApplication].keyWindow.rootViewController = viewController;
            
            self.window.rootViewController = viewController;
        }
        else if ([FIRAuth auth].currentUser && self.userSignedIn && self.versionTooOld) {
            UITabBarController *tabBarController = [mainStoryboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
            NSLog(@"delegate tabbarController: %@", tabBarController);
            [UIApplication sharedApplication].keyWindow.rootViewController = tabBarController;
            
            self.window.rootViewController = tabBarController;
        }
        else if (!self.userSignedIn && self.versionTooOld) {
            UINavigationController *navigationController = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginSignUpNavigationController"];
            NSLog(@"delegate navigationController: %@", navigationController);
            [UIApplication sharedApplication].keyWindow.rootViewController = navigationController;
            
            self.window.rootViewController = navigationController;
        }
        
        self.versionTooOld = tooOld;
    }];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signupComplete) name:@"SignupComplete" object:nil];
    
    return YES;
}

- (void)signupComplete {
    
    NSLog(@"signupComplete");
    
    if ([FIRAuth auth].currentUser && !self.userSignedIn && !self.underMaintenance) {
        
        [WAServer updateUserLastLogon];
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *tabBarController = [mainStoryboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
        NSLog(@"delegate tabbarController: %@", tabBarController);
        [UIApplication sharedApplication].keyWindow.rootViewController = tabBarController;
        
        self.window.rootViewController = tabBarController;
        
        self.userSignedIn = true;
    }
    
}

- (BOOL)checkMinimumVersion:(NSString *)minimumVersion {
    
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    NSArray *checkArray = [currentVersion componentsSeparatedByString:@"."];
    NSArray *minimumArray = [minimumVersion componentsSeparatedByString:@"."];
    
    int i = 0;
    
    for (NSString *min in minimumArray) {
        if ([[checkArray objectAtIndex:i] integerValue] < [min integerValue]) return false;
        i++;
    }
    
    return true;
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
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
