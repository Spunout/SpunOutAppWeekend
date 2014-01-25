//
//  SOPointMeterView.m
//  Mojo
//
//  Created by Matt Donnelly on 25/01/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import "SOPointMeterView.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

static const CGFloat kAngleOffset = -90.0f;
static const CGFloat kBorderWidth = 15.0f;

@implementation SOPointMeterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        self.label = [[UILabel alloc] init];
        self.label.font = [UIFont boldSystemFontOfSize:75.0f];
        self.label.translatesAutoresizingMaskIntoConstraints = NO;

        [self addSubview:self.label];

        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.label
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0f constant:0]];

        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.label
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0f constant:0]];
    }

    return self;
}

- (void)setProgress:(CGFloat)newProgress
{
    _progress = fmaxf(0.0f, fminf(1.0f, newProgress));
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    // Background
    [[UIColor whiteColor] set];
    CGContextFillEllipseInRect(context, rect);

    // Math
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGFloat radius = floorf((rect.size.width - kBorderWidth) / 2);
    CGFloat angle = DEGREES_TO_RADIANS((360.0f * self.progress) + kAngleOffset);
    CGPoint points[3] = {
        CGPointMake(center.x, ceilf(kBorderWidth / 2)),
        center,
        CGPointMake(center.x + radius * cosf(angle), center.y + radius * sinf(angle))
    };

    // Fill
    if (self.progress > 0.0f) {
        [[UIColor greenColor] set];
        CGContextAddLines(context, points, sizeof(points) / sizeof(points[0]));
        CGContextAddArc(context, center.x, center.y, radius, DEGREES_TO_RADIANS(kAngleOffset), angle, true);
        CGContextDrawPath(context, kCGPathEOFill);
    }

    // Inner Border
    if (self.progress < 0.99f) {
        [[UIColor whiteColor] set];
        CGContextAddLines(context, points, sizeof(points) / sizeof(points[0]));
        CGContextDrawPath(context, kCGPathStroke);
    }
}

@end
