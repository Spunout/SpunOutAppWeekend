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

@interface SOAppDelegate () <UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *redirectURLs;
@property (nonatomic, strong) NSMutableArray *activityInformationNames;
@property (nonatomic, strong) NSURL *selectedInformationURL;

@end

@implementation SOAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    DLog(@"Database Path: %@", [SOAppDelegate databasePath]);

    [self checkLowUsage];

    [self migrateDatabaseSchema];

    [self checkLevel];
    [self checkAchievements];
    [self resetPointsIfMonday];

    SOMainViewController *mainViewController = [[SOMainViewController alloc] init];
    mainViewController.tabBarItem.title = @"Log Activities";
    mainViewController.tabBarItem.image = [[UIImage imageNamed:@"LogTab"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mainViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"LogTab"];

    UINavigationController *chartViewController = [[UINavigationController alloc] initWithRootViewController:[[SOChartViewController alloc] init]];
    chartViewController.navigationBar.translucent = NO;
    chartViewController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    chartViewController.tabBarItem.title = @"Activity Chart";
    chartViewController.tabBarItem.image = [[UIImage imageNamed:@"ActivityChartTab"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    chartViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"ActivityChartTab"];

    UINavigationController *badgesViewController = [[UINavigationController alloc] initWithRootViewController:[[SOBadgesViewController alloc] init]];
    badgesViewController.navigationBar.translucent = NO;
    badgesViewController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    badgesViewController.tabBarItem.title = @"Badges";
    badgesViewController.tabBarItem.image = [[UIImage imageNamed:@"BadgesTab"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    badgesViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"BadgesTab"];

    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.tabBar.translucent = NO;
    tabBarController.tabBar.barStyle = UIBarStyleBlackOpaque;
    tabBarController.viewControllers = @[mainViewController, chartViewController, badgesViewController];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.tintColor = [UIColor whiteColor];

    self.window.rootViewController = tabBarController;

    [self.window makeKeyAndVisible];

    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor miyoBlue]];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor whiteColor]];

    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.46 green:0.84 blue:0.99 alpha:1], NSForegroundColorAttributeName, nil]
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

