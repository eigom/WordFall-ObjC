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
static const float kRevealDefinitionLevel = 0.5;

@implementation MWWord

@synthesize word;
@synthesize wordID;
@synthesize alternativeWords;
@synthesize definitions;

+ (NSString *)placeholder
{
    return kPlaceholder;
}

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
    NSMutableString *shuffledLetters = [[NSMutableString alloc] initWithString:self.lowercaseWord];
    
    for (int i = 0; i < shuffledLetters.length; i++) {
        u_int32_t j = arc4random_uniform((u_int32_t)shuffledLetters.length);
        
        NSString *temp = [shuffledLetters substringWithRange:NSMakeRange(i, 1)];
        [shuffledLetters replaceCharactersInRange:NSMakeRange(i, 1) withString:[shuffledLetters substringWithRange:NSMakeRange(j, 1)]];
        [shuffledLetters replaceCharactersInRange:NSMakeRange(j, 1) withString:temp];
    }
    
    NSMutableArray *shuffeledArray = [NSMutableArray array];
    
    for (int i = 0; i < shuffledLetters.length; i++) {
        [shuffeledArray addObject:[shuffledLetters substringWithRange:NSMakeRange(i, 1)]];
    }
    
    return shuffeledArray;
}

- (BOOL)isNextLetter:(NSString *)letter
{
    BOOL isNext = NO;
    NSUInteger index = [solution rangeOfString:kPlaceholder].location;
    
    for (MWWord *aWord in [self solutionWords]) {
        if ([[aWord.lowercaseWord substringWithRange:NSMakeRange(index, 1)] isEqualToString:letter]) {
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

- (NSString *)wordLetterAtIndex:(NSUInteger)index
{
    return [word substringWithRange:NSMakeRange(index, 1)];
}

- (BOOL)shouldRevealDefinition
{
    return (1.0 / self.letterCount) * revealedLetterCount >= kRevealDefinitionLevel;
}

- (NSUInteger)revealLetter:(NSString *)letter
{
    NSUInteger index = 0;
    
    //
    // pick first word
    //
    MWWord *firstWord = [[self solutionWords] firstObject];
    
    for (int i = 0; i < solution.length; i++) {
        NSString *wordLetter = [firstWord.lowercaseWord substringWithRange:NSMakeRange(i, 1)];
        NSString *solutionLetter = [solution substringWithRange:NSMakeRange(i, 1)];
        
        if ([solutionLetter isEqualToString:kPlaceholder] && [wordLetter isEqualToString:letter]) {
            [solution replaceCharactersInRange:NSMakeRange(i, 1) withString:letter];
            index = i;
            break;
        }
    }
    
    revealedLetterCount++;
    
    [self filterSolutions];
    
    return index;
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

- (void)filterSolutions
{
    for (MWWord *solutionWord in [self solutionWords]) {
        solutionWord.isSolution = [solutionWord matchesSolution:self.lowercaseSolution];
    }
}

- (BOOL)matchesSolution:(NSString *)aSolution
{
    BOOL matches = YES;
    
    for (int i = 0; i < aSolution.length; i++) {
        NSString *solutionLetter = [self.lowercaseSolution substringWithRange:NSMakeRange(i, 1)];
        
        if (![solutionLetter isEqualToString:kPlaceholder]) {
            NSString *wordLetter = [self.lowercaseWord substringWithRange:NSMakeRange(i, 1)];
            
            if (![solutionLetter isEqualToString:wordLetter]) {
                matches = NO;
                break;
            }
        }
    }
    
    return matches;
}

- (BOOL)isSolved
{
    return ([solution rangeOfString:kPlaceholder].location == NSNotFound);
}

- (MWWord *)solutionWord
{
    return [[self solutionWords] firstObject];
}

- (NSUInteger)letterCount
{
    return word.length;
}

- (NSString *)lowercaseWord
{
    return [word lowercaseString];
}

- (NSString *)lowercaseSolution
{
    return [solution lowercaseString];
}

@end
