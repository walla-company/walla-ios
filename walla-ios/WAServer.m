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
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        if ([self userAuthenticated]) {
            NSLog(@"getActivityWithID: %@", auid);
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setHTTPMethod:@"GET"];
            NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/get_activity?token=%@&school_identifier=%@&auid=%@&uid=%@", API_KEY, [self schoolIdentifier], auid, [FIRAuth auth].currentUser.uid];
            NSLog(@"url: %@", url);
            [request setURL:[NSURL URLWithString:url]];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error getting (%@): %@", url, error);
                }
                else {
                    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    
                    NSLog(@"activity (%@): %@", auid, jsonData);
                    
                    if ([[jsonData allKeys] count] == 0 && completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(nil);
                        });
                    }
                    
                    WAActivity *activity = [[WAActivity alloc] initWithDictionary:jsonData];
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(activity);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(nil);
                });
            }
        }
        
    });
}

+ (void)getActivitisFromLastHours:(double)hours completion:(void (^) (NSArray *activities))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        if ([self userAuthenticated]) {
            NSLog(@"getActivitisSince: %f", hours);
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setHTTPMethod:@"GET"];
            NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/get_activities?token=%@&school_identifier=%@&filter=%f&uid=%@", API_KEY, [self schoolIdentifier], hours, [FIRAuth auth].currentUser.uid];
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
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(formattedActivities);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(nil);
                });
            }
        }
        
    });
}

+ (void)createActivity:(NSString *)title startTime:(NSDate *)startTime endTime:(NSDate *)endTime locationName:(NSString *)locationName locationAddress:(NSString *)locationAddress location:(CLLocation *)location interests:(NSArray *)interests hostGroupID:(NSString *)hostGroupID hostGroupName:(NSString *)hostGroupName hostGroupShortName:(NSString *)hostGroupShortName completion:(void (^) (BOOL success))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        if ([self userAuthenticated]) {
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setHTTPMethod:@"POST"];
            NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/add_activity?token=%@", API_KEY];
            NSLog(@"url: %@", url);
            
            NSDictionary *requestDictionary = @{
                                                @"uid": [FIRAuth auth].currentUser.uid,
                                                @"school_identifier": [self schoolIdentifier],
                                                @"title": title,
                                                @"start_time": [NSNumber numberWithDouble:[startTime timeIntervalSince1970]],
                                                @"end_time": [NSNumber numberWithDouble:[endTime timeIntervalSince1970]],
                                                @"location_name": locationName,
                                                @"location_address": locationAddress,
                                                @"location_lat": [NSNumber numberWithDouble:location.coordinate.latitude],
                                                @"location_long": [NSNumber numberWithDouble:location.coordinate.longitude],
                                                @"interests": interests,
                                                @"host": [FIRAuth auth].currentUser.uid,
                                                @"host_group": hostGroupID,
                                                @"host_group_name": hostGroupName,
                                                @"host_group_short_name": hostGroupShortName
                                                };
            
            NSError *jsonError;
            NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:&jsonError];
            
            if (jsonError) {
                
                NSLog(@"jsonError: %@", jsonError);
                
                if (completionBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        completionBlock(false);
                    });
                }
                
                return;
            }
            
            [request setURL:[NSURL URLWithString:url]];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:requestData];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error creating activity (%@): %@", url, error);
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(false);
                        });
                    }
                }
                else {
                    
                    NSLog(@"Success creating activity");
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(true);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(false);
                });
            }
        }
        
    });
    
}

+ (void)activityInterested:(NSString *)uid activityID:(NSString *)auid completion:(void (^) (BOOL success))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        if ([self userAuthenticated]) {
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setHTTPMethod:@"POST"];
            NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/interested?token=%@", API_KEY];
            NSLog(@"url: %@", url);
            
            
            NSDictionary *requestDictionary = @{
                                                @"uid": uid,
                                                @"school_identifier": [self schoolIdentifier],
                                                @"auid": auid
                                                };
            
            NSError *jsonError;
            NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:&jsonError];
            
            if (jsonError) {
                
                NSLog(@"jsonError: %@", jsonError);
                
                if (completionBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        completionBlock(false);
                    });
                }
                
                return;
            }
            
            [request setURL:[NSURL URLWithString:url]];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:requestData];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error changing interested user (%@): %@", url, error);
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(false);
                        });
                    }
                }
                else {
                    
                    NSLog(@"Success changing interested user");
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(true);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(false);
                });
            }
        }
        
    });
    
}

+ (void)activityGoing:(NSString *)uid activityID:(NSString *)auid completion:(void (^) (BOOL success))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        if ([self userAuthenticated]) {
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setHTTPMethod:@"POST"];
            NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/going?token=%@", API_KEY];
            NSLog(@"url: %@", url);
            
            
            NSDictionary *requestDictionary = @{
                                                @"uid": uid,
                                                @"school_identifier": [self schoolIdentifier],
                                                @"auid": auid
                                                };
            
            NSError *jsonError;
            NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:&jsonError];
            
            if (jsonError) {
                
                NSLog(@"jsonError: %@", jsonError);
                
                if (completionBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        completionBlock(false);
                    });
                }
                
                return;
            }
            
            [request setURL:[NSURL URLWithString:url]];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:requestData];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error changing interested user (%@): %@", url, error);
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(false);
                        });
                    }
                }
                else {
                    
                    NSLog(@"Success changing interested user");
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(true);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(false);
                });
            }
        }
        
    });
    
}

