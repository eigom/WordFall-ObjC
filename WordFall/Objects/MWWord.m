//
//  MWWord.m
//  WordFall
//
//  Created by eigo on 06/02/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWWord.h"
#import "MWWords.h"
#import "MWDefinitions.h"

@implementation MWWord

@synthesize word;
@synthesize wordID;
@synthesize alternativeWords;
@synthesize definitions;

- (id)initWithString:(NSString *)aWord
{
    if ((self = [super init])) {
        word = aWord;
    }
    
    return self;
}

- (id)initFromResultSet:(FMResultSet *)rs
{
    if ((self = [super initFromResultSet:rs])) {
        wordID = [NSNumber numberWithLongLong:[rs unsignedLongLongIntForColumn:@"id"]];
        word = [rs stringForColumn:@"word"];
    }
    
    return self;
}

- (BOOL)hasWord:(NSString *)partialWord withAppendedLetter:(NSString *)letter
{
    return [self hasWord:[partialWord stringByAppendingString:letter]];
}

- (BOOL)hasWord:(NSString *)aWord
{
    return ([self wordForWord:aWord] != nil);
}

- (MWWord *)wordForWord:(NSString *)aWord
{
    MWWord *foundWord = nil;
    
    if ([word.lowercaseString isEqual:aWord.lowercaseString]) {
        foundWord = self;
    } else {
        for (MWWord *altWord in alternativeWords.items) {
            if ([altWord.word.lowercaseString isEqual:aWord.lowercaseString]) {
                foundWord = altWord;
                break;
            }
        }
    }
    
    return foundWord;
}

@end
