//
//  FMDatabase+Additions.h
//  Miyo
//
//  Created by Matt Donnelly on 16/02/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import "FMDatabase.h"

@interface FMDatabase (Additions)

- (void)executeUpdateFromFileWithPath:(NSString *)path;

@end
