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
    
    if ([self userAuthenticated]) {
        NSLog(@"getActivityWithID: %@", auid);
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"GET"];
        NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/get_activity?token=%@&school_identifier=%@&auid=%@", API_KEY, [self schoolIdentifier], auid];
        NSLog(@"url: %@", url);
        [request setURL:[NSURL URLWithString:url]];
        
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
        NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
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
    else {
        completionBlock(nil);
    }
}

+ (void)getActivitisFromLastHours:(double)hours completion:(void (^) (NSArray *activities))completionBlock {
    
    if ([self userAuthenticated]) {
        NSLog(@"getActivitisSince: %f", hours);
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"GET"];
        NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/get_activities?token=%@&school_identifier=%@&filter=%f", API_KEY, [self schoolIdentifier], hours];
        NSLog(@"url: %@", url);
        [request setURL:[NSURL URLWithString:url]];
        
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
        NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
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
    else {
        completionBlock(nil);
    }
}

#pragma mark - User

+ (void)getUserWithID:(NSString *)uid completion:(void (^) (WAUser *activity))completionBlock {
    
    if ([self userAuthenticated]) {
        NSLog(@"getActivityWithID: %@", uid);
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"GET"];
        NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/get_user?token=%@&school_identifier=%@&uid=%@", API_KEY, [self schoolIdentifier], uid];
        NSLog(@"url: %@", url);
        [request setURL:[NSURL URLWithString:url]];
        
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
        NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if (error) {
                NSLog(@"Error getting (%@): %@", url, error);
            }
            else {
                NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                
                NSLog(@"user: %@", jsonData);
                
                WAUser *user = [[WAUser alloc] initWithDictionary:jsonData];
                completionBlock(user);
            }
            
        }];
        
        [dataTask resume];
    }
    else {
        completionBlock(nil);
    }
    
}

+ (void)addUser:(NSString *)uid firstName:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email academicLevel:(NSString *)academicLevel major:(NSString *)major graduationYear:(NSInteger)graduationYear completion:(void (^) (BOOL success))completionBlock {
    
    if ([self userAuthenticated]) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"POST"];
        NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/add_user?token=%@", API_KEY];
        NSLog(@"url: %@", url);
        
        
        NSDictionary *requestDictionary = @{
                                            @"uid": uid,
                                            @"school_identifier": [self schoolIdentifier],
                                            @"first_name": firstName,
                                            @"last_name": lastName,
                                            @"email": email,
                                            @"academic_level": academicLevel,
                                            @"major": major,
                                            @"graduation_year": [NSNumber numberWithInt:(int) graduationYear],
                                            @"hometown": @"",
                                            @"description": @"",
                                            @"profile_image_url": @""
                                            };
        
        NSError *jsonError;
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:&jsonError];
        
        if (jsonError) {
            
            NSLog(@"jsonError: %@", jsonError);
            
            completionBlock(false);
            
            return;
        }
        
        [request setURL:[NSURL URLWithString:url]];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:requestData];
        
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
        NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if (error) {
                NSLog(@"Error adding user (%@): %@", url, error);
                
                completionBlock(false);
            }
            else {
                
                NSLog(@"Success adding user");
                
                completionBlock(true);
            }
            
        }];
        
        [dataTask resume];
    }
    else {
        completionBlock(false);
    }
    
}

+ (void)updateUserFirstName:(NSString *)firstName completion:(void (^) (BOOL success))completionBlock {
    
    if ([self userAuthenticated]) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"POST"];
        NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/update_user_first_name?token=%@", API_KEY];
        NSLog(@"url: %@", url);
        
        
        NSDictionary *requestDictionary = @{
                                            @"uid": [FIRAuth auth].currentUser.uid,
                                            @"school_identifier": [self schoolIdentifier],
                                            @"first_name": firstName
                                            };
        
        NSError *jsonError;
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:&jsonError];
        
        if (jsonError) {
            
            NSLog(@"jsonError: %@", jsonError);
            
            completionBlock(false);
            
            return;
        }
        
        [request setURL:[NSURL URLWithString:url]];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:requestData];
        
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
        NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if (error) {
                NSLog(@"Error updating first name (%@): %@", url, error);
                
                completionBlock(false);
            }
            else {
                
                NSLog(@"Success updating first name");
                
                completionBlock(true);
            }
            
        }];
        
        [dataTask resume];
    }
    else {
        completionBlock(false);
    }
    
}

