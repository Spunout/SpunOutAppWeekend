//
//  SOAppDelegate.m
//  Mojo
//
//  Created by Matt Donnelly on 25/01/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import "SOAppDelegate.h"
#import "SOMainViewController.h"
#import "FMDatabase+Additions.h"

#import <CommonCrypto/CommonCrypto.h>
#import <FMDB/FMDatabase.h>

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

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self migrateDatabaseSchema];
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

        for (NSInteger i = version + 1; i < fileCount; i++) {
            [db executeUpdateFromFileWithPath:[migrations stringByAppendingString:[NSString stringWithFormat:@"/%d.sql", i]]];
            // FMDB treats all statements as prepared statements so we have to set the version without it
            NSInteger rc = sqlite3_exec(db.sqliteHandle, [[NSString stringWithFormat:@"PRAGMA user_version = %d", i] UTF8String], NULL, NULL, NULL);
            if (rc != SQLITE_OK) {
                NSLog(@"Failed to update database user version");
            }
        }
    }

    [db close];
}

@end
