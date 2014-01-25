//
//  SOMainViewController.m
//  Mojo
//
//  Created by Matt Donnelly on 25/01/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import "SOMainViewController.h"
#import "SOPointMeterView.h"

@interface SOMainViewController ()

@property (nonatomic, strong) SOPointMeterView *pointMeterView;

@end

@implementation SOMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blueColor];

    self.pointMeterView = [[SOPointMeterView alloc] init];
    self.pointMeterView.label.text = @"10";
    self.pointMeterView.progress = 0.75;
    self.pointMeterView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:self.pointMeterView];

    NSDictionary *views = @{@"pointMeterView": self.pointMeterView};

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[pointMeterView(250)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pointMeterView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(100)-[pointMeterView(250)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
