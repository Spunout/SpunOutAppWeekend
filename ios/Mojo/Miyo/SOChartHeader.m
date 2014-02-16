//
//  SOChartHeader.m
//  Miyo
//
//  Created by James Eggers on 16/02/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import "SOChartHeader.h"

// Colors
static UIColor *chartHeaderViewDefaultSeparatorColor = nil;

@interface SOChartHeader ()

@property (nonatomic, strong) UIView *separatorView;

@end

@implementation SOChartHeader

+ (void)initialize
{
	if (self == [SOChartHeader class])
	{
		chartHeaderViewDefaultSeparatorColor = [UIColor whiteColor];
	}
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 1;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
//        _titleLabel.font = [UIFont SystemFont];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.shadowColor = [UIColor blackColor];
        _titleLabel.shadowOffset = CGSizeMake(0, 1);
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
        
//        _subtitleLabel = [[UILabel alloc] init];
//        _subtitleLabel.numberOfLines = 1;
//        _subtitleLabel.adjustsFontSizeToFitWidth = NO;
//        _subtitleLabel.font = [UIFont systemFontOfSize:13.0];
////        _subtitleLabel.font = kJBFontHeaderSubtitle;
//        _subtitleLabel.textAlignment = NSTextAlignmentCenter;
//        _subtitleLabel.textColor = [UIColor whiteColor];
//        _subtitleLabel.shadowColor = [UIColor blackColor];
//        _subtitleLabel.shadowOffset = CGSizeMake(0, 1);
//        _subtitleLabel.backgroundColor = [UIColor clearColor];
//        [self addSubview:_subtitleLabel];
        
        _separatorView = [[UIView alloc] init];
        _separatorView.backgroundColor = chartHeaderViewDefaultSeparatorColor;
        [self addSubview:_separatorView];
    }
    return self;
}



- (void)setSeparatorColor:(UIColor *)separatorColor
{
    _separatorColor = separatorColor;
    self.separatorView.backgroundColor = _separatorColor;
    [self setNeedsLayout];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat titleHeight = ceil(self.bounds.size.height * 0.5);
    CGFloat subTitleHeight = self.bounds.size.height - titleHeight -20.0;
    CGFloat xOffset = 2.0;
    CGFloat yOffset = 0;
    
    self.titleLabel.frame = CGRectMake(xOffset, yOffset, self.bounds.size.width - (xOffset * 2), titleHeight);
    yOffset += self.titleLabel.frame.size.height;
    self.separatorView.frame = CGRectMake(xOffset * 2, yOffset, self.bounds.size.width - (xOffset * 4), 2.0);
    yOffset += self.separatorView.frame.size.height;
    //self.subtitleLabel.frame = CGRectMake(xOffset, yOffset, self.bounds.size.width - (xOffset * 2), subTitleHeight);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
