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
static NSUInteger const kRevealDefinitionLevel = 0.5;

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
        _isSolution = YES;
        
        revealedLetterCount = 0;
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

- (NSArray *)shuffledLetters
{
    NSMutableString *shuffledLetters = [[NSMutableString alloc] initWithString:self.word];
    
    for (int i = 0; i < shuffledLetters.length; i++) {
        NSUInteger j = arc4random_uniform(shuffledLetters.length);
        
        NSString *temp = [shuffledLetters substringWithRange:NSMakeRange(i, 1)];
        [shuffledLetters replaceCharactersInRange:NSMakeRange(i, 1) withString:[shuffledLetters substringWithRange:NSMakeRange(j, 1)]];
        [shuffledLetters replaceCharactersInRange:NSMakeRange(j, 1) withString:temp];
    }
    
    return [shuffledLetters componentsSeparatedByString:@""];
}

- (NSUInteger)letterCount
{
    return word.length;
}

- (BOOL)isNextLetter:(NSString *)letter
{
    BOOL isNext = NO;
    NSUInteger index = [solution rangeOfString:kPlaceholder].location;
    
    for (MWWord *aWord in [self solutionWords]) {
        if ([[aWord.word substringWithRange:NSMakeRange(index, 0)] isEqualToString:letter]) {
            isNext = YES;
            break;
        }
    }
    
    return isNext;
}

- (NSUInteger)setNextLetter:(NSString *)letter
{
    NSUInteger index = [solution rangeOfString:kPlaceholder].location;
    [solution replaceCharactersInRange:NSMakeRange(index, 1) withString:letter];
    
    [self filterSolutions];
    
    return index;
}

- (BOOL)shouldRevealDefinition
{
    return (1.0 / self.letterCount) * revealedLetterCount >= kRevealDefinitionLevel;
}

- (void)keepFirstSolution
{
    BOOL found = NO;
    NSArray *solutionWords = [self solutionWords];
    
    //
    // set first partially matching word as solution, clear remaining
    //
    for (int i = 0; i <= [solutionWords count]; i++) {
        MWWord *aWord = [solutionWords objectAtIndex:i];
        
        if (!found && aWord.isSolution) {
            [solution setString:aWord.word];
            found = YES;
        } else {
            aWord.isSolution = NO;
        }
    }
}

- (NSUInteger)revealLetter:(NSString *)letter
{
    
    revealedLetterCount++;
    
    [self filterSolutions];
}

- (BOOL)isSolved
{
    return ([solution rangeOfString:kPlaceholder].location == NSNotFound);
}

- (MWWord *)solutionWord
{
    MWWord *solutionWord = nil;
    
    //
    // find first solution
    //
    for (MWWord *aWord in [self solutionWords]) {
        if (aWord.isSolution) {
            solutionWord = aWord;
            break;
        }
    }
    
    return solutionWord;
}

- (void)filterSolutions
{
    
}

- (NSArray *)solutionWords
{
    NSMutableArray *solutions = [NSMutableArray array];
    
    if (self.isSolution) {
        [solutions addObject:self];
    }
    
    for (MWWord *aWord in alternativeWords.items) {
        if (aWord.isSolution) {
            [solutions addObject:aWord];
        }
    }
    
    return solutions;
}

/*- (NSArray *)partialSolutions
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

- (BOOL)isSolved
{
    return ([solution rangeOfString:kPlaceholder].location == NSNotFound);
}

- (MWWord *)solutionWord
{
    return [[self partialSolutions] firstObject];
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

- (NSUInteger)letterCount
{
    return word.length;
}*/

@end
