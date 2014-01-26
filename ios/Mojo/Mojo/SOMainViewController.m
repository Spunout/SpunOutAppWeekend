//
//  SOMainViewController.m
//  Mojo
//
//  Created by Matt Donnelly on 25/01/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>

#import "SOMainViewController.h"
#import "SOPointMeterView.h"
#import "SOActivityMenuViewController.h"

#import "UIColor+Miyo.h"

@interface SOMainViewController ()

@property (nonatomic, strong) SOPointMeterView *pointMeterView;
@property (nonatomic, strong) UISlider *moodSlider;
@property (nonatomic, strong) UIButton *activityLogButton;

@property (nonatomic, strong) SOActivityMenuViewController *activityMenuViewController;

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

    UILabel *moodLabel = [[UILabel alloc] init];
    moodLabel.text = @"HOW ARE YOU FEELING?";
    moodLabel.textColor = [UIColor whiteColor];
    moodLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    moodLabel.translatesAutoresizingMaskIntoConstraints = NO;

    self.moodSlider = [[UISlider alloc] init];
    self.moodSlider.minimumTrackTintColor = [UIColor whiteColor];
    self.moodSlider.maximumTrackTintColor = [UIColor miyoLightBlue];
    self.moodSlider.minimumValueImage = [UIImage imageNamed:@"smiley-sad"];
    self.moodSlider.maximumValueImage = [UIImage imageNamed:@"smiley-happy"];
    self.moodSlider.translatesAutoresizingMaskIntoConstraints = NO;

    [self.activityLogButton addTarget:self
                               action:@selector(didTouchActivityLogButton)
                     forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.pointMeterView];
    [self.view addSubview:moodLabel];
    [self.view addSubview:self.moodSlider];
    [self.view addSubview:self.activityLogButton];

    self.activityMenuViewController = [[SOActivityMenuViewController alloc] init];

    NSDictionary *views = @{@"pointMeterView": self.pointMeterView,
                            @"moodLabel": moodLabel,
                            @"moodSlider": self.moodSlider,
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

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(50)-[pointMeterView(pointMeterSize)]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:moodLabel
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[pointMeterView]-(20)-[moodLabel]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[moodSlider]-(20)-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[moodLabel]-(10)-[moodSlider]"
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

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[moodSlider]-(20)-[activityLogButton(50)]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didTouchActivityLogButton
{
    [self.activityMenuViewController showInView:self.view];
}

- (IBAction)moodChanged:(UISlider *)sender
{
    NSNumber *moodValue = [[NSNumber alloc] initWithFloat:(sender.value * 100.0)];
    PFObject *mood = [PFObject objectWithClassName:@"Mood"];
    mood[@"value"] = moodValue;
<<<<<<< HEAD

// - (IBAction)moodChanged:(UISlider *)sender {
//     NSNumber *moodValue = [[NSNumber alloc] initWithFloat:(sender.value * 100.0)];
//     PFObject *mood = [PFObject objectWithClassName:@"Mood"];
//     mood[@"value"] = moodValue;

=======
>>>>>>> eb50edd1d52dee83beb8e0da99e986fbf77e818e
    
//     [mood saveInBackground];
// }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
