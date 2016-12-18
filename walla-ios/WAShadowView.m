//
//  WAShadowView.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/15/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WAShadowView.h"

@implementation WAShadowView

- (void)initialize {
    
    self.shadowRadius = 4.0;
    self.cornerRadius = 8.0;
    self.fillColor = [UIColor whiteColor];
    self.shadowColor = [[UIColor alloc] initWithWhite:0.0 alpha:0.1];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.corners = UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerTopRight | UIRectCornerTopLeft;
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

- (void)drawRect:(CGRect)rect {
    
    CGContextRef ref = UIGraphicsGetCurrentContext();
    
    CGRect contentRect = CGRectInset(rect, self.shadowRadius, self.shadowRadius);
    
    UIBezierPath *roundedPath = [UIBezierPath bezierPathWithRoundedRect:contentRect byRoundingCorners:self.corners cornerRadii:CGSizeMake(self.cornerRadius, self.cornerRadius)];
    CGContextSetFillColorWithColor(ref, self.fillColor.CGColor);
    CGContextSetShadowWithColor(ref, CGSizeMake(0.0, 0.0), self.shadowRadius, self.shadowColor.CGColor);
    [roundedPath fill];
}

@end
