//
//  SOActivityMenuViewController.h
//  Mojo
//
//  Created by Matt Donnelly on 25/01/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SOActivityMenuViewController;

@protocol SOActivityMenuViewDelegate <NSObject>

- (void)didSelectActivitesForPoints:(NSInteger)points;

@end

@interface SOActivityMenuViewController : UIViewController

@property (nonatomic, weak) NSObject <SOActivityMenuViewDelegate> *delegate;

- (void)showInView:(UIView *)view;

- (void)dismissMenu;

@end
