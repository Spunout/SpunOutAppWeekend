//
//  SOMainViewController.m
//  Mojo
//
//  Created by Matt Donnelly on 25/01/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import "SOMainViewController.h"

@interface SOMainViewController ()

@end

@implementation SOMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 300.0, 340.0, 180.0)];
    footerView.backgroundColor = [UIColor colorWithRed:0.235 green: 0.773 blue:0.0 alpha:1.0];
    [self.view addSubview:footerView];
    
    UILabel *moodSelectorLabel = [[UILabel alloc] initWithFrame:CGRectMake(55.0, 300.0, 280.0, 50.0)];
    moodSelectorLabel.text = @"How are you feeling today?";
    moodSelectorLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:moodSelectorLabel];
    
    UISlider *moodSelectorSlider = [[UISlider alloc] initWithFrame:CGRectMake(55.0, 350.0, 200.0, 60.0)];
    [self.view addSubview:moodSelectorSlider];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