+ (void)activityRemoveUser:(NSString *)uid activityID:(NSString *)auid completion:(void (^) (BOOL success))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        if ([self userAuthenticated]) {
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setHTTPMethod:@"POST"];
            NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/remove_reply?token=%@", API_KEY];
            NSLog(@"url: %@", url);
            
            
            NSDictionary *requestDictionary = @{
                                                @"uid": uid,
                                                @"school_identifier": [self schoolIdentifier],
                                                @"auid": auid
                                                };
            
            NSError *jsonError;
            NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:&jsonError];
            
            if (jsonError) {
                
                NSLog(@"jsonError: %@", jsonError);
                
                if (completionBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        completionBlock(false);
                    });
                }
                
                return;
            }
            
            [request setURL:[NSURL URLWithString:url]];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:requestData];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error removing user (%@): %@", url, error);
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(false);
                        });
                    }
                }
                else {
                    
                    NSLog(@"Success removing user");
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(true);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(false);
                });
            }
        }
        
    });
    
}

+ (void)activityInviteUserWithID:(NSString *)uid toActivity:(NSString *)auid completion:(void (^) (BOOL success))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        if ([self userAuthenticated]) {
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setHTTPMethod:@"POST"];
            NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/invite_user?token=%@", API_KEY];
            NSLog(@"url: %@", url);
            
            
            NSDictionary *requestDictionary = @{
                                                @"uid": uid,
                                                @"school_identifier": [self schoolIdentifier],
                                                @"auid": auid,
                                                @"sender": [FIRAuth auth].currentUser.uid
                                                };
            
            NSError *jsonError;
            NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:&jsonError];
            
            if (jsonError) {
                
                NSLog(@"jsonError: %@", jsonError);
                
                if (completionBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        completionBlock(false);
                    });
                }
                
                return;
            }
            
            [request setURL:[NSURL URLWithString:url]];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:requestData];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error inviting user (%@): %@", url, error);
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(false);
                        });
                    }
                }
                else {
                    
                    NSLog(@"Success inviting user");
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(true);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(false);
                });
            }
        }
        
    });
    
}

+ (void)activityInviteGroupWithID:(NSString *)guid toActivity:(NSString *)auid completion:(void (^) (BOOL success))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        if ([self userAuthenticated]) {
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setHTTPMethod:@"POST"];
            NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/invite_group?token=%@", API_KEY];
            NSLog(@"url: %@", url);
            
            
            NSDictionary *requestDictionary = @{
                                                @"guid": guid,
                                                @"school_identifier": [self schoolIdentifier],
                                                @"auid": auid
                                                };
            
            NSError *jsonError;
            NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:&jsonError];
            
            if (jsonError) {
                
                NSLog(@"jsonError: %@", jsonError);
                
                if (completionBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        completionBlock(false);
                    });
                }
                
                return;
            }
            
            [request setURL:[NSURL URLWithString:url]];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:requestData];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error inviting group (%@): %@", url, error);
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(false);
                        });
                    }
                }
                else {
                    
                    NSLog(@"Success inviting group");
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(true);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(false);
                });
            }
        }
        
    });
    
}

+ (void)deleteActivityWithID:(NSString *)auid completion:(void (^) (BOOL success))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        if ([self userAuthenticated]) {
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setHTTPMethod:@"POST"];
            NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/delete_activity?token=%@", API_KEY];
            NSLog(@"url: %@", url);
            
            
            NSDictionary *requestDictionary = @{
                                                @"auid": auid,
                                                @"school_identifier": [self schoolIdentifier],
                                                @"uid": [FIRAuth auth].currentUser.uid
                                                };
            
            NSError *jsonError;
            NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:&jsonError];
            
            if (jsonError) {
                
                NSLog(@"jsonError: %@", jsonError);
                
                if (completionBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        completionBlock(false);
                    });
                }
                
                return;
            }
            
            [request setURL:[NSURL URLWithString:url]];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:requestData];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error deleting group (%@): %@", url, error);
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(false);
                        });
                    }
                }
                else {
                    
                    NSLog(@"Success deleting activity");
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(true);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(false);
                });
            }
        }
        
    });
    
}

#pragma mark - User

+ (void)addUser:(NSString *)uid firstName:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email academicLevel:(NSString *)academicLevel major:(NSString *)major graduationYear:(NSInteger)graduationYear completion:(void (^) (BOOL success))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
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
                
                if (completionBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        completionBlock(false);
                    });
                }
                
                return;
            }
            
            [request setURL:[NSURL URLWithString:url]];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:requestData];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error adding user (%@): %@", url, error);
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(false);
                        });
                    }
                }
                else {
                    
                    NSLog(@"Success adding user");
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(true);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(false);
                });
            }
        }
        
    });
    
}

