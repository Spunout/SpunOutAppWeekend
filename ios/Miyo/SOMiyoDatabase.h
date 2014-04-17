//
//  SODatabaseQueue.h
//  Miyo
//
//  Created by Matt Donnelly on 16/02/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import <FMDB/FMDatabaseQueue.h>

@interface SOMiyoDatabase : FMDatabaseQueue

+ (SOMiyoDatabase *)sharedInstance;

- (void)insertOrUpdateMood:(NSString*)activity earnedPoints:(NSNumber*)earnedPoints tag:(NSUInteger)tag mood:(NSInteger)mood;

- (NSArray *)getLastSelectedActivites;
- (NSInteger)getCountForActivity:(NSString *)activity fromDay:(NSInteger)fromDay toDay:(NSInteger)toDay;
- (NSMutableArray*)getDaysData:(NSString *)activity fromDay:(NSInteger)fromDay toDay:(NSInteger)toDay;

- (NSInteger)getCurrentLifetimePoints;

- (NSDate *)lastUpdateDate;


@end