+ (void)updateUserLastName:(NSString *)lastName completion:(void (^) (BOOL success))completionBlock {
    
    if ([self userAuthenticated]) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"POST"];
        NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/update_user_last_name?token=%@", API_KEY];
        NSLog(@"url: %@", url);
        
        
        NSDictionary *requestDictionary = @{
                                            @"uid": [FIRAuth auth].currentUser.uid,
                                            @"school_identifier": [self schoolIdentifier],
                                            @"last_name": lastName
                                            };
        
        NSError *jsonError;
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:&jsonError];
        
        if (jsonError) {
            
            NSLog(@"jsonError: %@", jsonError);
            
            completionBlock(false);
            
            return;
        }
        
        [request setURL:[NSURL URLWithString:url]];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:requestData];
        
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
        NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if (error) {
                NSLog(@"Error updating last name (%@): %@", url, error);
                
                completionBlock(false);
            }
            else {
                
                NSLog(@"Success updating last name");
                
                completionBlock(true);
            }
            
        }];
        
        [dataTask resume];
    }
    else {
        completionBlock(false);
    }
    
}

+ (void)updateUserEmail:(NSString *)email completion:(void (^) (BOOL success))completionBlock {
    
    if ([self userAuthenticated]) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"POST"];
        NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/update_user_email?token=%@", API_KEY];
        NSLog(@"url: %@", url);
        
        
        NSDictionary *requestDictionary = @{
                                            @"uid": [FIRAuth auth].currentUser.uid,
                                            @"school_identifier": [self schoolIdentifier],
                                            @"email": email
                                            };
        
        NSError *jsonError;
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:&jsonError];
        
        if (jsonError) {
            
            NSLog(@"jsonError: %@", jsonError);
            
            completionBlock(false);
            
            return;
        }
        
        [request setURL:[NSURL URLWithString:url]];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:requestData];
        
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
        NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if (error) {
                NSLog(@"Error updating email (%@): %@", url, error);
                
                completionBlock(false);
            }
            else {
                
                NSLog(@"Success updating email");
                
                completionBlock(true);
            }
            
        }];
        
        [dataTask resume];
    }
    else {
        completionBlock(false);
    }
    
}

+ (void)updateUserAcademicLevel:(NSString *)academicLevel completion:(void (^) (BOOL success))completionBlock {
    
    if ([self userAuthenticated]) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"POST"];
        NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/update_user_academic_level?token=%@", API_KEY];
        NSLog(@"url: %@", url);
        
        
        NSDictionary *requestDictionary = @{
                                            @"uid": [FIRAuth auth].currentUser.uid,
                                            @"school_identifier": [self schoolIdentifier],
                                            @"academic_level": academicLevel
                                            };
        
        NSError *jsonError;
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:&jsonError];
        
        if (jsonError) {
            
            NSLog(@"jsonError: %@", jsonError);
            
            completionBlock(false);
            
            return;
        }
        
        [request setURL:[NSURL URLWithString:url]];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:requestData];
        
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
        NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if (error) {
                NSLog(@"Error updating academic level (%@): %@", url, error);
                
                completionBlock(false);
            }
            else {
                
                NSLog(@"Success updating academic level");
                
                completionBlock(true);
            }
            
        }];
        
        [dataTask resume];
    }
    else {
        completionBlock(false);
    }
    
}

