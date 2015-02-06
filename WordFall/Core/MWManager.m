//
//  MWManager.m
//  WordFall
//
//  Created by eigo on 06/02/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWManager.h"

@implementation MWManager

#pragma Archiving

- (void)storeObject:(id)object forKey:(NSString *)key
{
    if (object == nil) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[self makeKey:key]];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:object forKey:[self makeKey:key]];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)objectForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:[self makeKey:key]];
}

- (NSString *)makeKey:(NSString *)key
{
    return [NSString stringWithFormat:@"%@.%@", NSStringFromClass([self class]), key];
}

- (NSString *)archivePathForKey:(NSString *)key
{
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [NSString stringWithFormat:@"%@.%@", NSStringFromClass([self class]), key];
    
    return [documents stringByAppendingPathComponent:filename];
}

- (void)archiveObject:(id)object forKey:(NSString *)key
{
    if (object) {
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        
        [archiver encodeObject:object forKey:key];
        [archiver finishEncoding];
        
        [data writeToFile:[self archivePathForKey:key] atomically:YES];
    } else {
        [self removeArchiveWithKey:key];
    }
}

- (id)unarchiveObjectForKey:(NSString *)key
{
    NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:[self archivePathForKey:key]];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    id object = [unarchiver decodeObjectForKey:key];
    
    [unarchiver finishDecoding];
    
    return object;
}

- (void)removeArchiveWithKey:(NSString *)key
{
    NSError *error = nil;
    
    [[NSFileManager defaultManager] removeItemAtPath:[self archivePathForKey:key] error:&error];
    
    if (error) {
        NSLog(@"Error removing current user: %@", error.localizedDescription);
    }
}

@end
