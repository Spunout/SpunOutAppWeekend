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

@interface SOViewController ()


@property (strong, nonatomic) UIPageViewController *pageViewController;


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
	// Do any additional setup after loading the view.
    
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    
    SOMainViewController *mainViewController = [[SOMainViewController alloc] init];
    //SOChartViewController *chartViewController = [[SOChartViewController alloc] init];
    
    [viewControllers addObject: mainViewController];
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];

    
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

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
   int pageIndex = ((SOMainViewController*) viewController).pageIndex;
    
    

    return [self.viewControllers objectAtIndex:pageIndex];
    
    
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    
    int pageIndex = [(SOChartViewController *)viewController pageIndex];
    
    
    if ([self.viewControllers count] == (pageIndex + 1))
    {
        return [self.viewControllers objectAtIndex:pageIndex];
    } else {
        if (pageIndex == 1)
        {
            [self.viewControllers addObject: [[SOChartViewController alloc] init]];
            return [self.viewControllers objectAtIndex:pageIndex];
        }
    }

    NSLog([NSString stringWithFormat: @"%d", (int)pageIndex]);
    return [[SOChartViewController alloc] init];
    
    
    
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
