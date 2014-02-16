//
//  SODatabaseQueue.m
//  Miyo
//
//  Created by Matt Donnelly on 16/02/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import "SOMiyoDatabase.h"
#import "SOAppDelegate.h"

#import <FMDB/FMDatabase.h>

static NSString *const kSODatabaseName = @"miyo.db";

@implementation SOMiyoDatabase

+ (SOMiyoDatabase *)sharedInstance {
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

@end
