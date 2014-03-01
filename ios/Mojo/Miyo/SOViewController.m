//
//  SOViewController.m
//  Miyo
//
//  Created by James Eggers on 16/02/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SOViewController.h"
#import "SOMainViewController.h"
#import "SOChartViewController.h"
#import "SOBadgesViewController.h"

#import "UIColor+Miyo.h"

@interface SOViewController ()

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (nonatomic, strong) SOMainViewController *mainViewController;
@property (nonatomic, strong) SOChartViewController *chartViewController;
@property (nonatomic, strong) SOBadgesViewController *badgesViewController;

@end

@implementation SOViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor miyoBlue];
    
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    
    self.mainViewController = [[SOMainViewController alloc] init];
    self.chartViewController = [[SOChartViewController alloc] init];
    self.badgesViewController = [[SOBadgesViewController alloc] init];

    [viewControllers addObject:self.mainViewController];

    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
    
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height );
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if (viewController == self.mainViewController) {
        return nil;
    }
    else if (viewController == self.chartViewController) {
        return self.mainViewController;
    }
    else if (viewController == self.badgesViewController) {
        return self.chartViewController;
    }

    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if (viewController == self.mainViewController) {
        return self.chartViewController;
    }
    else if (viewController == self.chartViewController) {
        return self.badgesViewController;
    }
    else if (viewController == self.badgesViewController) {
        return nil;
    }

    return nil;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.viewControllers count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

@end
