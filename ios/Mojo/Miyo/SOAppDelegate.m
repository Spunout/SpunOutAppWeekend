//
//  SOAppDelegate.m
//  Mojo
//
//  Created by Matt Donnelly on 25/01/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SOAppDelegate.h"
#import "SOViewController.h"
#import "SOMainViewController.h"
#import "SOChartViewController.h"
#import "SOMiyoDatabase.h"

#import "FMDatabase+Additions.h"
#import "NSDate+Comparisons.h"

#import <CommonCrypto/CommonCrypto.h>
#import <FMDB/FMDatabase.h>

@interface SOAppDelegate ()

@property (strong, nonatomic) UIPageViewController *pageController;

@end

@implementation SOAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self migrateDatabaseSchema];

    [self checkAchievements];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
//    self.window.rootViewController = [[SOMainViewController alloc] init];

    self.window.rootViewController = [[SOViewController alloc] init];
    [self.window makeKeyAndVisible];

    [self resetPointsIfMonday];

    return YES;
}

- (void)resetPointsIfMonday
{
    if ([[[SOMiyoDatabase sharedInstance] lastUpdateDate] isNewWeek]) {
        [[NSUserDefaults standardUserDefaults] setInteger:150 forKey:@"score"];
    }
}

- (void)checkAchievements
{
    NSArray *activities = @[@"eat", @"sleep", @"exercise", @"learn", @"talk", @"make", @"connect", @"play"];

    for (NSString *activity in activities) {
        if ([[SOMiyoDatabase sharedInstance] getCountForActivity:activity overNumberOfDays:7] > 6) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@-bronze", activity]];
        }
        if ([[SOMiyoDatabase sharedInstance] getCountForActivity:activity overNumberOfDays:14] > 12) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@-silver", activity]];
        }
        if ([[SOMiyoDatabase sharedInstance] getCountForActivity:activity overNumberOfDays:21] > 18) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@-gold", activity]];
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
            [db executeUpdateFromFileWithPath:[migrations stringByAppendingString:[NSString stringWithFormat:@"/%d.sql", i+1]]];
            // FMDB treats all statements as prepared statements so we have to set the version without it
            NSInteger rc = sqlite3_exec(db.sqliteHandle, [[NSString stringWithFormat:@"PRAGMA user_version = %d", i+1] UTF8String], NULL, NULL, NULL);
            if (rc != SQLITE_OK) {
                NSLog(@"Failed to update database user version");
            }
        }
    }

    [db close];
}

@end