+ (void)getUserWithID:(NSString *)uid completion:(void (^) (WAUser *user))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        if ([self userAuthenticated]) {
            NSLog(@"getUserWithID: %@", uid);
            
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
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(user);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(nil);
                });
            }
        }
        
    });
    
}

+ (void)getUserBasicInfoWithID:(NSString *)uid completion:(void (^) (NSDictionary *user))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        if ([self userAuthenticated]) {
            NSLog(@"getUserBasicInfoWithID: %@", uid);
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setHTTPMethod:@"GET"];
            NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/get_user_basic_info?token=%@&school_identifier=%@&uid=%@", API_KEY, [self schoolIdentifier], uid];
            NSLog(@"url: %@", url);
            [request setURL:[NSURL URLWithString:url]];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error getting (%@): %@", url, error);
                }
                else {
                    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    
                    NSLog(@"user basic info: %@", jsonData);
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(jsonData);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(nil);
                });
            }
        }
    });
    
}

+ (void)getUserFriendsWithID:(NSString *)uid completion:(void (^) (NSArray *friends))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        if ([self userAuthenticated]) {
            NSLog(@"getUserFriendsWithID: %@", uid);
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setHTTPMethod:@"GET"];
            NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/get_user_friends?token=%@&school_identifier=%@&uid=%@", API_KEY, [self schoolIdentifier], uid];
            NSLog(@"url: %@", url);
            [request setURL:[NSURL URLWithString:url]];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error getting (%@): %@", url, error);
                }
                else {
                    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    
                    NSLog(@"friends: %@", jsonDictionary);
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock([jsonDictionary allKeys]);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(nil);
                });
            }
        }
        
    });
    
}

+ (void)getUserInterestsWithID:(NSString *)uid completion:(void (^) (NSArray *interests))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        if ([self userAuthenticated]) {
            NSLog(@"getUserInterestsWithID: %@", uid);
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setHTTPMethod:@"GET"];
            NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/get_user_interests?token=%@&school_identifier=%@&uid=%@", API_KEY, [self schoolIdentifier], uid];
            NSLog(@"url: %@", url);
            [request setURL:[NSURL URLWithString:url]];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error getting (%@): %@", url, error);
                }
                else {
                    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    
                    NSLog(@"interests: %@", jsonArray);
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(jsonArray);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(nil);
                });
            }
        }
        
    });
    
}

+ (void)getUserGroupsWithID:(NSString *)uid completion:(void (^) (NSArray *groups))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        if ([self userAuthenticated]) {
            NSLog(@"getUserGroupsWithID: %@", uid);
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setHTTPMethod:@"GET"];
            NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/get_user_groups?token=%@&school_identifier=%@&uid=%@", API_KEY, [self schoolIdentifier], uid];
            NSLog(@"url: %@", url);
            [request setURL:[NSURL URLWithString:url]];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error getting (%@): %@", url, error);
                }
                else {
                    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    
                    NSLog(@"groups: %@", jsonDictionary);
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock([jsonDictionary allKeys]);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(nil);
                });
            }
        }
        
    });
    
}

+ (void)getUserCalendarWithID:(NSString *)uid completion:(void (^) (NSArray *groups))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        if ([self userAuthenticated]) {
            NSLog(@"getUserCalendarWithID: %@", uid);
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setHTTPMethod:@"GET"];
            NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/get_user_calendar?token=%@&school_identifier=%@&uid=%@", API_KEY, [self schoolIdentifier], uid];
            NSLog(@"url: %@", url);
            [request setURL:[NSURL URLWithString:url]];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error getting (%@): %@", url, error);
                }
                else {
                    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    
                    NSLog(@"calendar: %@", jsonDictionary);
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock([jsonDictionary allKeys]);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(nil);
                });
            }
        }
        
    });
    
}

+ (void)updateUserFirstName:(NSString *)firstName completion:(void (^) (BOOL success))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
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
                
                if (completionBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        completionBlock(false);
                    });
                }
                
                return;
            }
            
            [request setURL:[NSURL URLWithString:url]];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:requestData];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error updating first name (%@): %@", url, error);
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(false);
                        });
                    }
                }
                else {
                    
                    NSLog(@"Success updating first name");
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(true);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(false);
                });
            }
        }
        
    });
    
}

+ (void)updateUserLastName:(NSString *)lastName completion:(void (^) (BOOL success))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
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
                
                if (completionBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        completionBlock(false);
                    });
                }
                
                return;
            }
            
            [request setURL:[NSURL URLWithString:url]];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:requestData];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error updating last name (%@): %@", url, error);
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(false);
                        });
                    }
                }
                else {
                    
                    NSLog(@"Success updating last name");
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(true);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(false);
                });
            }
        }
        
    });
    
}

