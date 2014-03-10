//
//  FMDatabase+Additions.m
//  Miyo
//
//  Created by Matt Donnelly on 16/02/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import "FMDatabase+Additions.h"

@implementation FMDatabase (Additions)

- (void)executeUpdateFromFileWithPath:(NSString *)path
{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData *data = [handle readDataToEndOfFile];
    [handle closeFile];

    NSString *sql = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *statements = [sql componentsSeparatedByString:@";"];

    [self beginTransaction];

    for (NSString *statement in statements) {
        NSString *trimmedStatement = [statement stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (trimmedStatement && ![trimmedStatement isEqualToString:@""]) {
            [self executeUpdate:trimmedStatement];
        }
    }

    [self commit];
}

@end
