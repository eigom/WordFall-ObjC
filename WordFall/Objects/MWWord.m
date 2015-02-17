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

static NSString *kPlaceholder = @"*";

@implementation MWWord

@synthesize word;
@synthesize wordID;
@synthesize alternativeWords;
@synthesize definitions;

- (id)initWithString:(NSString *)aWord
{
    if ((self = [super init])) {
        word = aWord;
        
        solution = [NSMutableString stringWithString:[@"" stringByPaddingToLength:word.length withString:kPlaceholder startingAtIndex:0]];
        isSolution = YES;
    }
    
    return self;
}

- (id)initFromResultSet:(FMResultSet *)rs
{
    if ((self = [self initWithString:[rs stringForColumn:@"word"]])) {
        wordID = [NSNumber numberWithLongLong:[rs unsignedLongLongIntForColumn:@"id"]];
    }
    
    return self;
}

- (void)revealLetter:(NSString *)letter
{
    for (MWWord *aWord in [self partialSolutions]) {
        
    }
}

- (NSArray *)partialSolutions
{
    NSMutableArray *solutions = [NSMutableArray array];
    
    if ([self isPartialSolution:solution]) {
        [solutions addObject:self];
    }
    
    for (MWWord *aWord in alternativeWords.items) {
        if ([aWord isPartialSolution:solution]) {
            [solutions addObject:aWord];
        }
    }
    
    return solutions;
}

- (BOOL)isPartialSolution:(NSString *)aSolution
{
    BOOL isPartialSolution = YES;
    
    for (int i = 0; i < solution.length; i++) {
        if (![[aSolution substringWithRange:NSMakeRange(i, 1)] isEqualToString:kPlaceholder]) {
            if (![[aSolution substringWithRange:NSMakeRange(i, 1)] isEqualToString:[self.word substringWithRange:NSMakeRange(i, 1)]]) {
                isPartialSolution = NO;
                break;
            }
        }
    }
    
    return isPartialSolution;
}

- (BOOL)canAppendSolutionLetter:(NSString *)letter
{
    BOOL canAppend = NO;
    
    NSInteger nextIndex = [self nextAvailableSolutionLetterIndex];
    
    for (MWWord *aWord in [self partialSolutions]) {
        if ([[aWord.word substringWithRange:NSMakeRange(nextIndex, 1)] isEqualToString:letter]) {
            canAppend = YES;
            break;
        }
    }
    
    return canAppend;
}

- (void)appendSolutionLetter:(NSString *)letter
{
    [solution replaceCharactersInRange:NSMakeRange([self nextAvailableSolutionLetterIndex], 1) withString:letter];
}

- (NSInteger)nextAvailableSolutionLetterIndex
{
    NSInteger index = -1;
    
    for (int i = 0; i < solution.length; i++) {
        if ([[solution substringWithRange:NSMakeRange(i, 0)] isEqualToString:kPlaceholder]) {
            index = i;
            break;
        }
    }
    
    return index;
}

/*- (BOOL)hasWord:(NSString *)partialWord withAppendedLetter:(NSString *)letter
{
    return [self hasWord:[partialWord stringByAppendingString:letter]];
}*/

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
