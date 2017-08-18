//
//  WATutorialViewController.m
//  walla-ios
//
//  Created by Sergiy Kostrykin on 8/16/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import "WATutorialViewController.h"
#import "WATutorialItemViewController.h"
#import "LogInIndroductionViewController.h"

@interface WATutorialViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@property (nonatomic, strong) UIPageViewController *pageViewController;
    
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation WATutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewControllers];
    [self setupPageControl];
}

- (void)setupViewControllers {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Introduction" bundle:nil];
    self.pageViewController = [storyboard instantiateViewControllerWithIdentifier:@"PageController"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    [self.pageViewController setViewControllers: @[[self introViewController]]
                             direction:UIPageViewControllerNavigationDirectionForward
                              animated:NO
                            completion:nil];
    [self addChildViewController: self.pageViewController];
    [self.view addSubview: self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    [self.view bringSubviewToFront:self.pageControl];
}
- (LogInIndroductionViewController *) introViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Introduction" bundle:nil];
    LogInIndroductionViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"LogInIndroductionViewController"];
    return controller;

}

- (UIViewController *)itemControllerForIndex:(NSUInteger)itemIndex {
    NSString *imageTitle;
    NSString *title;
    switch (itemIndex) {
        case 0:
            return [self introViewController];
            break;
        case 1:
            imageTitle = @"tutorial_1";
            title = @"Welcome to Walla!\nMake the most of your college life by getting in the habit of seeking meaningful friendships.";
            break;
        case 2:
            imageTitle = @"tutorial_2";
            title = @"Walla is an open platform you can post to whenever you have a brilliant hangout idea, and someone will take you up on the invite.";
            break;
        case 3:
            imageTitle = @"tutorial_3";
            title = @"No matter who you are or what you want to do, you belong here.";
            break;
        default:
            return nil;
            break;
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Introduction" bundle:nil];
    WATutorialItemViewController *pageItemController = [storyboard instantiateViewControllerWithIdentifier:@"WATutorialItemViewController"];
    pageItemController.index = itemIndex;
    pageItemController.imageTitle = imageTitle;
    pageItemController.text = title;
    pageItemController.isLastItem = itemIndex == 3;
    return pageItemController;
}


- (void)setupPageControl {
    self.pageControl.numberOfPages = 4;
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    self.pageControl.backgroundColor = [UIColor clearColor];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    WAItemPageViewController *controller = (WAItemPageViewController *)viewController;
    return [self itemControllerForIndex:controller.index - 1];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    WAItemPageViewController *controller = (WAItemPageViewController *)viewController;
    return [self itemControllerForIndex:controller.index + 1];
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    WAItemPageViewController *controller = (WAItemPageViewController *)pendingViewControllers[0];
    NSInteger index = controller.index;
    self.pageControl.currentPage = index;
    self.pageControl.pageIndicatorTintColor = index == 0 ? [UIColor whiteColor] : [UIColor grayColor];    
}



@end
