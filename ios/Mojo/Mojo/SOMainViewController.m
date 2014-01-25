//
//  SOMainViewController.m
//  Mojo
//
//  Created by Matt Donnelly on 25/01/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import "SOMainViewController.h"
#import "SOPointMeterView.h"
#import "UIColor+Miyo.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>

@interface SOMainViewController ()

@property (nonatomic, strong) SOPointMeterView *pointMeterView;

@end

@implementation SOMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor miyoBlue];

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
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 480.0)];
    topView.backgroundColor = [UIColor colorWithRed:0 green:0.624 blue:0.89 alpha:1.0];
    [self.view addSubview:topView];
    
    UILabel *moodSelectorLabel = [[UILabel alloc] initWithFrame:CGRectMake(55.0, 380.0, 280.0, 50.0)];
    moodSelectorLabel.text = @"How are you feeling today?";
    moodSelectorLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:moodSelectorLabel];
    
//    UISlider *moodSelectorSlider = [[UISlider alloc] initWithFrame:CGRectMake(55.0, 350.0, 200.0, 60.0)];
//    [self.view addSubview:moodSelectorSlider];
    
    UIView *button = [[UIView alloc] initWithFrame:CGRectMake(35.0, 380.0, 250.0, 50.0)];
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.cornerRadius = 5;
    button.layer.borderWidth = 1.0f;
    button.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonTapped:)];
    
    [self.view addGestureRecognizer:tap];
    
    [self.view addSubview:button];


//    moodSelectorSlider.tintColor = [UIColor whiteColor];
//    [self.view addSubview:moodSelectorSlider];
    
//    [moodSelectorSlider addTarget:self action:@selector(moodChanged:) forControlEvents:UIControlEventTouchUpInside];

}

-(void)buttonTapped:(UITapGestureRecognizer *)gr
{
    NSLog(@"hi!");
}



// - (IBAction)moodChanged:(UISlider *)sender {
//     NSNumber *moodValue = [[NSNumber alloc] initWithFloat:(sender.value * 100.0)];
//     PFObject *mood = [PFObject objectWithClassName:@"Mood"];
//     mood[@"value"] = moodValue;

    
//     [mood saveInBackground];
// }


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
