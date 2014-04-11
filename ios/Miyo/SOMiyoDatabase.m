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

- (NSMutableArray*)getDaysData:(NSString*)activity fromDay:(NSInteger)fromDay toDay:(NSInteger)toDay
{
    __block NSMutableArray* days = [[NSMutableArray alloc] init];
    __block NSDate* lastDate;
    __block NSInteger daysBetween;
    
    [self inDatabase:^(FMDatabase *db) {
       
        NSString *query = [NSString stringWithFormat:@"SELECT timestamp,eat,sleep,exercise,learn,talk,make,connect,play FROM data ORDER BY timestamp DESC LIMIT ? OFFSET ?"];
        
        FMResultSet *resultSet = [db executeQuery:query, [NSNumber numberWithInteger:toDay], [NSNumber numberWithInteger:fromDay]];
        
        while ([resultSet next])
        {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[resultSet doubleForColumnIndex:0]];
            
            if (lastDate != nil)
            {
                NSUInteger unitFlags = NSDayCalendarUnit;
                NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSDateComponents *components = [calendar components:unitFlags fromDate:date toDate:lastDate options:0];
                daysBetween = [components day]+1;
            } else {
                daysBetween = 1;
            }

            if (daysBetween > 1)
            {
                while (daysBetween > 1)
                {
                    [days addObject:[[NSNumber alloc] initWithInteger:0]];
                    daysBetween--;
                }
            }
            
            NSInteger totalActivities = [resultSet intForColumnIndex:1] + [resultSet intForColumnIndex:2] + [resultSet intForColumnIndex:3] + [resultSet intForColumnIndex:4] + [resultSet intForColumnIndex:5] + [resultSet intForColumnIndex:6] + [resultSet intForColumnIndex:7] + [resultSet intForColumnIndex:8];
            [days addObject:[[NSNumber alloc] initWithInteger:totalActivities]];
            lastDate = date;
            
        }
        
        [resultSet close];
        
    }];
    
    return days;
}

- (NSInteger)getCountForActivity:(NSString *)activity fromDay:(NSInteger)fromDay toDay:(NSInteger)toDay
{
    __block NSInteger activityCount = 0;
    
    [self inDatabase:^(FMDatabase *db) {
        // NSString *query = [NSString stringWithFormat:@"SELECT SUM(%@) FROM data ORDER BY timestamp DESC LIMIT ? OFFSET 1;", activity];
        //NSString *query = [NSString stringWithFormat:@"SELECT SUM(%@) FROM data ORDER BY timestamp DESC LIMIT ? OFFSET ?;", activity];
        NSString *query = [NSString stringWithFormat:@"SELECT sum(%@) FROM (SELECT * FROM data ORDER BY timestamp DESC LIMIT ? OFFSET ?) AS subquery;", activity];
        
        FMResultSet *resultSet = [db executeQuery:query, [NSNumber numberWithInteger:toDay], [NSNumber numberWithInteger:fromDay]];
        
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
