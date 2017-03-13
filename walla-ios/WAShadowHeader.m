//
//  WAShadowHeader.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 3/12/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import "WAShadowHeader.h"

@implementation WAShadowHeader

- (void)initialize {
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.layer.shadowOffset = CGSizeMake(0, 3);
    
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowOpacity = 0.25;
    self.layer.shadowRadius = 1.0;
}

- (id)init {
    
    self = [super init];
    
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initialize];
    }
    
    return self;
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self initialize];
    }
    
    return self;
}

@end
