//
//  SOActivityButton.m
//  Mojo
//
//  Created by Matt Donnelly on 26/01/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import "SOActivityButton.h"

#import "UIColor+Miyo.h"

#import <QuartzCore/QuartzCore.h>

@interface SOActivityButton ()

@property (nonatomic, strong) UIImageView *tickImageView;
@property (nonatomic, assign, getter = isSelected) BOOL selected;

@end

@implementation SOActivityButton

- (id)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image
{
    self = [super init];
    if (self) {
        self.titleLabel.text = [title uppercaseString];
        self.imageView.image = image;
    }

    return self;
}

- (void)commonInit
{
    self.backgroundColor = [UIColor miyoLightGrey];
    self.layer.cornerRadius = 7.0;

    self.selected = NO;

    self.imageView = [[UIImageView alloc] init];
    self.imageView.alpha = 0.6f;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;

    self.tickImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tick"]];
    self.tickImageView.alpha = 0.0;
    self.tickImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.tickImageView.translatesAutoresizingMaskIntoConstraints = NO;

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor colorWithWhite:0 alpha:0.6f];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:8.0f];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;

    [self addSubview:self.imageView];
    [self addSubview:self.tickImageView];
    [self addSubview:self.titleLabel];

    NSDictionary *views = @{@"imageView": self.imageView,
                            @"tickImageView": self.tickImageView,
                            @"titleLabel": self.titleLabel};

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[imageView]-(10)-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(5)-[imageView]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.imageView
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1.0
                                                      constant:0]];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(2)-[tickImageView(12)]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(2)-[tickImageView(12)]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0]];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleLabel]-(10)-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];

    [self addTarget:self action:@selector(handleTap) forControlEvents:UIControlEventTouchDown];
}

- (void)handleTap
{
    if (self.isSelected) {
        [UIView animateWithDuration:0.1
                         animations:^{
                             self.backgroundColor = [UIColor miyoLightGrey];
                             self.tickImageView.alpha = 0.0;
                         }];
    }
    else {
        [UIView animateWithDuration:0.1
                         animations:^{
                             self.backgroundColor = [UIColor miyoLightBlue];
                             self.tickImageView.alpha = 1.0;
                         }];
    }

    self.selected = !self.selected;
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(60, 60);
}

@end