- (void)checkLowUsage
{
    NSDate *firstLaunchDate =[[NSUserDefaults standardUserDefaults] objectForKey:@"first_launch_date"];
    NSDate *lastAlertDate =[[NSUserDefaults standardUserDefaults] objectForKey:@"last_activity_alert_date"];

    if (!firstLaunchDate) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"first_launch_date"];
    }
    else if (![lastAlertDate isToday] && [firstLaunchDate isNewWeek]) {
        self.redirectURLs = [NSMutableArray array];

        if ([[SOMiyoDatabase sharedInstance] getCountForActivity:@"eat" fromDay:1 toDay:7] < 4) {
            [self.redirectURLs addObject:[NSURL URLWithString:@"http://spunout.ie/eatingtips"]];
            [self.activityInformationNames addObject:@"Eat Well"];
        }
        if ([[SOMiyoDatabase sharedInstance] getCountForActivity:@"sleep" fromDay:1 toDay:7] < 4) {
            [self.redirectURLs addObject:[NSURL URLWithString:@"http://spunout.ie/sleepingtips"]];
            [self.activityInformationNames addObject:@"Sleep Well"];
        }
        if ([[SOMiyoDatabase sharedInstance] getCountForActivity:@"exercise" fromDay:1 toDay:7] < 4) {
            [self.redirectURLs addObject:[NSURL URLWithString:@"http://spunout.ie/movingtips"]];
            [self.activityInformationNames addObject:@"Move"];
        }
        if ([[SOMiyoDatabase sharedInstance] getCountForActivity:@"learn" fromDay:1 toDay:7] < 4) {
            [self.redirectURLs addObject:[NSURL URLWithString:@"http://spunout.ie/learningtips"]];
            [self.activityInformationNames addObject:@"Learn"];
        }
        if ([[SOMiyoDatabase sharedInstance] getCountForActivity:@"talk" fromDay:1 toDay:7] < 4) {
            [self.redirectURLs addObject:[NSURL URLWithString:@"http://spunout.ie/talkingtips"]];
            [self.activityInformationNames addObject:@"Talk"];
        }
        if ([[SOMiyoDatabase sharedInstance] getCountForActivity:@"make" fromDay:1 toDay:7] < 4) {
            [self.redirectURLs addObject:[NSURL URLWithString:@"http://spunout.ie/makingtips"]];
            [self.activityInformationNames addObject:@"Make"];
        }
        if ([[SOMiyoDatabase sharedInstance] getCountForActivity:@"play" fromDay:1 toDay:7] < 4) {
            [self.redirectURLs addObject:[NSURL URLWithString:@"http://spunout.ie/playingtips"]];
            [self.activityInformationNames addObject:@"Play"];
        }
        if ([[SOMiyoDatabase sharedInstance] getCountForActivity:@"connect" fromDay:1 toDay:7] < 4) {
            [self.redirectURLs addObject:[NSURL URLWithString:@"http://spunout.ie/connectingtips"]];
            [self.activityInformationNames addObject:@"Connect"];
        }

        NSInteger index = arc4random() % self.redirectURLs.count;

        NSString *selectedActivity = self.activityInformationNames[index];
        self.selectedInformationURL = self.redirectURLs[index];

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Activity Information"
                                                            message:[NSString stringWithFormat:@"You seem to be finding it difficult to %@? Would you like some information on %@?", selectedActivity, selectedActivity]
                                                           delegate:self
                                                  cancelButtonTitle:@"No Thanks"
                                                  otherButtonTitles:@"Yes", nil];
        [alertView show];
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
                                                                message:[NSString stringWithFormat:@"Congratulations! You've leveled up since yesterday.\nYou are now on level %zd\nComplete activites and collect Health Points to progress in MiYo!", currentLevel]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
    }

    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"last_activity_alert_date"];

    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:self.selectedInformationURL];
    }
}

- (void)checkAchievements
{
    NSArray *activities = @[@"eat", @"sleep", @"exercise", @"learn", @"talk", @"make", @"connect", @"play"];
    NSArray *fullActivityNames = @[@"Eat Well", @"Sleep Well", @"Move", @"Learn", @"Talk", @"Make", @"Connect", @"Play"];
    NSArray *badges = @[@"Food Nut", @"Sleep Star", @"Active Champion", @"Wise Owl", @"Chatterbox", @"Producer", @"Play Maker", @"Social Buttterfly"];

    for (NSInteger i = 0; i < activities.count; i++) {
        NSString *activity = activities[i];
        NSString *fullActivityName = fullActivityNames[i];
        NSString *badge = badges[i];

        if ([[SOMiyoDatabase sharedInstance] getCountForActivity:activity fromDay:1 toDay:7] > 6
            && ![[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@-bronze", activity]]) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@-bronze", activity]];

            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New Badge Unlocked!"
                                                                message:[NSString stringWithFormat:@"Congratulations, you've unlocked a bronze %@ badge!\nShoot for silver. Complete '%@' 12 days over 2 weeks", badge, fullActivityName]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
        if ([[SOMiyoDatabase sharedInstance] getCountForActivity:activity fromDay:1 toDay:14] > 12
            && ![[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@-silver", activity]]) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@-silver", activity]];

            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New Badge Unlocked!"
                                                                message:[NSString stringWithFormat:@"Congratulations, you've unlocked a silver %@ badge!\nGo for gold! Complete '%@' 18 days over 3 weeks", badge, fullActivityName]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
        if ([[SOMiyoDatabase sharedInstance] getCountForActivity:activity fromDay:1 toDay:21] > 18
            && ![[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@-gold", activity]]) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@-gold", activity]];

            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New Badge Unlocked!"
                                                                message:[NSString stringWithFormat:@"Congratulations, you've unlocked a gold %@ badge! When it comes to '%@' you're at the top of your game.", badge, fullActivityName]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
    }

    [[NSUserDefaults standardUserDefaults] synchronize];
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