+ (void)updateUserEmail:(NSString *)email completion:(void (^) (BOOL success))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
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
                
                if (completionBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        completionBlock(false);
                    });
                }
                
                return;
            }
            
            [request setURL:[NSURL URLWithString:url]];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:requestData];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error updating email (%@): %@", url, error);
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(false);
                        });
                    }
                }
                else {
                    
                    NSLog(@"Success updating email");
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(true);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(false);
                });
            }
        }
        
    });
    
}

+ (void)updateUserAcademicLevel:(NSString *)academicLevel completion:(void (^) (BOOL success))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
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
                
                if (completionBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        completionBlock(false);
                    });
                }
                
                return;
            }
            
            [request setURL:[NSURL URLWithString:url]];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:requestData];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error updating academic level (%@): %@", url, error);
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(false);
                        });
                    }
                }
                else {
                    
                    NSLog(@"Success updating academic level");
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(true);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(false);
                });
            }
        }
        
    });
    
}

+ (void)updateUserInterests:(NSArray *)userInterests completion:(void (^) (BOOL success))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
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
                
                if (completionBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        completionBlock(false);
                    });
                }
                
                return;
            }
            
            [request setURL:[NSURL URLWithString:url]];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:requestData];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error updating user (%@): %@", url, error);
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(false);
                        });
                    }
                }
                else {
                    
                    NSLog(@"Success updating interests");
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(true);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(false);
                });
            }
        }
        
    });
    
}

+ (void)updateUserMajor:(NSString *)major completion:(void (^) (BOOL success))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
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
                
                if (completionBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        completionBlock(false);
                    });
                }
                
                return;
            }
            
            [request setURL:[NSURL URLWithString:url]];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:requestData];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error updating major (%@): %@", url, error);
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(false);
                        });
                    }
                }
                else {
                    
                    NSLog(@"Success updating major");
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(true);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(false);
                });
            }
        }
        
    });
    
}

+ (void)updateUserGraduationYear:(NSInteger)graduationYear completion:(void (^) (BOOL success))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
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
                
                if (completionBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        completionBlock(false);
                    });
                }
                
                return;
            }
            
            [request setURL:[NSURL URLWithString:url]];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:requestData];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error updating graduation year (%@): %@", url, error);
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(false);
                        });
                    }
                }
                else {
                    
                    NSLog(@"Success updating geaduation year");
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(true);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(false);
                });
            }
        }
        
    });
    
}

+ (void)updateUserHometown:(NSString *)hometown completion:(void (^) (BOOL success))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
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
                
                if (completionBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        completionBlock(false);
                    });
                }
                
                return;
            }
            
            [request setURL:[NSURL URLWithString:url]];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:requestData];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error updating hometown (%@): %@", url, error);
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(false);
                        });
                    }
                }
                else {
                    
                    NSLog(@"Success updating hometown");
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(true);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(false);
                });
            }
        }
        
    });
    
}

+ (void)updateUserDescription:(NSString *)description completion:(void (^) (BOOL success))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
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
                
                if (completionBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        completionBlock(false);
                    });
                }
                
                return;
            }
            
            [request setURL:[NSURL URLWithString:url]];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:requestData];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error updating description (%@): %@", url, error);
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(false);
                        });
                    }
                }
                else {
                    
                    NSLog(@"Success updating description");
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(true);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(false);
                });
            }
        }
        
    });
    
}

+ (void)updateUserProfileImageURL:(NSString *)profileImageURL completion:(void (^) (BOOL success))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
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
                
                if (completionBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        completionBlock(false);
                    });
                }
                
                return;
            }
            
            [request setURL:[NSURL URLWithString:url]];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:requestData];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error updating profile image url (%@): %@", url, error);
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(false);
                        });
                    }
                }
                else {
                    
                    NSLog(@"Success updating profile image url");
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(true);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(false);
                });
            }
        }
        
    });
    
}

+ (void)updateUserLastLogon {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
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
        
    });
    
}

+ (void)getUserVerified:(void (^) (BOOL verified))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        if ([self userAuthenticated]) {
            NSLog(@"getUserVerified");
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setHTTPMethod:@"GET"];
            NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/get_user_verified?token=%@&school_identifier=%@&uid=%@", API_KEY, [self schoolIdentifier], [FIRAuth auth].currentUser.uid];
            NSLog(@"url: %@", url);
            [request setURL:[NSURL URLWithString:url]];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error getting (%@): %@", url, error);
                }
                else {
                    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    
                    NSLog(@"user verified: %@", jsonData);
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock([[jsonData objectForKey:@"verified"] boolValue]);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(false);
                });
            }
        }
    });

    
}

+ (void)sendVerificationEmail:(void (^) (BOOL success))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        if ([self userAuthenticated]) {
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setHTTPMethod:@"POST"];
            NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/request_verification?token=%@", API_KEY];
            NSLog(@"url: %@", url);
            
            
            NSDictionary *requestDictionary = @{
                                                @"uid": [FIRAuth auth].currentUser.uid,
                                                @"school_identifier": [self schoolIdentifier],
                                                @"email": [FIRAuth auth].currentUser.email
                                                };
            
            NSError *jsonError;
            NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:&jsonError];
            
            if (jsonError) {
                
                NSLog(@"jsonError: %@", jsonError);
                
                if (completionBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        completionBlock(false);
                    });
                }
                
                return;
            }
            
            [request setURL:[NSURL URLWithString:url]];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:requestData];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error sending verification email (%@): %@", url, error);
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(false);
                        });
                    }
                }
                else {
                    
                    NSLog(@"Success sending verification email");
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(true);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(false);
                });
            }
        }
        
    });
    
}

