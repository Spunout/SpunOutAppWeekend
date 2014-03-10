//
//  SOPieLayer.m
//  Mojo
//
//  Created by Matt Donnelly on 26/01/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import "SOPieLayer.h"
#import "UIColor+Miyo.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

static const CGFloat kAngleOffset = -90.0f;
static const CGFloat kBorderWidth = 15.0f;

@implementation SOPieLayer

- (id)initWithLayer:(id)layer
{
    self = [super initWithLayer:layer];
    if (self)
    {
        if ([layer isKindOfClass:[SOPieLayer class]])
        {
            SOPieLayer *otherLayer = layer;
            self.progress = otherLayer.progress;
        }
    }

    return self;
}

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString:@"progress"]) {
        return YES;
    }
    else {
        return [super needsDisplayForKey:key];
    }
}

- (void)drawInContext:(CGContextRef)context
{
    CGRect rect = self.bounds;

    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGFloat radius = floorf((rect.size.width - kBorderWidth) / 2);
    CGFloat angle = DEGREES_TO_RADIANS((360.0f * self.progress) + kAngleOffset);

    // Background
    CGContextAddEllipseInRect(context, rect);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillPath(context);

    // Fill
    CGContextAddArc(context, center.x, center.y, radius, DEGREES_TO_RADIANS(kAngleOffset), angle, false);
    CGContextAddLineToPoint(context, center.x, center.y);
    CGContextClosePath(context);

    CGContextSetFillColorWithColor(context, [UIColor miyoGreen].CGColor);
    CGContextFillPath(context);
}

@end
