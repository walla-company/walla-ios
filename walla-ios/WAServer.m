//
//  WAServer.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/28/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WAServer.h"

@import Firebase;

@implementation WAServer

static NSString *API_KEY = @"3eaf7dFmNF447d";

#pragma mark - Activities

+ (void)getActivityWithID:(NSString *)auid completion:(void (^) (WAActivity *activity))completionBlock {
    
    NSLog(@"getActivityWithID: %@", auid);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/get_activity?token=%@&school_identifier=%@&auid=%@", API_KEY, [self schoolIdentifier], auid];
    NSLog(@"url: %@", url);
    [request setURL:[NSURL URLWithString:url]];
    
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSLog(@"IN HADNLER");
        
        if (error) {
            NSLog(@"Error getting (%@): %@", url, error);
        }
        else {
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
            NSLog(@"activity: %@", jsonData);
            
            WAActivity *activity = [[WAActivity alloc] initWithDictionary:jsonData];
            completionBlock(activity);
        }
        
    }];
    
    [dataTask resume];
}

+ (void)getActivitisFromLastHours:(double)hours completion:(void (^) (NSArray *activities))completionBlock {
    
    NSLog(@"getActivitisSince: %f", hours);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/get_activities?token=%@&school_identifier=%@&filter=%f", API_KEY, [self schoolIdentifier], hours];
    NSLog(@"url: %@", url);
    [request setURL:[NSURL URLWithString:url]];
    
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSLog(@"IN HADNLER");
        
        if (error) {
            NSLog(@"Error getting (%@): %@", url, error);
        }
        else {
            NSArray *activities = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
            NSLog(@"activities: %@", activities);
            
            NSMutableArray *formattedActivities = [[NSMutableArray alloc] init];
            
            for (NSDictionary *activity in activities) {
                [formattedActivities addObject:[[WAActivity alloc] initWithDictionary:activity]];
            }
            
            completionBlock(formattedActivities);
        }
        
    }];
    
    [dataTask resume];
}

#pragma mark - Other

+ (BOOL)userAuthenticated {
    if ([FIRAuth auth].currentUser) return true;
    
    return true;
    //return false;
}

+ (NSString *)schoolIdentifier {
    if ([self userAuthenticated]) {
        NSDictionary *schoolIdentifiersDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"schoolIdentifiersDictionary"];
        
        //NSString *email = [FIRAuth auth].currentUser.email;
        NSString *email = @"jed59@duke.edu";
        
        for (NSString *suffix in [schoolIdentifiersDictionary allKeys]) {
            if ([email hasSuffix:suffix]) return schoolIdentifiersDictionary[suffix];
        }
    }
        
    return @"";
}

+ (void)loadAllowedDomains {
    
    NSLog(@"loadAllowedDomains");
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/domains?token=%@", API_KEY];
    [request setURL:[NSURL URLWithString:url]];
    
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSLog(@"IN HADNLER");
        
        if (error) {
            NSLog(@"Error getting (%@): %@", url, error);
        }
        else {
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
            NSMutableDictionary *schoolIdentifiersDictionary = [[NSMutableDictionary alloc] init];
            
            for (NSString *schoolIdentifier in jsonData.allKeys) {
                [schoolIdentifiersDictionary setObject:schoolIdentifier forKey:jsonData[schoolIdentifier][@"domain"]];
            }
            
            NSLog(@"school identifiers: %@", schoolIdentifiersDictionary);
            
            [[NSUserDefaults standardUserDefaults] setObject:schoolIdentifiersDictionary forKey:@"schoolIdentifiersDictionary"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
    }];
    
    [dataTask resume];
}

@end
