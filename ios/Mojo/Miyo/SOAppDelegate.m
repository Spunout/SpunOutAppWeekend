//
//  SOAppDelegate.m
//  Mojo
//
//  Created by Matt Donnelly on 25/01/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SOAppDelegate.h"
#import "SOMainViewController.h"
#import "SOChartViewController.h"
#import "SOBadgesViewController.h"
#import "SOMiyoDatabase.h"

#import "FMDatabase+Additions.h"
#import "NSDate+Comparisons.h"
#import "UIColor+Miyo.h"

#import <CommonCrypto/CommonCrypto.h>
#import <FMDB/FMDatabase.h>

@interface SOAppDelegate ()

@property (strong, nonatomic) UIPageViewController *pageController;

@end

@implementation SOAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self migrateDatabaseSchema];

    [self checkLevel];
    [self checkAchievements];
    [self resetPointsIfMonday];

    SOMainViewController *mainViewController = [[SOMainViewController alloc] init];
    mainViewController.tabBarItem.title = @"Log Activities";

    UINavigationController *chartViewController = [[UINavigationController alloc] initWithRootViewController:[[SOChartViewController alloc] init]];
    chartViewController.navigationBar.translucent = NO;
    chartViewController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    chartViewController.tabBarItem.title = @"Activity Chart";

    UINavigationController *badgesViewController = [[UINavigationController alloc] initWithRootViewController:[[SOBadgesViewController alloc] init]];
    badgesViewController.navigationBar.translucent = NO;
    badgesViewController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    badgesViewController.tabBarItem.title = @"Badges";

    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.tabBar.translucent = NO;
    tabBarController.tabBar.barStyle = UIBarStyleBlackOpaque;
    tabBarController.viewControllers = @[mainViewController, chartViewController, badgesViewController];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.tintColor = [UIColor miyoBlue];

    self.window.rootViewController = tabBarController;

    [self.window makeKeyAndVisible];

    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    //[[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:0.15 green:0.64 blue:0.82 alpha:1]];
    [[UITabBar appearance] setBarTintColor:[UIColor miyoBlue]];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor whiteColor]];

    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithWhite:1.0 alpha:0.5], NSForegroundColorAttributeName, nil]
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]
                                             forState:UIControlStateSelected];

    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //[[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.15 green:0.64 blue:0.82 alpha:1]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor miyoBlue]];

    return YES;
}

- (void)resetPointsIfMonday
{
    if ([[[SOMiyoDatabase sharedInstance] lastUpdateDate] isNewWeek]) {
        [[NSUserDefaults standardUserDefaults] setInteger:150 forKey:@"score"];
    }
}

- (void)checkLevel
{
    if (![[NSUserDefaults standardUserDefaults] integerForKey:@"current_level"]) {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"current_level"];
        [[NSUserDefaults standardUserDefaults] setInteger:10 forKey:@"next_level_exp"];
    }
    else {
        NSInteger nextLevelExp = [[NSUserDefaults standardUserDefaults] integerForKey:@"next_level_exp"];
        NSInteger currentLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"current_level"];
        NSInteger lifetimePoints = [[SOMiyoDatabase sharedInstance] getCurrentLifetimePoints];

        if (lifetimePoints >= nextLevelExp) {
            if (currentLevel >= 10) {
                nextLevelExp *= 1.1;
            }
            else {
                nextLevelExp *= 1.5;
            }

            [[NSUserDefaults standardUserDefaults] setInteger:nextLevelExp forKey:@"next_level_exp"];
            [[NSUserDefaults standardUserDefaults] setInteger:++currentLevel forKey:@"current_level"];

            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Level up!"
                                                                message:[NSString stringWithFormat:@"Congratulations! You've leveled up since yesterday.\nYou are now on level %zd\nComplete activites and collect points to progress further!", currentLevel]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
    }
}

- (void)checkAchievements
{
    NSArray *activities = @[@"eat", @"sleep", @"exercise", @"learn", @"talk", @"make", @"connect", @"play"];
    NSArray *fullActivityNames = @[@"Eat Well", @"Slept Well", @"Exercise", @"Learn", @"Talk", @"Make", @"Connect", @"Play"];
    NSArray *badges = @[@"Food Nut", @"Sleep Star", @"Active Champion", @"Wise One", @"Chatterbox", @"Producer", @"Merry Maker", @"Social Buttterfly"];

    for (NSInteger i = 0; i < activities.count; i++) {
        NSString *activity = activities[i];
        NSString *fullActivityName = fullActivityNames[i];
        NSString *badge = badges[i];

        if ([[SOMiyoDatabase sharedInstance] getCountForActivity:activity fromDay:1 toDay:7] > 6) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@-bronze", activity]];

            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New Badge Unlocked!"
                                                                message:[NSString stringWithFormat:@"Congratulations, you've unlocked a bronze %@ badge!\nShoot for silver. Complete '%@' 12 days in 2 weeks", badge, fullActivityName]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
        if ([[SOMiyoDatabase sharedInstance] getCountForActivity:activity fromDay:1 toDay:14] > 12) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@-silver", activity]];

            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New Badge Unlocked!"
                                                                message:[NSString stringWithFormat:@"Congratulations, you've unlocked a silver %@ badge!\nGo for gold! Complete '%@' 18 days in 3 weeks", badge, fullActivityName]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
        if ([[SOMiyoDatabase sharedInstance] getCountForActivity:activity fromDay:1 toDay:21] > 18) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@-gold", activity]];

            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New Badge Unlocked!"
                                                                message:[NSString stringWithFormat:@"Congratulations, you've unlocked a gold %@ badge!", badge]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
    }
}

#pragma mark - Miyo Database

+ (NSString *)databasePath
{
    NSURL *documentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                        inDomains:NSUserDomainMask] lastObject];
    return [[documentsDirectory URLByAppendingPathComponent:@"miyo.db"] absoluteString];
}

- (void)migrateDatabaseSchema
{
    FMDatabase *db = [FMDatabase databaseWithPath:[SOAppDelegate databasePath]];
    [db open];

    FMResultSet *s = [db executeQuery:@"PRAGMA user_version;"];
    if ([s next]) {
        NSInteger version = [s intForColumnIndex:0];
        NSString *migrationsPath = [[NSBundle mainBundle] pathForResource:@"Migrations" ofType:@"bundle"];
        NSString *migrations = [[NSBundle bundleWithPath:migrationsPath] resourcePath];
        NSInteger fileCount = [[[NSFileManager defaultManager] subpathsOfDirectoryAtPath:migrationsPath error:nil] count];

        for (NSInteger i = version; i < fileCount; i++) {
            [db executeUpdateFromFileWithPath:[migrations stringByAppendingString:[NSString stringWithFormat:@"/%zd.sql", i+1]]];
            // FMDB treats all statements as prepared statements so we have to set the version without it
            NSInteger rc = sqlite3_exec(db.sqliteHandle, [[NSString stringWithFormat:@"PRAGMA user_version = %zd", i+1] UTF8String], NULL, NULL, NULL);
            if (rc != SQLITE_OK) {
                NSLog(@"Failed to update database user version");
            }
        }
    }

    [db close];
}

@end