+ (void)updateUserInterests:(NSArray *)userInterests completion:(void (^) (BOOL success))completionBlock {
    
    if ([self userAuthenticated]) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"POST"];
        NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/update_user_interests?token=%@", API_KEY];
        NSLog(@"url: %@", url);
        
        
        NSDictionary *requestDictionary = @{
                                            @"uid": [FIRAuth auth].currentUser.uid,
                                            @"school_identifier": [self schoolIdentifier],
                                            @"interests": userInterests
                                            };
        
        NSError *jsonError;
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:&jsonError];
        
        if (jsonError) {
            
            NSLog(@"jsonError: %@", jsonError);
            
            completionBlock(false);
            
            return;
        }
        
        [request setURL:[NSURL URLWithString:url]];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:requestData];
        
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
        NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if (error) {
                NSLog(@"Error updating user (%@): %@", url, error);
                
                completionBlock(false);
            }
            else {
                
                NSLog(@"Success updating interests");
                
                completionBlock(true);
            }
            
        }];
        
        [dataTask resume];
    }
    else {
        completionBlock(false);
    }
    
}

+ (void)updateUserMajor:(NSString *)major completion:(void (^) (BOOL success))completionBlock {
    
    if ([self userAuthenticated]) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"POST"];
        NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/update_user_major?token=%@", API_KEY];
        NSLog(@"url: %@", url);
        
        
        NSDictionary *requestDictionary = @{
                                            @"uid": [FIRAuth auth].currentUser.uid,
                                            @"school_identifier": [self schoolIdentifier],
                                            @"major": major
                                            };
        
        NSError *jsonError;
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:&jsonError];
        
        if (jsonError) {
            
            NSLog(@"jsonError: %@", jsonError);
            
            completionBlock(false);
            
            return;
        }
        
        [request setURL:[NSURL URLWithString:url]];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:requestData];
        
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
        NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if (error) {
                NSLog(@"Error updating major (%@): %@", url, error);
                
                completionBlock(false);
            }
            else {
                
                NSLog(@"Success updating major");
                
                completionBlock(true);
            }
            
        }];
        
        [dataTask resume];
    }
    else {
        completionBlock(false);
    }
    
}

+ (void)updateUserGraduationYear:(NSInteger)graduationYear completion:(void (^) (BOOL success))completionBlock {
    
    if ([self userAuthenticated]) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"POST"];
        NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/update_user_graduation_year?token=%@", API_KEY];
        NSLog(@"url: %@", url);
        
        
        NSDictionary *requestDictionary = @{
                                            @"uid": [FIRAuth auth].currentUser.uid,
                                            @"school_identifier": [self schoolIdentifier],
                                            @"graduation_year": [NSNumber numberWithInt:(int) graduationYear]
                                            };
        
        NSError *jsonError;
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:&jsonError];
        
        if (jsonError) {
            
            NSLog(@"jsonError: %@", jsonError);
            
            completionBlock(false);
            
            return;
        }
        
        [request setURL:[NSURL URLWithString:url]];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:requestData];
        
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
        NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if (error) {
                NSLog(@"Error updating graduation year (%@): %@", url, error);
                
                completionBlock(false);
            }
            else {
                
                NSLog(@"Success updating geaduation year");
                
                completionBlock(true);
            }
            
        }];
        
        [dataTask resume];
    }
    else {
        completionBlock(false);
    }
    
}

+ (void)updateUserHometown:(NSString *)hometown completion:(void (^) (BOOL success))completionBlock {
    
    if ([self userAuthenticated]) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"POST"];
        NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/update_user_hometown?token=%@", API_KEY];
        NSLog(@"url: %@", url);
        
        
        NSDictionary *requestDictionary = @{
                                            @"uid": [FIRAuth auth].currentUser.uid,
                                            @"school_identifier": [self schoolIdentifier],
                                            @"hometown": hometown
                                            };
        
        NSError *jsonError;
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:&jsonError];
        
        if (jsonError) {
            
            NSLog(@"jsonError: %@", jsonError);
            
            completionBlock(false);
            
            return;
        }
        
        [request setURL:[NSURL URLWithString:url]];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:requestData];
        
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
        NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if (error) {
                NSLog(@"Error updating hometown (%@): %@", url, error);
                
                completionBlock(false);
            }
            else {
                
                NSLog(@"Success updating hometown");
                
                completionBlock(true);
            }
            
        }];
        
        [dataTask resume];
    }
    else {
        completionBlock(false);
    }
    
}

