//
//  SOPointMeterView.m
//  Mojo
//
//  Created by Matt Donnelly on 25/01/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import "SOPointMeterView.h"
#import "SOPieLayer.h"

#import "UIColor+Miyo.h"

@interface SOPointMeterView ()

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, assign) CGFloat progress;

@end

@implementation SOPointMeterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        self.layer.contentsScale = [UIScreen mainScreen].scale;

        self.label = [[UILabel alloc] init];
        self.label.font = [UIFont boldSystemFontOfSize:100.0f];
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

- (void)setCurrentValue:(NSUInteger)currentValue
{
    _currentValue = currentValue;

    CGFloat count = self.maximumValue - self.minimumValue;
    self.progress = (CGFloat)currentValue / count;

    self.label.text = [NSString stringWithFormat:@"%lu", (unsigned long)currentValue];
    
    [self setNeedsDisplay];
}

- (void)setProgress:(CGFloat)progress
{
    BOOL growing = progress > self.progress;
    [self setProgress:progress animated:growing];
}

- (void)setProgress:(float)progress animated:(BOOL)animated
{
    if (progress < 0.0f) {
        progress = 0.0f;
    }
    else if(progress > 1.0f) {
        progress = 1.0f;
    }

    SOPieLayer *layer = (SOPieLayer *)self.layer;
    if (animated) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"progress"];
        animation.duration = 0.4;
        animation.fromValue = [NSNumber numberWithFloat:layer.progress];
        animation.toValue = [NSNumber numberWithFloat:progress];
        [layer addAnimation:animation forKey:@"progressAnimation"];

        layer.progress = progress;
    }
    else {
        layer.progress = progress;
        [layer setNeedsDisplay];
    }
}

+ (Class)layerClass
{
    return [SOPieLayer class];
}

@end