+ (void)isUserSuspended:(void (^) (BOOL suspended))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        if ([self userAuthenticated]) {
            NSLog(@"isUserSuspended");
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setHTTPMethod:@"GET"];
            NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/is_user_suspended?token=%@&school_identifier=%@&uid=%@", API_KEY, [self schoolIdentifier], [FIRAuth auth].currentUser.uid];
            NSLog(@"url: %@", url);
            [request setURL:[NSURL URLWithString:url]];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error getting (%@): %@", url, error);
                }
                else {
                    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    
                    NSLog(@"suspended: %@", jsonData);
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock([[jsonData objectForKey:@"suspended"] boolValue]);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(false);
                });
            }
        }
    });
    
}

# pragma mark - Groups

+ (void)getGroups:(void (^) (NSArray *groups))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        if ([self userAuthenticated]) {
            NSLog(@"getGroups");
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setHTTPMethod:@"GET"];
            NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/get_groups?token=%@&school_identifier=%@", API_KEY, [self schoolIdentifier]];
            NSLog(@"url: %@", url);
            [request setURL:[NSURL URLWithString:url]];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error getting (%@): %@", url, error);
                }
                else {
                    NSDictionary *groups = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    
                    NSLog(@"groups: %@", groups);
                    
                    NSMutableArray *formattedGroups = [[NSMutableArray alloc] init];
                    
                    for (NSDictionary *group in [groups allValues]) {
                        [formattedGroups addObject:[[WAGroup alloc] initWithDictionary:group]];
                    }
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(formattedGroups);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(nil);
                });
            }
        }
        
    });
    
}

+ (void)getGroupWithID:(NSString *)guid completion:(void (^) (WAGroup *group))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        if ([self userAuthenticated]) {
            NSLog(@"getGroupWithID: %@", guid);
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setHTTPMethod:@"GET"];
            NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/get_group?token=%@&school_identifier=%@&guid=%@", API_KEY, [self schoolIdentifier], guid];
            NSLog(@"url: %@", url);
            [request setURL:[NSURL URLWithString:url]];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error getting (%@): %@", url, error);
                }
                else {
                    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    
                    NSLog(@"group info: %@", jsonData);
                    
                    WAGroup *group = [[WAGroup alloc] initWithDictionary:jsonData];
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(group);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(nil);
                });
            }
        }
    });
    
}

+ (void)getGroupBasicInfoWithID:(NSString *)guid completion:(void (^) (NSDictionary *group))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        if ([self userAuthenticated]) {
            NSLog(@"getGroupBasicInfoWithID: %@", guid);
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setHTTPMethod:@"GET"];
            NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/get_group_basic_info?token=%@&school_identifier=%@&guid=%@", API_KEY, [self schoolIdentifier], guid];
            NSLog(@"url: %@", url);
            [request setURL:[NSURL URLWithString:url]];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error getting (%@): %@", url, error);
                }
                else {
                    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    
                    NSLog(@"group basic info: %@", jsonData);
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(jsonData);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(nil);
                });
            }
        }
    });
    
}

+ (void)joinGroup:(NSString *)guid completion:(void (^) (BOOL success))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        if ([self userAuthenticated]) {
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setHTTPMethod:@"POST"];
            NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/join_group?token=%@", API_KEY];
            NSLog(@"url: %@", url);
            
            NSDictionary *requestDictionary = @{
                                                @"uid": [FIRAuth auth].currentUser.uid,
                                                @"school_identifier": [self schoolIdentifier],
                                                @"guid": guid
                                                };
            
            NSError *jsonError;
            NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:&jsonError];
            
            if (jsonError) {
                
                NSLog(@"jsonError: %@", jsonError);
                
                if (completionBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        completionBlock(false);
                    });
                }
                
                return;
            }
            
            [request setURL:[NSURL URLWithString:url]];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:requestData];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error joining group (%@): %@", url, error);
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(false);
                        });
                    }
                }
                else {
                    
                    NSLog(@"Success joining group");
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(true);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(false);
                });
            }
        }
        
    });
    
}

