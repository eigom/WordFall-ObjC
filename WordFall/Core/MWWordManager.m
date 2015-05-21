//
//  MWWordManager.m
//  WordFall
//
//  Created by eigo on 06/02/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWWordManager.h"
#import "MWWord.h"
#import "MWWords.h"
#import "MWDefinitions.h"
#import "MWDBManager.h"

static NSString * const kWordLengthKey = @"kWordLengthKey";

@implementation MWWordManager

+ (MWWordManager *)sharedManager
{
    static id manager = nil;
    static dispatch_once_t onceToken = 0;
    
    dispatch_once(&onceToken, ^{
        manager = [[MWWordManager alloc] init];
    });
    
    return manager;
}

- (id)init
{
    if ((self = [super init])) {
        _wordLength = -1; // all words
        
        NSNumber *wordLength = [[NSUserDefaults standardUserDefaults] objectForKey:kWordLengthKey];
        
        if (wordLength) {
            _wordLength = [wordLength integerValue];
        }
    }
    
    return self;
}

- (MWWord *)nextWord
{
    if (_wordLength == -1) {
        return [[MWDBManager sharedManager] wordWithMaxLength:_maxWordLength limitToLength:NO];
    } else {
        return [[MWDBManager sharedManager] wordWithMaxLength:_wordLength limitToLength:YES];
    }
}

- (void)setWordLength:(NSInteger)wordLength
{
    if (wordLength <= _maxWordLength) {
        _wordLength = wordLength;
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:wordLength] forKey:kWordLengthKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
