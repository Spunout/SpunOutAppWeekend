//
//  SOChartViewController.m
//  Miyo
//
//  Created by James Eggers on 16/02/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import "SOChartViewController.h"

@interface SOChartViewController ()

@end

@implementation SOChartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.frame = CGRectMake(460.0, 160.0, 60.0, 70.0);
    pageControl.numberOfPages = 3;
    pageControl.currentPage = 1;
    [self.view addSubview:pageControl];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
