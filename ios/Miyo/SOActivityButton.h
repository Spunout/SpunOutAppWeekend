//
//  SOActivityButton.h
//  Mojo
//
//  Created by Matt Donnelly on 26/01/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SOActivityButton : UIControl

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image;

@end
