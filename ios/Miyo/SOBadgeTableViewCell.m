//
//  SOBadgeTableViewCell.m
//  Miyo
//
//  Created by Matt Donnelly on 16/02/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import "SOBadgeTableViewCell.h"
#import "UIColor+Miyo.h"

@interface SOBadgeTableViewCell ()

@property (nonatomic, strong) UIImageView *bronzeImageView;
@property (nonatomic, strong) UIImageView *silverImageView;
@property (nonatomic, strong) UIImageView *goldImageView;

@end

@implementation SOBadgeTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor miyoBlue];

        self.badgeLabel = [[UILabel alloc] init];
        self.badgeLabel.numberOfLines = 0;
        self.badgeLabel.textColor = [UIColor whiteColor];
        self.badgeLabel.font = [UIFont boldSystemFontOfSize:15.0];
        self.badgeLabel.translatesAutoresizingMaskIntoConstraints = NO;

        self.bronzeImageView = [[UIImageView alloc] init];
        self.bronzeImageView.translatesAutoresizingMaskIntoConstraints = NO;

        self.silverImageView = [[UIImageView alloc] init];
        self.silverImageView.translatesAutoresizingMaskIntoConstraints = NO;

        self.goldImageView = [[UIImageView alloc] init];
        self.goldImageView.translatesAutoresizingMaskIntoConstraints = NO;

        [self.contentView addSubview:self.badgeLabel];
        [self.contentView addSubview:self.bronzeImageView];
        [self.contentView addSubview:self.silverImageView];
        [self.contentView addSubview:self.goldImageView];

        NSDictionary *views = @{@"badgeLabel": self.badgeLabel,
                                @"bronzeImageView": self.bronzeImageView,
                                @"silverImageView": self.silverImageView,
                                @"goldImageView": self.goldImageView};

        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.badgeLabel
                                                                     attribute:NSLayoutAttributeCenterY
                                                                      relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1.0
                                                                      constant:0.0]];

        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[badgeLabel]-(20)-[bronzeImageView(50)]-[silverImageView(50)]-[goldImageView(50)]-(20)-|"
                                                                                 options:NSLayoutFormatAlignAllCenterY
                                                                                 metrics:nil
                                                                                   views:views]];

        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bronzeImageView(50)]"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]];

        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[silverImageView(50)]"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]];

        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[goldImageView(50)]"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]];
    }
    return self;
}

- (void)setShowBronze:(BOOL)showBronze
{
    _showBronze = showBronze;

    if (showBronze) {
        self.bronzeImageView.image = self.bronzeImage;
    }
    else {
        self.bronzeImageView.image = self.defaultImage;
    }
}

- (void)setShowSilver:(BOOL)showSilver
{
    _showSilver = showSilver;

    if (showSilver) {
        self.silverImageView.image = self.silverImage;
    }
    else {
        self.silverImageView.image = self.defaultImage;
    }
}

- (void)setShowGold:(BOOL)showGold
{
    _showGold = showGold;

    if (showGold) {
        self.goldImageView.image = self.goldImage;
    }
    else {
        self.goldImageView.image = self.defaultImage;
    }
}

@end
