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

- (void)insertOrUpdateMood:(NSNumber*)earnedPoints tag:(NSUInteger)tag mood:(NSInteger)mood lifetime:(NSInteger)lifetime
{
    __block NSNumber* points;
    
    [self inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *lastResultSet = [db executeQuery:@"SELECT * FROM data ORDER BY timestamp DESC"];
        
        NSNumber *lifetimePointsTotal;
        NSArray *activities = @[@"eat", @"sleep", @"exercise", @"learn", @"connect", @"play"];
        
        NSDate *lastTimestamp = ([lastResultSet next]) ? [lastResultSet dateForColumn:@"timestamp"] : [NSDate dateWithTimeIntervalSince1970:1297776817];
        
        if ([lastTimestamp isToday]) {

            NSDate *lastTimestamp = [lastResultSet dateForColumn:@"timestamp"];
                                               
            lifetimePointsTotal = [[NSNumber alloc] initWithLong:[lastResultSet longForColumn:@"lifetime_points"] + [earnedPoints longValue]];
            
            points = ([earnedPoints longValue] < 0) ? [NSNumber numberWithInt:0] : earnedPoints;
            
            if ([lastTimestamp isToday]) {
                NSString *query = [NSString stringWithFormat:@"UPDATE data SET %@ = %ld, lifetime_points = %ld, mood = %ld WHERE timestamp = ?", activities[tag], [points longValue], [lifetimePointsTotal longValue], [[NSNumber numberWithInteger:mood] longValue]];
                *rollback = (![db executeUpdate:query, lastTimestamp]) ? YES : *rollback;
            }
            
        } else {
           
            lifetimePointsTotal = [[NSNumber alloc] initWithLong:([earnedPoints longValue]+lifetime)];
            
            NSMutableArray *arguments = [[NSMutableArray alloc] initWithArray:@[[NSNumber numberWithInteger:mood], [NSNumber numberWithLong:0], [NSNumber numberWithLong:0], [NSNumber numberWithLong:0], [NSNumber numberWithLong:0], [NSNumber numberWithLong:0], [NSNumber numberWithLong:0], [NSDate date], lifetimePointsTotal ] ];
            
            [arguments replaceObjectAtIndex:tag+1 withObject:[[NSNumber alloc] initWithLong:[earnedPoints longValue]]];
            
            *rollback = (![db executeUpdate:@"INSERT INTO data VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)" withArgumentsInArray:arguments]) ? YES : *rollback;

        }
        
        [lastResultSet close];

    }];
}

-(NSInteger)getTodaysPointsForActivity:(NSInteger)tag
{
    __block NSInteger points;
    
    
    
    [self inDatabase:^(FMDatabase *db) {
        
        NSArray *activities = @[@"eat", @"sleep", @"exercise", @"learn", @"connect", @"play"];
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM data ORDER BY timestamp DESC"];
        FMResultSet *lastResultSet = [db executeQuery:query];
        
        if ([lastResultSet next])
        {
            NSDate *lastTimestamp = [lastResultSet dateForColumn:@"timestamp"];
            
            if ([lastTimestamp isToday])
            {
                points = [lastResultSet longForColumnIndex:[lastResultSet columnIndexForName:activities[tag]]];
            }
        }
        
        [lastResultSet close];
    }];

    return points;
}

- (NSArray *)getLastSelectedActivites
{
    __block NSMutableArray *selectedActivites = nil;
    
    [self inDatabase:^(FMDatabase *db) {
        FMResultSet *lastResultSet = [db executeQuery:@"SELECT * FROM data ORDER BY timestamp DESC LIMIT 1"];
    
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
    __block NSInteger index;
    
    for (int i = 0; i < toDay; i++)
    {
        NSNumber *zero = [[NSNumber alloc] initWithInteger:0];
        [days addObject:zero];
    }
    
    [self inDatabase:^(FMDatabase *db) {
        
        NSString *query = [NSString stringWithFormat:@"SELECT timestamp,eat,sleep,exercise,learn,connect,play,mood FROM data ORDER BY timestamp DESC LIMIT %ld OFFSET %ld", (long)toDay, (long)fromDay];
        
        FMResultSet *resultSet = [db executeQuery:query];
        
        int counter = 0;
        
        while ([resultSet next])
        {
            
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[resultSet doubleForColumnIndex:0]];
            
            NSDateComponents *components = [calendar components:unitFlags fromDate:date toDate:lastDate options:0];
            daysBetween = [components day];
            
            if (daysBetween == 0 && ![date isToday])
            {
                daysBetween = 1;
            }
            
            totalActivities = ([activity length] == 0) ? [resultSet longForColumn:@"mood"] : [resultSet longForColumn:activity];
            
            counter += daysBetween;
            
            if (counter < [days count])
            {
                [days replaceObjectAtIndex:counter withObject:[[NSNumber alloc] initWithInteger:totalActivities]];
            }
            
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
        NSString *query = [NSString stringWithFormat:@"SELECT COUNT(*) FROM (SELECT timestamp FROM data WHERE %@ = 1 ORDER BY timestamp DESC LIMIT ? OFFSET ?) AS subquery;", activity];
        
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
    __block NSInteger lifetimePoints = 0;
    
    [self inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:@"SELECT lifetime_points FROM data ORDER BY timestamp DESC LIMIT 1;"];
        
        if ([resultSet next]) {
            lifetimePoints = [resultSet longForColumnIndex:0];
        }
        
        [resultSet close];
    }];
    
    return lifetimePoints;
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