+ (void)leaveGroup:(NSString *)guid completion:(void (^) (BOOL success))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        if ([self userAuthenticated]) {
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setHTTPMethod:@"POST"];
            NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/leave_group?token=%@", API_KEY];
            NSLog(@"url: %@", url);
            
            NSDictionary *requestDictionary = @{
                                                @"uid": [FIRAuth auth].currentUser.uid,
                                                @"school_identifier": [self schoolIdentifier],
                                                @"guid": guid
                                                };
            
            NSError *jsonError;
            NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:&jsonError];
            
            if (jsonError) {
                
                NSLog(@"jsonError: %@", jsonError);
                
                if (completionBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        completionBlock(false);
                    });
                }
                
                return;
            }
            
            [request setURL:[NSURL URLWithString:url]];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:requestData];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error leaving group (%@): %@", url, error);
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(false);
                        });
                    }
                }
                else {
                    
                    NSLog(@"Success leaving group");
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(true);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(false);
                });
            }
        }
        
    });
    
}

#pragma mark - Friends

+ (void)requestFriendRequestWithUID:(NSString *)uid completion:(void (^) (BOOL success))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        if ([self userAuthenticated]) {
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setHTTPMethod:@"POST"];
            NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/request_friend?token=%@", API_KEY];
            NSLog(@"url: %@", url);
            
            NSDictionary *requestDictionary = @{
                                                @"uid": [FIRAuth auth].currentUser.uid,
                                                @"school_identifier": [self schoolIdentifier],
                                                @"friend": uid
                                                };
            
            NSError *jsonError;
            NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:&jsonError];
            
            if (jsonError) {
                
                NSLog(@"jsonError: %@", jsonError);
                
                if (completionBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        completionBlock(false);
                    });
                }
                
                return;
            }
            
            [request setURL:[NSURL URLWithString:url]];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:requestData];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error requesting friend (%@): %@", url, error);
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(false);
                        });
                    }
                }
                else {
                    
                    NSLog(@"Success requesting friend");
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(true);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(false);
                });
            }
        }
        
    });

    
}

+ (void)acceptFriendRequestWithUID:(NSString *)uid completion:(void (^) (BOOL success))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        if ([self userAuthenticated]) {
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setHTTPMethod:@"POST"];
            NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/approve_friend?token=%@", API_KEY];
            NSLog(@"url: %@", url);
            
            NSDictionary *requestDictionary = @{
                                                @"uid": [FIRAuth auth].currentUser.uid,
                                                @"school_identifier": [self schoolIdentifier],
                                                @"friend": uid
                                                };
            
            NSError *jsonError;
            NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:&jsonError];
            
            if (jsonError) {
                
                NSLog(@"jsonError: %@", jsonError);
                
                if (completionBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        completionBlock(false);
                    });
                }
                
                return;
            }
            
            [request setURL:[NSURL URLWithString:url]];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:requestData];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error accepting friend (%@): %@", url, error);
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(false);
                        });
                    }
                }
                else {
                    
                    NSLog(@"Success accepting friend");
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(true);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(false);
                });
            }
        }
        
    });
    
}

+ (void)ignoreFriendRequestWithUID:(NSString *)uid completion:(void (^) (BOOL success))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        if ([self userAuthenticated]) {
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setHTTPMethod:@"POST"];
            NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/ignore_friend_request?token=%@", API_KEY];
            NSLog(@"url: %@", url);
            
            NSDictionary *requestDictionary = @{
                                                @"uid": [FIRAuth auth].currentUser.uid,
                                                @"school_identifier": [self schoolIdentifier],
                                                @"friend": uid
                                                };
            
            NSError *jsonError;
            NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:&jsonError];
            
            if (jsonError) {
                
                NSLog(@"jsonError: %@", jsonError);
                
                if (completionBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        completionBlock(false);
                    });
                }
                
                return;
            }
            
            [request setURL:[NSURL URLWithString:url]];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:requestData];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error ignoring friend (%@): %@", url, error);
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(false);
                        });
                    }
                }
                else {
                    
                    NSLog(@"Success ignoring friend");
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(true);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(false);
                });
            }
        }
        
    });
    
}

+ (void)getSentFriendRequests:(void (^) (NSArray *sentFriendRequests))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        if ([self userAuthenticated]) {
            NSLog(@"getSentFriendRequests");
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setHTTPMethod:@"GET"];
            NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/get_sent_friend_requests?token=%@&school_identifier=%@&uid=%@", API_KEY, [self schoolIdentifier], [FIRAuth auth].currentUser.uid];
            NSLog(@"url: %@", url);
            [request setURL:[NSURL URLWithString:url]];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error getting (%@): %@", url, error);
                }
                else {
                    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    
                    NSLog(@"sent requests: %@", jsonDictionary);
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock([jsonDictionary allKeys]);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(nil);
                });
            }
        }
        
    });
    
}

+ (void)getRecievedFriendRequests:(void (^) (NSArray *srecievedFriendRequests))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        if ([self userAuthenticated]) {
            NSLog(@"getSentFriendRequests");
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setHTTPMethod:@"GET"];
            NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/get_received_friend_requests?token=%@&school_identifier=%@&uid=%@", API_KEY, [self schoolIdentifier], [FIRAuth auth].currentUser.uid];
            NSLog(@"url: %@", url);
            [request setURL:[NSURL URLWithString:url]];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error getting (%@): %@", url, error);
                }
                else {
                    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    
                    NSLog(@"recieved requests: %@", jsonDictionary);
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock([jsonDictionary allKeys]);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(nil);
                });
            }
        }
        
    });
    
}

