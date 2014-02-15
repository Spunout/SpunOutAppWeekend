//
//  SOPointMeterView.h
//  Mojo
//
//  Created by Matt Donnelly on 25/01/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SOPointMeterView : UIView

@property (nonatomic, assign) NSUInteger currentValue;

@property (nonatomic, assign) NSUInteger maximumValue;
@property (nonatomic, assign) NSUInteger minimumValue;

@end
