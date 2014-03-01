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

- (void)insertOrUpdateMood:(double)mood activities:(NSArray *)activities earnedPoints:(NSInteger)earnedPoints;

- (NSArray *)getLastSelectedActivites;

- (NSInteger)getCountForActivity:(NSString *)activity overNumberOfDays:(NSInteger)days;
- (NSInteger)getCurrentLifetimePoints;

- (NSDate *)lastUpdateDate;

@end
