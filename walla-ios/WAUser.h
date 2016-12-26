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

@property NSString *firstName;
@property NSString *lastName;
@property NSString *userID;

@property NSString *classYear;
@property NSString *major;

@property UIImage *profileImage;

- (id)init;

- (id)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName userID:(NSString *)userID classYear:(NSString *)classYear major:(NSString *)major image:(UIImage *)image;

@end