+ (void)updateUserDescription:(NSString *)description completion:(void (^) (BOOL success))completionBlock {
    
    if ([self userAuthenticated]) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"POST"];
        NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/update_user_description?token=%@", API_KEY];
        NSLog(@"url: %@", url);
        
        
        NSDictionary *requestDictionary = @{
                                            @"uid": [FIRAuth auth].currentUser.uid,
                                            @"school_identifier": [self schoolIdentifier],
                                            @"description": description
                                            };
        
        NSError *jsonError;
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:&jsonError];
        
        if (jsonError) {
            
            NSLog(@"jsonError: %@", jsonError);
            
            completionBlock(false);
            
            return;
        }
        
        [request setURL:[NSURL URLWithString:url]];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:requestData];
        
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
        NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if (error) {
                NSLog(@"Error updating description (%@): %@", url, error);
                
                completionBlock(false);
            }
            else {
                
                NSLog(@"Success updating description");
                
                completionBlock(true);
            }
            
        }];
        
        [dataTask resume];
    }
    else {
        completionBlock(false);
    }
    
}

+ (void)updateUserProfileImageURL:(NSString *)profileImageURL completion:(void (^) (BOOL success))completionBlock {
    
    if ([self userAuthenticated]) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"POST"];
        NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/update_user_profile_image_url?token=%@", API_KEY];
        NSLog(@"url: %@", url);
        
        
        NSDictionary *requestDictionary = @{
                                            @"uid": [FIRAuth auth].currentUser.uid,
                                            @"school_identifier": [self schoolIdentifier],
                                            @"profile_image_url": profileImageURL
                                            };
        
        NSError *jsonError;
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:&jsonError];
        
        if (jsonError) {
            
            NSLog(@"jsonError: %@", jsonError);
            
            completionBlock(false);
            
            return;
        }
        
        [request setURL:[NSURL URLWithString:url]];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:requestData];
        
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
        NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if (error) {
                NSLog(@"Error updating profile image url (%@): %@", url, error);
                
                completionBlock(false);
            }
            else {
                
                NSLog(@"Success updating profile image url");
                
                completionBlock(true);
            }
            
        }];
        
        [dataTask resume];
    }
    else {
        completionBlock(false);
    }
}

+ (void)updateUserLastLogon {
    
    if ([self userAuthenticated]) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"POST"];
        NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/update_user_last_logon?token=%@", API_KEY];
        NSLog(@"url: %@", url);
        
        
        NSDictionary *requestDictionary = @{
                                            @"uid": [FIRAuth auth].currentUser.uid,
                                            @"school_identifier": [self schoolIdentifier],
                                            @"last_logon": [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]]
                                            };
        
        NSError *jsonError;
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:&jsonError];
        
        if (jsonError) {
            
            NSLog(@"jsonError: %@", jsonError);
            
            return;
        }
        
        [request setURL:[NSURL URLWithString:url]];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:requestData];
        
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
        NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if (error) {
                NSLog(@"Error updating last logon (%@): %@", url, error);
            }
            else {
                
                NSLog(@"Success updating last logon");
            }
            
        }];
        
        [dataTask resume];
    }
}

#pragma mark - Other

+ (BOOL)userAuthenticated {
    if ([FIRAuth auth].currentUser) return true;
    
    return false;
}

+ (NSString *)schoolIdentifier {
    
    if ([self userAuthenticated]) {
        NSDictionary *schoolIdentifiersDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"schoolIdentifiersDictionary"];
        
        NSString *email = [FIRAuth auth].currentUser.email;
        
        for (NSString *suffix in [schoolIdentifiersDictionary allKeys]) {
            if ([email hasSuffix:suffix]) return schoolIdentifiersDictionary[suffix];
        }
    }
        
    return @"";
}

+ (NSString *)schoolIdentifierFromEmail:(NSString *)email {
    
    NSDictionary *schoolIdentifiersDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"schoolIdentifiersDictionary"];
    
    for (NSString *suffix in [schoolIdentifiersDictionary allKeys]) {
        if ([email hasSuffix:suffix]) return schoolIdentifiersDictionary[suffix];
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
