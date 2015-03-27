//
//  DBManager.m
//  WordFall
//
//  Created by eigo on 06/02/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "DBManager.h"
#import "FMDatabaseQueue.h"
#import "FMResultSet.h"
#import "FMDatabase.h"
#import "MWWord.h"
#import "MWWords.h"
#import "MWDefinitions.h"
#import "MWDefinition.h"

static NSString * const kDBName = @"words";

@implementation DBManager

+ (DBManager *)sharedManager
{
    static id manager = nil;
    static dispatch_once_t onceToken = 0;
    
    dispatch_once(&onceToken, ^{
        manager = [[DBManager alloc] init];
    });
    
    return manager;
}

- (id)init
{
    if ((self = [super init])) {
        dbQueue = [FMDatabaseQueue databaseQueueWithPath:[self dbPath]];
    }
    
    return self;
}

- (MWWord *)wordWithMaxLength:(NSUInteger)maxLength
{
    __block MWWord *word = nil;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        while (YES) {
            FMResultSet *maxIDrs = [db executeQuery:@"select word_id from word_length_max_id where length <= ? order by length limit 1", [NSNumber numberWithUnsignedInteger:maxLength]];
            
            if ([maxIDrs next]) {
                NSUInteger maxWordID = [maxIDrs intForColumn:@"word_id"];
                
                NSNumber *wordID = [NSNumber numberWithUnsignedInteger:arc4random_uniform((u_int32_t)maxWordID)];
                
                FMResultSet *rs = [db executeQuery:@"select * from word where id = ? and length(word.word) <= ?", wordID, [NSNumber numberWithUnsignedInteger:maxLength]];
                
                if ([rs next]) {
                    word = [[MWWord alloc] initFromResultSet:rs];
                    break;
                }
            }
        }
    }];
    
    if (word) {
        //
        // get definitions
        //
        word.definitions = [self definitionsForWord:word];
        
        //
        // get alternative words
        //
        word.alternativeWords = [self altWordsForWord:word];
    }
    
    return word;
}

- (MWWord *)wordWithID:(NSNumber *)wordID
{
    __block MWWord *word = nil;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *rs = [db executeQuery:@"select * from word where id = ?", wordID];
        
        if ([rs next]) {
            word = [[MWWord alloc] initFromResultSet:rs];
        }
    }];
    
    if (word) {
        //
        // get definitions
        //
        word.definitions = [self definitionsForWord:word];
        
        //
        // get alternative words
        //
        word.alternativeWords = [self altWordsForWord:word];
    }
    
    return word;
}

- (NSUInteger)wordCount
{
    __block NSUInteger count = 0;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *rs = [db executeQuery:@"select count from word_count"];
        
        if ([rs next]) {
            count = [rs intForColumnIndex:0];
        }
    }];
    
    return count;
}

- (MWDefinitions *)definitionsForWord:(MWWord *)word
{
    __block MWDefinitions *definitions = nil;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *rs = [db executeQuery:@"SELECT * from definition inner join word_definition ON definition.id = word_definition.definition_id WHERE word_definition.word_id = ?", word.wordID];
        definitions = [[MWDefinitions alloc] initFromResultSet:rs];
    }];
    
    return definitions;
}

- (MWWords *)altWordsForWord:(MWWord *)word
{
    __block MWWords *words = nil;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *rs = [db executeQuery:@"select * from word inner join alt_word on word.id = alt_word.word_id WHERE alt_word.word_id = ?", word.wordID];
        words = [[MWWords alloc] initFromResultSet:rs];
    }];
    
    //
    // get definitions
    //
    for (MWWord *word in words.items) {
        word.definitions = [self definitionsForWord:word];
    }
    
    return words;
}

- (NSString *)dbPath
{
    return [[NSBundle mainBundle] pathForResource:kDBName ofType:@"sqlite"];
    //return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:kDBName];
}

@end
