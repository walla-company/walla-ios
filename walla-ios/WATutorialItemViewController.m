//
//  WATutorialItemViewController.m
//  walla-ios
//
//  Created by Stas Tomych on 8/16/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import "WATutorialItemViewController.h"

@interface WATutorialItemViewController ()

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *getStartedButton;

@end

@implementation WATutorialItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.image = [UIImage imageNamed: self.imageTitle];
    self.textLabel.text = self.text;
    self.getStartedButton.hidden = !self.isLastItem;
}

- (void)setText:(NSString *)text {
    _text = text;
    self.textLabel.text = text;
}

-(void)setImageTitle:(NSString *)imageTitle {
    _imageTitle = imageTitle;
    self.imageView.image = [UIImage imageNamed:imageTitle];
}

-(void)setIsLastItem:(BOOL)isLastItem {
    _isLastItem = isLastItem;
    self.getStartedButton.hidden = !isLastItem;
}

@end
