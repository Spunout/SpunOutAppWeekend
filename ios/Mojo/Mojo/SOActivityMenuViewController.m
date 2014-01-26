//
//  SOActivityMenuViewController.m
//  Mojo
//
//  Created by Matt Donnelly on 25/01/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import "SOActivityMenuViewController.h"

#import <QuartzCore/QuartzCore.h>

static const CGFloat kMenuHeight = 350.0f;

@interface SOActivityMenuViewController ()

@property (nonatomic, strong) UIButton *dimView;

@property (nonatomic, strong) UIToolbar *menuView;
@property (nonatomic, strong) NSLayoutConstraint *menuViewTopConstraint;
@property (nonatomic, strong) NSLayoutConstraint *dimViewHeightConstraint;

@property (nonatomic, strong) UIImageView *dragImageView;

@end

@implementation SOActivityMenuViewController

- (instancetype)init
{
    self = [super init];

    if (self) {
        self.view.backgroundColor = [UIColor clearColor];

        self.dimView = [[UIButton alloc] init];
        self.dimView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
        self.dimView.alpha = 0.0;
        self.dimView.translatesAutoresizingMaskIntoConstraints = NO;

        [self.dimView addTarget:self action:@selector(dismissMenu) forControlEvents:UIControlEventTouchUpInside];

        self.menuView = [[UIToolbar alloc] init];
        self.menuView.userInteractionEnabled = YES;
        self.menuView.translatesAutoresizingMaskIntoConstraints = NO;

        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(handlePanGesture:)];

        [self.menuView addGestureRecognizer:panGestureRecognizer];

        self.dragImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"drag-tab"]];
        self.dragImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.dragImageView.translatesAutoresizingMaskIntoConstraints = NO;

        [self.view addSubview:self.dimView];
        [self.view addSubview:self.menuView];
        [self.menuView addSubview:self.dragImageView];

        NSDictionary *views = @{@"menuView": self.menuView,
                                @"dimView": self.dimView,
                                @"dragImageView": self.dragImageView};


        NSDictionary *metrics = @{@"menuViewHeight": @(kMenuHeight)};

        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[dimView]|"
                                                                          options:0
                                                                          metrics:metrics
                                                                            views:views]];

        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.dimView
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeHeight
                                                             multiplier:1.0
                                                               constant:0]];

        self.dimViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.dimView
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0
                                                                     constant:0];

        [self.view addConstraint:self.dimViewHeightConstraint];

        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[menuView]|"
                                                                          options:0
                                                                          metrics:metrics
                                                                            views:views]];

        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[menuView(menuViewHeight)]"
                                                                          options:0
                                                                          metrics:metrics
                                                                            views:views]];

        self.menuViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.menuView
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0
                                                                   constant:0];

        [self.view addConstraint:self.menuViewTopConstraint];

        [self.menuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[dragImageView(57)]"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:views]];

        [self.menuView addConstraint:[NSLayoutConstraint constraintWithItem:self.dragImageView
                                                                  attribute:NSLayoutAttributeCenterX
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.menuView
                                                                  attribute:NSLayoutAttributeCenterX
                                                                 multiplier:1.0
                                                                   constant:0]];

        [self.menuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(10)-[dragImageView(10)]"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:views]];
    }

    return self;
}

- (void)showInView:(UIView *)view;
{
    [view addSubview:self.view];

    [self.view addSubview:self.dimView];
    [self.view addSubview:self.menuView];

    [self.view layoutIfNeeded];

    [UIView animateWithDuration:0.3
                     animations:^{
                         self.menuViewTopConstraint.constant -= kMenuHeight;
                         self.dimViewHeightConstraint.constant -= kMenuHeight;
                         self.dimView.alpha = 1.0;
                         [self.view layoutIfNeeded];
                     }];
}

- (void)dismissMenu
{
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.menuViewTopConstraint.constant += kMenuHeight;
                         self.dimViewHeightConstraint.constant += kMenuHeight;
                         self.dimView.alpha = 0.0;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         [self.view removeFromSuperview];
                     }];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self dismissMenu];
    }
}

@end
