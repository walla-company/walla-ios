//
//  WAUser.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/25/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface WAUser : NSObject

@property NSString *userID;
@property NSString *email;

@property NSString *firstName;
@property NSString *lastName;

@property NSString *academicLevel;

@property NSString *graduationYear;
@property NSString *major;
@property NSString *points;
//@property UIImage *profileImage;
@property NSString *profileImageURL;

@property NSString *details;
@property NSString *hometown;

@property NSArray *friends;
@property NSArray *groups;
@property NSArray *interests;
@property NSMutableArray *activities;

@property NSArray *calendar;

@property NSString *reasonSchool;
@property NSString *wannaMeet;
@property NSString *goal1;
@property NSString *goal2;
@property NSString *goal3;
@property NSString *signatureEmoji;





@property NSDictionary *pendingFriendRequests;

- (id)init;

- (id)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName userID:(NSString *)userID classYear:(NSString *)classYear major:(NSString *)major image:(UIImage *)image;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
