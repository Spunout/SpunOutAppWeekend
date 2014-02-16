//
//  SOViewController.h
//  Miyo
//
//  Created by James Eggers on 16/02/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SOViewController : UIViewController<UIPageViewControllerDelegate,UIPageViewControllerDataSource>
@property (nonatomic, strong) NSMutableArray *viewControllers;

@end
