//
//  SOPointMeterView.h
//  Mojo
//
//  Created by Matt Donnelly on 25/01/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SOPointMeterView : UIView

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) UIColor *fillColor;

@end
