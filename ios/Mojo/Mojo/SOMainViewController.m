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

@interface SOMainViewController ()

@property (nonatomic, strong) SOPointMeterView *pointMeterView;
@property (nonatomic, strong) UIButton *activityLogButton;

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

    self.activityLogButton = [[UIButton alloc] init];
    [self.activityLogButton setTitle:@"Log Activity" forState:UIControlStateNormal];
    self.activityLogButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.activityLogButton.titleLabel.textColor = [UIColor whiteColor];
    self.activityLogButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.activityLogButton.layer.cornerRadius = 5;
    self.activityLogButton.layer.borderWidth = 2.0f;
    self.activityLogButton.layer.masksToBounds = YES;
    self.activityLogButton.translatesAutoresizingMaskIntoConstraints = NO;

    [self.activityLogButton addTarget:self
                               action:@selector(didTouchActivityLogButton)
                     forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.pointMeterView];
    [self.view addSubview:self.activityLogButton];

    NSDictionary *views = @{@"pointMeterView": self.pointMeterView,
                            @"activityLogButton": self.activityLogButton};

    NSDictionary *metrics = @{@"pointMeterSize": @250,
                              @"buttonWidth": @150};

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[pointMeterView(pointMeterSize)]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pointMeterView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(80)-[pointMeterView(pointMeterSize)]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[activityLogButton(buttonWidth)]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.activityLogButton
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[pointMeterView]-(50)-[activityLogButton(50)]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
}

-(void)didTouchActivityLogButton
{

}


- (IBAction)moodChanged:(UISlider *)sender
{
    NSNumber *moodValue = [[NSNumber alloc] initWithFloat:(sender.value * 100.0)];
    PFObject *mood = [PFObject objectWithClassName:@"Mood"];
    mood[@"value"] = moodValue;

    
    [mood saveInBackground];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
