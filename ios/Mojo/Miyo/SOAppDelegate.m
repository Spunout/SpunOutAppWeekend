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

@implementation SOAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    SOMainViewController *mainViewController = [[SOMainViewController alloc] init];
    self.window.rootViewController = mainViewController;

    [self.window makeKeyAndVisible];

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    if (![self resetPointsIfMonday :prefs])
    {
        [self deductPointsIfNotLoggedIn :prefs];
    }

    return YES;
}

- (bool)resetPointsIfMonday:(NSUserDefaults *)prefs
{
    NSDate *now = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    bool wasScoreReset = false;

    NSDate *lastScoreReset = [prefs objectForKey:@"lastScoreReset"];

    int daysSinceLastReset = [self getNumberOfDaysSince:now :lastScoreReset];

    if (daysSinceLastReset < 7)
    {
        int daysAgo = 0;
        int interval = 0;

        while (daysAgo < daysSinceLastReset)
        {
            if (daysAgo != 0)
            {
                interval = 86400 * daysAgo;
            }

            if ([[gregorian components:NSWeekdayCalendarUnit | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[now dateByAddingTimeInterval:-interval]] weekday] == 2)
            {
                [self resetScore:prefs];
                wasScoreReset = true;
            }

            daysAgo++;
        }
    }
    else {
        [self resetScore :prefs];
        wasScoreReset = true;
    }

    return wasScoreReset;
}

- (void)deductPointsIfNotLoggedIn:(NSUserDefaults *)prefs
{
    NSInteger currentScore = [prefs integerForKey:@"score"];
    NSDate *now = [[NSDate alloc] init];
    NSDate *lastOpen = [prefs objectForKey:@"lastOpen"];

    // check how many days the user has not logged in for

    int daysSinceLastLogin = [self getNumberOfDaysSince:now :lastOpen];
    NSNumber *daysSinceLastLoginNum = [NSNumber numberWithInt:daysSinceLastLogin];
    NSLog(@"%d", [daysSinceLastLoginNum integerValue]);

    if (daysSinceLastLogin > 0)
    {
        int pointsLost = daysSinceLastLogin * 15;
        [prefs setInteger:(currentScore - pointsLost) forKey:@"score"];
    }
}

- (void)resetScore:(NSUserDefaults *)prefs
{
    [prefs setInteger:150 forKey:@"score"];
    [prefs setObject:[[NSDate alloc] init] forKey:@"lastScoreReset"];
    NSLog(@"Reseting score to 150 because Monday has passed.");
}

- (int)getNumberOfDaysSince:(NSDate *)from :(NSDate *)to
{
    NSNumber *timeInterval = [[NSNumber alloc] initWithDouble:[from timeIntervalSinceDate:to]];

    int daysSinceLastLogin = [timeInterval intValue] / 86400;

    return daysSinceLastLogin;
}

@end
