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

@end
