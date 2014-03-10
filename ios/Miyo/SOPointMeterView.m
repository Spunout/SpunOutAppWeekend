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
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.adjustsFontSizeToFitWidth = YES;
        self.label.translatesAutoresizingMaskIntoConstraints = NO;

        NSDictionary *views = @{@"label": self.label};

        [self addSubview:self.label];

        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[label]|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views]];

        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views]];

        UITapGestureRecognizer *tapGesureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                              action:@selector(didTapPie)];
        [self addGestureRecognizer:tapGesureRecognizer];
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

    _progress = progress;
}

- (void)didTapPie
{
    SOPieLayer *layer = (SOPieLayer *)self.layer;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"progress"];
    animation.duration = 0.3;
    animation.fromValue = [NSNumber numberWithFloat:0];
    animation.toValue = [NSNumber numberWithFloat:layer.progress];
    [layer addAnimation:animation forKey:@"progressAnimation"];
}

+ (Class)layerClass
{
    return [SOPieLayer class];
}

@end
