//
//  LogInIndroductionViewController.m
//  walla-ios
//
//  Created by Stas Tomych on 8/13/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import "LogInIndroductionViewController.h"
#import "WAWebViewController.h"

@interface LogInIndroductionViewController ()

@property (weak, nonatomic) IBOutlet UIButton *logInButton;

@property (weak, nonatomic) IBOutlet UILabel *termsLabel;
@property (weak, nonatomic) IBOutlet UILabel *privacyLabel;

@end

@implementation LogInIndroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.logInButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.logInButton.layer.borderWidth = 2.0f;
    
    NSMutableAttributedString *terms = [self.termsLabel.attributedText mutableCopy];
    [terms addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, terms.length)];
    self.termsLabel.attributedText = terms;
        
    NSMutableAttributedString *privacy = [self.privacyLabel.attributedText mutableCopy];
    [privacy addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, privacy.length)];
    self.privacyLabel.attributedText = privacy;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showTerms"]) {
        WAWebViewController *controller = (WAWebViewController *)segue.destinationViewController;
        controller.file = @"terms";
    }
}

@end
