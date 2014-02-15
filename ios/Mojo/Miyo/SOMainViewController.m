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

@interface SOMainViewController () <SOActivityMenuViewDelegate>

@property (nonatomic, strong) SOPointMeterView *pointMeterView;

@property (nonatomic, strong) UILabel *moodLabel;

@property (nonatomic, strong) UIView *logView;
@property (nonatomic, strong) UISlider *moodSlider;
@property (nonatomic, strong) UIButton *activityLogButton;

@property (nonatomic, strong) SOActivityMenuViewController *activityMenuViewController;

@end

@implementation SOMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    BOOL canLogActivities;

    NSDate *lastScoreUpdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"last_score_update"];
    if (lastScoreUpdate) {
        NSDate *now = [NSDate date];

        unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
        NSDateComponents *comp1 = [[NSCalendar currentCalendar] components:unitFlags fromDate:lastScoreUpdate];
        NSDateComponents *comp2 = [[NSCalendar currentCalendar] components:unitFlags fromDate:now];

        canLogActivities = [comp1 day] != [comp2 day];
    }
    else {
        canLogActivities = YES;
    }

    self.view.backgroundColor = [UIColor miyoBlue];

    self.pointMeterView = [[SOPointMeterView alloc] init];
    self.pointMeterView.maximumValue = 500;
    self.pointMeterView.minimumValue = 0;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"score"]) {
        self.pointMeterView.currentValue = [[NSUserDefaults standardUserDefaults] integerForKey:@"score"];
    }
    else {
        self.pointMeterView.currentValue = 150;
    }
    self.pointMeterView.translatesAutoresizingMaskIntoConstraints = NO;

    self.logView = [[UIView alloc] init];
    self.logView.translatesAutoresizingMaskIntoConstraints = NO;

    self.logView.hidden = !canLogActivities;

    self.activityLogButton = [[UIButton alloc] init];
    [self.activityLogButton setTitle:@"LOG ACTIVITY" forState:UIControlStateNormal];
    self.activityLogButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.activityLogButton.titleLabel.textColor = [UIColor whiteColor];
    self.activityLogButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.activityLogButton.layer.cornerRadius = 5;
    self.activityLogButton.layer.borderWidth = 2.0f;
    self.activityLogButton.layer.masksToBounds = YES;
    self.activityLogButton.translatesAutoresizingMaskIntoConstraints = NO;

    self.moodLabel = [[UILabel alloc] init];
    if (canLogActivities) {
        self.moodLabel.text = @"HOW ARE YOU FEELING?";
    }
    else {
        self.moodLabel.text = @"COME BACK TOMORROW TO CHECK IN AGAIN";
    }
    self.moodLabel.textColor = [UIColor whiteColor];
    self.moodLabel.textAlignment = NSTextAlignmentCenter;
    self.moodLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    self.moodLabel.numberOfLines = 0;
    self.moodLabel.translatesAutoresizingMaskIntoConstraints = NO;

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
    [self.view addSubview:self.moodLabel];
    [self.view addSubview:self.logView];
    [self.logView addSubview:self.moodSlider];
    [self.logView addSubview:self.activityLogButton];

    self.activityMenuViewController = [[SOActivityMenuViewController alloc] init];
    self.activityMenuViewController.delegate = self;

    NSDictionary *views = @{@"pointMeterView": self.pointMeterView,
                            @"moodLabel": self.moodLabel,
                            @"logView": self.logView,
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

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[moodLabel]-(20)-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[pointMeterView]-(20)-[moodLabel]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[logView]|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[moodLabel]-(10)-[logView]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    [self.logView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[moodSlider]-(20)-|"
                                                                         options:0
                                                                         metrics:metrics
                                                                           views:views]];

    [self.logView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[moodSlider]"
                                                                         options:0
                                                                         metrics:metrics
                                                                           views:views]];

    [self.logView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(60)-[activityLogButton]-(60)-|"
                                                                         options:0
                                                                         metrics:metrics
                                                                           views:views]];

    [self.logView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[moodSlider]-(20)-[activityLogButton(45)]-|"
                                                                         options:0
                                                                         metrics:metrics
                                                                           views:views]];
}

- (void)didSelectActivitesForPoints:(NSInteger)points
{
    self.pointMeterView.currentValue += points;
    [[NSUserDefaults standardUserDefaults] setInteger:self.pointMeterView.currentValue forKey:@"score"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"last_score_update"];

    [[NSUserDefaults standardUserDefaults] synchronize];

    self.moodLabel.text = @"COME BACK TOMORROW TO CHECK IN AGAIN";

    [UIView animateWithDuration:0.3 animations:^{
        self.logView.alpha = 0;
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didTouchActivityLogButton
{
    [self.activityMenuViewController showInView:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
