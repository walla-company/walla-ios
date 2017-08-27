//
//  WAWebViewController.m
//  walla-ios
//
//  Created by Stas Tomych on 8/26/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import "WAWebViewController.h"

@interface WAWebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation WAWebViewController
- (IBAction)backButtonClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion: nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.file isEqualToString:@"terms"]) {
        self.titleLabel.text = @"Terms";
        
    } else {
        self.titleLabel.text = @"Privacy Policy";
    }
    
    NSURL *url = [[NSBundle mainBundle] URLForResource: self.file withExtension:@"pdf" subdirectory:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest: request];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
