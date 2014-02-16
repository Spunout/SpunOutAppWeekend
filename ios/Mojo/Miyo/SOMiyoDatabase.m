//
//  SODatabaseQueue.m
//  Miyo
//
//  Created by Matt Donnelly on 16/02/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import "SOMiyoDatabase.h"
#import "SOAppDelegate.h"

#import "NSDate+Comparisons.h"

#import <FMDB/FMDatabase.h>

static NSString *const kSODatabaseName = @"miyo.db";

@implementation SOMiyoDatabase

+ (SOMiyoDatabase *)sharedInstance
{
    static SOMiyoDatabase *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SOMiyoDatabase alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super initWithPath:[SOAppDelegate databasePath]];
    if (self) {
#if DEBUG
        [self inDatabase:^(FMDatabase *db) {
            db.traceExecution = YES;
        }];
#endif
    }
    return self;
}

/*
    CREATE TABLE data (
        mood REAL,
        eat BOOLEAN,
        sleep BOOLEAN,
        exercise BOOLEAN,
        learn BOOLEAN,
        talk BOOLEAN,
        make BOOLEAN,
        connect BOOLEAN,
        play BOOLEAN,
        timestamp DATETIME,
        lifetime_points INTEGER,
        PRIMARY KEY (timestamp)
    );
*/

- (void)insertOrUpdateMood:(double)mood activities:(NSArray *)activities earnedPoints:(NSInteger)earnedPoints
{
    [self inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *lastResultSet = [db executeQuery:@"SELECT * FROM data ORDER BY timestamp DESC"];

        NSInteger lifetimePointsTotal = 0;

        if ([lastResultSet next]) {
            NSDate *lastTimestamp = [lastResultSet dateForColumn:@"timestamp"];

            if ([lastTimestamp isToday]) {
                if (![db executeUpdate:@"DELETE FROM data WHERE timestamp = ?", lastTimestamp]) {
                    *rollback = YES;
                }
            }
        }

        if ([lastResultSet next]) {
            lifetimePointsTotal = [lastResultSet intForColumn:@"lifetime_points"] + earnedPoints;
        }
        else {
            lifetimePointsTotal = earnedPoints;
        }

        [lastResultSet close];

        NSMutableArray *arguments = [NSMutableArray array];
        [arguments addObject:[NSNumber numberWithDouble:mood]];
        [arguments addObjectsFromArray:activities];
        [arguments addObject:[NSDate date]];
        [arguments addObject:[NSNumber numberWithInteger:lifetimePointsTotal]];

        if (![db executeUpdate:@"INSERT INTO data VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)" withArgumentsInArray:arguments]) {
            *rollback = YES;
        }
    }];
}

- (NSArray *)getLastSelectedActivites
{
    __block NSMutableArray *selectedActivites = nil;

    [self inDatabase:^(FMDatabase *db) {
        FMResultSet *lastResultSet = [db executeQuery:@"SELECT * FROM data ORDER BY timestamp DESC"];

        if ([lastResultSet next]) {
            NSDate *lastTimestamp = [lastResultSet dateForColumn:@"timestamp"];

            if ([lastTimestamp isToday]) {
                selectedActivites = [NSMutableArray array];
                [selectedActivites addObject:[NSNumber numberWithBool:[lastResultSet boolForColumnIndex:1]]];
                [selectedActivites addObject:[NSNumber numberWithBool:[lastResultSet boolForColumnIndex:2]]];
                [selectedActivites addObject:[NSNumber numberWithBool:[lastResultSet boolForColumnIndex:3]]];
                [selectedActivites addObject:[NSNumber numberWithBool:[lastResultSet boolForColumnIndex:4]]];
                [selectedActivites addObject:[NSNumber numberWithBool:[lastResultSet boolForColumnIndex:5]]];
                [selectedActivites addObject:[NSNumber numberWithBool:[lastResultSet boolForColumnIndex:6]]];
                [selectedActivites addObject:[NSNumber numberWithBool:[lastResultSet boolForColumnIndex:7]]];
                [selectedActivites addObject:[NSNumber numberWithBool:[lastResultSet boolForColumnIndex:8]]];
            }
        }

        [lastResultSet close];
    }];

    return selectedActivites;
}

- (NSInteger)getCountForActivity:(NSString *)activity overNumberOfDays:(NSInteger)days
{
    __block NSInteger activityCount = 0;

    [self inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:@"SELECT SUM(?) FROM data ORDER BY timestamp DESC LIMIT ? OFFSET 1;", activity, days];

        if ([resultSet next]) {
            activityCount = [resultSet intForColumnIndex:0];
        }

        [resultSet close];
    }];

    return activityCount;
}

- (NSInteger)getCurrentLifetimePoints
{
    __block NSInteger activityCount = 0;

    [self inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:@"SELECT lifetime_points FROM data ORDER BY timestamp DESC LIMIT 1 OFFSET 1;"];

        if ([resultSet next]) {
            activityCount = [resultSet intForColumnIndex:0];
        }

        [resultSet close];
    }];

    return activityCount;
}

- (NSInteger)getCurrentLevel
{
    NSInteger lifetimePoints = [self getCurrentLifetimePoints];

    return log(lifetimePoints) / log(2);
}

- (NSDate *)lastUpdateDate
{
    __block NSDate *lastUpdateDate = nil;

    [self inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM data ORDER BY timestamp DESC LIMIT 1 OFFSET 1;"];

        if ([resultSet next]) {
            lastUpdateDate = [resultSet dateForColumn:@"timestamp"];
        }

        [resultSet close];
    }];

    return lastUpdateDate;
}

@end