#pragma mark - Notifications

+ (void)getNotifications:(void (^) (NSArray *notifications))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        if ([self userAuthenticated]) {
            NSLog(@"getNotifications");
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setHTTPMethod:@"GET"];
            NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/get_notifications?token=%@&school_identifier=%@&uid=%@", API_KEY, [self schoolIdentifier], [FIRAuth auth].currentUser.uid];
            NSLog(@"url: %@", url);
            [request setURL:[NSURL URLWithString:url]];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error getting (%@): %@", url, error);
                }
                else {
                    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    
                    NSLog(@"notifications: %@", jsonData);
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock([jsonData allValues]);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(nil);
                });
            }
        }
    });

    
}

+ (void)updateNotificationRead:(NSString *)notificationID completion:(void (^) (BOOL success))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        if ([self userAuthenticated]) {
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setHTTPMethod:@"POST"];
            NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/update_notification_read?token=%@", API_KEY];
            NSLog(@"url: %@", url);
            
            NSDictionary *requestDictionary = @{
                                                @"uid": [FIRAuth auth].currentUser.uid,
                                                @"school_identifier": [self schoolIdentifier],
                                                @"notification_id": notificationID,
                                                @"read": [NSNumber numberWithBool:true]
                                                };
            
            NSError *jsonError;
            NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:&jsonError];
            
            if (jsonError) {
                
                NSLog(@"jsonError: %@", jsonError);
                
                if (completionBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        completionBlock(false);
                    });
                }
                
                return;
            }
            
            [request setURL:[NSURL URLWithString:url]];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:requestData];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error updating notification read (%@): %@", url, error);
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(false);
                        });
                    }
                }
                else {
                    
                    NSLog(@"Success updating notification read");
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(true);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(false);
                });
            }
        }
        
    });
    
}

+ (void)addNotificationToken:(NSString *)token completion:(void (^) (BOOL success))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        if ([self userAuthenticated]) {
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setHTTPMethod:@"POST"];
            NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/add_notification_token?token=%@", API_KEY];
            NSLog(@"url: %@", url);
            
            NSDictionary *requestDictionary = @{
                                                @"uid": [FIRAuth auth].currentUser.uid,
                                                @"school_identifier": [self schoolIdentifier],
                                                @"notification_token": token
                                                };
            
            NSError *jsonError;
            NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:&jsonError];
            
            if (jsonError) {
                
                NSLog(@"jsonError: %@", jsonError);
                
                if (completionBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        completionBlock(false);
                    });
                }
                
                return;
            }
            
            [request setURL:[NSURL URLWithString:url]];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:requestData];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error adding token (%@): %@", url, error);
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(false);
                        });
                    }
                }
                else {
                    
                    NSLog(@"Success adding token");
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(true);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(false);
                });
            }
        }
        
    });
    
}

+ (void)removeNotificationToken:(NSString *)token completion:(void (^) (BOOL success))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        if ([self userAuthenticated]) {
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setHTTPMethod:@"POST"];
            NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/remove_notification_token?token=%@", API_KEY];
            NSLog(@"url: %@", url);
            
            NSDictionary *requestDictionary = @{
                                                @"uid": [FIRAuth auth].currentUser.uid,
                                                @"school_identifier": [self schoolIdentifier],
                                                @"notification_token": token
                                                };
            
            NSError *jsonError;
            NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:&jsonError];
            
            if (jsonError) {
                
                NSLog(@"jsonError: %@", jsonError);
                
                if (completionBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        completionBlock(false);
                    });
                }
                
                return;
            }
            
            [request setURL:[NSURL URLWithString:url]];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:requestData];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error removing token (%@): %@", url, error);
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(false);
                        });
                    }
                }
                else {
                    
                    NSLog(@"Success removing token");
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(true);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(false);
                });
            }
        }
        
    });

}

#pragma mark - Discover

+ (void)getSuggestedGroups:(void (^) (NSArray *groups))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        if ([self userAuthenticated]) {
            NSLog(@"getSuggestedGroups");
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setHTTPMethod:@"GET"];
            NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/get_suggested_groups?token=%@&school_identifier=%@", API_KEY, [self schoolIdentifier]];
            NSLog(@"url: %@", url);
            [request setURL:[NSURL URLWithString:url]];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error getting (%@): %@", url, error);
                }
                else {
                    NSArray *groups = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    
                    NSLog(@"groups: %@", groups);
                    
                    NSMutableArray *formattedGroups = [[NSMutableArray alloc] init];
                    
                    for (NSDictionary *group in groups) {
                        [formattedGroups addObject:[[WAGroup alloc] initWithDictionary:group]];
                    }
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(formattedGroups);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(nil);
                });
            }
        }
        
    });
    
}

