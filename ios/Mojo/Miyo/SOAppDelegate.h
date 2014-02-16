//
//  SOAppDelegate.h
//  Mojo
//
//  Created by Matt Donnelly on 25/01/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SOAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;

@end
