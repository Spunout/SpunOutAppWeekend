//
//  SOActivityMenuViewController.m
//  Mojo
//
//  Created by Matt Donnelly on 25/01/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import "SOActivityMenuViewController.h"

#import <FXBlurView/FXBlurView.h>
#import <QuartzCore/QuartzCore.h>

@interface SOActivityMenuViewController ()

@property (nonatomic, strong) FXBlurView *menuView;
@property (nonatomic, strong) UIView *dimView;
@property (nonatomic, strong) NSLayoutConstraint *menuViewTopConstraint;

@end

@implementation SOActivityMenuViewController

- (instancetype)initWithSuperview:(UIView *)view
{
    self = [super init];

    if (self) {
        self.view.backgroundColor = [UIColor clearColor];

        self.menuView = [[FXBlurView alloc] init];
        self.menuView.dynamic = YES;
        self.menuView.tintColor = [UIColor whiteColor];
        self.menuView.translatesAutoresizingMaskIntoConstraints = NO;

        self.dimView = [[UIView alloc] init];
        self.dimView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
        self.dimView.alpha = 0.0;
        self.dimView.userInteractionEnabled = NO;
        self.dimView.translatesAutoresizingMaskIntoConstraints = NO;

        [view addSubview:self.dimView];
        [view addSubview:self.menuView];

        NSDictionary *views = @{@"menuView": self.menuView,
                                @"dimView": self.dimView};

        NSDictionary *metrics = @{@"menuViewHeight": @300};

        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[menuView]|"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];

        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[menuView(menuViewHeight)]"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];

        self.menuViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.menuView
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:view
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0
                                                                   constant:0];
        
        [view addConstraint:self.menuViewTopConstraint];

        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[dimView]|"
                                                                                   options:0
                                                                                   metrics:metrics
                                                                                     views:views]];

        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[dimView]|"
                                                                                   options:0
                                                                                   metrics:metrics
                                                                                     views:views]];
    }

    return self;
}

- (void)presentMenu
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.menuViewTopConstraint.constant = -300;
                         self.dimView.alpha = 1.0;
                         [self.menuView.superview layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         self.menuView.dynamic = NO;
                     }];
}

@end