+ (void)getSuggestedUsers:(void (^) (NSArray *users))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        if ([self userAuthenticated]) {
            NSLog(@"getSuggestedUsers");
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setHTTPMethod:@"GET"];
            NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/get_suggested_users?token=%@&school_identifier=%@", API_KEY, [self schoolIdentifier]];
            NSLog(@"url: %@", url);
            [request setURL:[NSURL URLWithString:url]];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error getting (%@): %@", url, error);
                }
                else {
                    NSArray *users = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    
                    NSLog(@"users: %@", users);
                    
                    NSMutableArray *formattedUsers = [[NSMutableArray alloc] init];
                    
                    for (NSDictionary *user in users) {
                        [formattedUsers addObject:[[WAUser alloc] initWithDictionary:user]];
                    }
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(formattedUsers);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(nil);
                });
            }
        }
        
    });
    
}

+ (void)getSearchUserDictionary:(void (^) (NSDictionary *users))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        if ([self userAuthenticated]) {
            NSLog(@"getSearchUserDictionary");
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setHTTPMethod:@"GET"];
            NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/get_search_users_array?token=%@&school_identifier=%@", API_KEY, [self schoolIdentifier]];
            NSLog(@"url: %@", url);
            [request setURL:[NSURL URLWithString:url]];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error getting (%@): %@", url, error);
                }
                else {
                    NSDictionary *users = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    
                    NSLog(@"users: %@", users);
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(users);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(nil);
                });
            }
        }
        
    });
    
}

+ (void)getSearchGroupDictionary:(void (^) (NSDictionary *groups))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        if ([self userAuthenticated]) {
            NSLog(@"getSearchGroupDictionary");
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setHTTPMethod:@"GET"];
            NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/get_search_groups_array?token=%@&school_identifier=%@", API_KEY, [self schoolIdentifier]];
            NSLog(@"url: %@", url);
            [request setURL:[NSURL URLWithString:url]];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error getting (%@): %@", url, error);
                }
                else {
                    NSDictionary *groups = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    
                    NSLog(@"groups: %@", groups);
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(groups);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(nil);
                });
            }
        }
        
    });
    
}

#pragma mark - Discussions

+ (void)postDiscussion:(NSString *)text activityID:(NSString *)activityID completion:(void (^) (BOOL success))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        if ([self userAuthenticated]) {
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setHTTPMethod:@"POST"];
            NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/post_discussion?token=%@", API_KEY];
            NSLog(@"url: %@", url);
            
            NSDictionary *requestDictionary = @{
                                                @"uid": [FIRAuth auth].currentUser.uid,
                                                @"school_identifier": [self schoolIdentifier],
                                                @"auid": activityID,
                                                @"text": text
                                                };
            
            NSError *jsonError;
            NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:&jsonError];
            
            if (jsonError) {
                
                NSLog(@"jsonError: %@", jsonError);
                
                if (completionBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        completionBlock(false);
                    });
                }
                
                return;
            }
            
            [request setURL:[NSURL URLWithString:url]];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:requestData];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error posting discussion (%@): %@", url, error);
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(false);
                        });
                    }
                }
                else {
                    
                    NSLog(@"Success posting discussion");
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(true);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(false);
                });
            }
        }
        
    });
    
}

+ (void)getDiscussions:(NSString *)activityID completion:(void (^) (NSArray *discussions))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        if ([self userAuthenticated]) {
            NSLog(@"getNotifications");
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setHTTPMethod:@"GET"];
            NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/get_discussions?token=%@&school_identifier=%@&auid=%@", API_KEY, [self schoolIdentifier], activityID];
            NSLog(@"url: %@", url);
            [request setURL:[NSURL URLWithString:url]];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error getting (%@): %@", url, error);
                }
                else {
                    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    
                    NSLog(@"Discussions: %@", jsonData);
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock([jsonData allValues]);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(nil);
                });
            }
        }
    });
    
}

#pragma mark - Flagging

+ (void)flagActivity:(NSString *)activityID completion:(void (^) (BOOL success))completionBlock {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        if ([self userAuthenticated]) {
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setHTTPMethod:@"POST"];
            NSString *url = [NSString stringWithFormat:@"https://walla-server.herokuapp.com/api/flag_activity?token=%@", API_KEY];
            NSLog(@"url: %@", url);
            
            NSDictionary *requestDictionary = @{
                                                @"uid": [FIRAuth auth].currentUser.uid,
                                                @"school_identifier": [self schoolIdentifier],
                                                @"auid": activityID,
                                                };
            
            NSError *jsonError;
            NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:&jsonError];
            
            if (jsonError) {
                
                NSLog(@"jsonError: %@", jsonError);
                
                if (completionBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        completionBlock(false);
                    });
                }
                
                return;
            }
            
            [request setURL:[NSURL URLWithString:url]];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:requestData];
            
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"Error flagging activity (%@): %@", url, error);
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(false);
                        });
                    }
                }
                else {
                    
                    NSLog(@"Success flagging activity");
                    
                    if (completionBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            completionBlock(true);
                        });
                    }
                }
                
            }];
            
            [dataTask resume];
        }
        else {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionBlock(false);
                });
            }
        }
        
    });
    
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
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
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
        
    });
    
}

@end
