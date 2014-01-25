//
//  SOAppDelegate.m
//  Mojo
//
//  Created by Matt Donnelly on 25/01/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import "SOAppDelegate.h"
#import "SOMainViewController.h"
#import <Parse/Parse.h>

@implementation SOAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    SOMainViewController *mainViewController = [[SOMainViewController alloc] init];
    self.window.rootViewController = mainViewController;

    [self.window makeKeyAndVisible];
    
    // Parse set up
    
    [Parse setApplicationId:@"2MS1N1zfmK380WV1zOYR1jhJWAj5BEz6uuZsAbIW" clientKey:@"Ke6SEnngzAwKRSWoPumG22ojb7UOjLl312uwOAp8"];
    
    // track stats with Parse
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
    return YES;
}

@end
