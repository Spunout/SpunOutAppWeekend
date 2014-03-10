//
//  SOPageControlDelegate.h
//  Miyo
//
//  Created by James Eggers on 16/02/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SOPageControlDelegate : NSObject

@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic) BOOL pageControlUsed;

// methods
-(IBAction)changePage:(id)sender;

@end


