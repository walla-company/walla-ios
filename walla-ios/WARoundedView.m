//
//  WARoundedView.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/18/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WARoundedView.h"

@implementation WARoundedView

- (void)initialize {
    
    self.layer.cornerRadius = 8.0;
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
