//
//  SOAppDelegate.m
//  Mojo
//
//  Created by Matt Donnelly on 25/01/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import "SOAppDelegate.h"
#import "SOMainViewController.h"

#import <CommonCrypto/CommonCrypto.h>

static NSString *const kSOScoreKeyName = @"SOScoreKeyName";

@implementation SOAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    SOMainViewController *mainViewController = [[SOMainViewController alloc] init];
    self.window.rootViewController = mainViewController;

    [self.window makeKeyAndVisible];

    return YES;
}

@end
