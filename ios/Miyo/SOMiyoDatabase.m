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
 eat REAL,
 sleep REAL,
 exercise REAL,
 learn REAL,
 connect REAL,
 play REAL,
 timestamp DATETIME,
 lifetime_points INTEGER,
 PRIMARY KEY (timestamp)
 );
 */

- (void)insertOrUpdateMood:(NSString*)activity earnedPoints:(NSNumber*)earnedPoints tag:(NSUInteger)tag
{
    [self inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *lastResultSet = [db executeQuery:@"SELECT * FROM data ORDER BY timestamp DESC"];
        
        long lifetimePointsTotal;
        
        if ([lastResultSet next]) {
            NSDate *lastTimestamp = [lastResultSet dateForColumn:@"timestamp"];
            
            lifetimePointsTotal = [lastResultSet longForColumn:@"lifetime_points"] + [earnedPoints longValue];
            
            if ([lastTimestamp isToday]) {
                NSString *query = [NSString stringWithFormat:@"UPDATE data SET %@ = %ld WHERE timestamp = ?", activity, [earnedPoints longValue]];
                if (![db executeUpdate:query, lastTimestamp]) {
                    *rollback = YES;
                }
            }
            
        } else {
            
            lifetimePointsTotal = [earnedPoints longValue];
            
            NSMutableArray *arguments = [NSMutableArray array];
            [arguments addObject:[NSNumber numberWithDouble:0.0]];
            
            NSMutableArray *activities = [[NSMutableArray alloc] initWithArray:@[[NSNumber numberWithLong:0], [NSNumber numberWithLong:0], [NSNumber numberWithLong:0], [NSNumber numberWithLong:0], [NSNumber numberWithLong:0], [NSNumber numberWithLong:0]]];
            [activities replaceObjectAtIndex:tag withObject:[[NSNumber alloc] initWithLong:[earnedPoints longValue]]];
            
            [arguments addObjectsFromArray:activities];
            [arguments addObject:[NSDate date]];
            [arguments addObject:[NSNumber numberWithLong:lifetimePointsTotal]];
            
            if (![db executeUpdate:@"INSERT INTO data VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)" withArgumentsInArray:arguments]) {
                *rollback = YES;
            }
        }
        
        [lastResultSet close];

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
    __block NSDate* lastDate = [NSDate date];
    __block NSInteger daysBetween;
    __block NSUInteger unitFlags = NSDayCalendarUnit;
    __block NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    __block NSInteger totalActivities;
    
    for (int i = 0; i < toDay; i++)
    {
        NSNumber *zero = [[NSNumber alloc] initWithInteger:0];
        [days addObject:zero];
    }
    
    [self inDatabase:^(FMDatabase *db) {
        
        NSString *query = [NSString stringWithFormat:@"SELECT timestamp,eat,sleep,exercise,learn,connect,play FROM data ORDER BY timestamp DESC LIMIT %ld OFFSET %ld", (long)toDay, (long)fromDay];
        
        FMResultSet *resultSet = [db executeQuery:query];
        
        int counter = 0;
        
        while ([resultSet next])
        {

            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[resultSet doubleForColumnIndex:0]];

            NSDateComponents *components = [calendar components:unitFlags fromDate:date toDate:lastDate options:0];
            daysBetween = [components day];
            
            if ([activity length] == 0)
            {
                totalActivities = [resultSet longForColumnIndex:1] + [resultSet longForColumnIndex:2] + [resultSet longForColumnIndex:3] + [resultSet longForColumnIndex:4] + [resultSet longForColumnIndex:5] + [resultSet longForColumnIndex:6];
            } else {
                totalActivities = [resultSet longForColumnIndex:[resultSet columnIndexForName:activity]];
            }
            
            if ((counter + daysBetween) < [days count])
            {
                [days replaceObjectAtIndex:counter+daysBetween withObject:[[NSNumber alloc] initWithInteger:totalActivities]];
            }
            
            counter++;
            
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
        NSString *query = [NSString stringWithFormat:@"SELECT COUNT(*) FROM data WHERE %@ = 1 ORDER BY timestamp DESC LIMIT ? OFFSET ?) AS subquery;", activity];
        
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
