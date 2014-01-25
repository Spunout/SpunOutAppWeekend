//
//  SOActivityMenuViewController.m
//  Mojo
//
//  Created by Matt Donnelly on 25/01/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import "SOActivityMenuViewController.h"

#import <QuartzCore/QuartzCore.h>

static const CGFloat kMenuHeight = 300.0f;

@interface SOActivityMenuViewController ()

@property (nonatomic, strong) UIToolbar *menuView;
@property (nonatomic, strong) UIView *dimView;
@property (nonatomic, strong) NSLayoutConstraint *menuViewTopConstraint;
@property (nonatomic, strong) NSLayoutConstraint *dimViewHeightConstraint;

@end

@implementation SOActivityMenuViewController

- (instancetype)initWithSuperview:(UIView *)view
{
    self = [super init];

    if (self) {
        self.view.backgroundColor = [UIColor clearColor];

        self.menuView = [[UIToolbar alloc] init];
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

        NSDictionary *metrics = @{@"menuViewHeight": @(kMenuHeight)};

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

        [view addConstraint:[NSLayoutConstraint constraintWithItem:self.dimView
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:view
                                                         attribute:NSLayoutAttributeHeight
                                                        multiplier:1.0
                                                          constant:0]];

        self.dimViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.dimView
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:view
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0
                                                                     constant:0];

        [view addConstraint:self.dimViewHeightConstraint];
    }

    return self;
}

- (void)presentMenu
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.menuViewTopConstraint.constant = -kMenuHeight;
                         self.dimViewHeightConstraint.constant = -kMenuHeight;
                         self.dimView.alpha = 1.0;
                         [self.menuView.superview layoutIfNeeded];
                     }];
}

@end
