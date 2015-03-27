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
    NSMutableString *shuffeledLetters = [[NSMutableString alloc] initWithString:self.word];
    
    for (int i = 0; i < shuffeledLetters.length; i++) {
        u_int32_t j = arc4random_uniform((u_int32_t)shuffeledLetters.length);
        
        NSString *temp = [shuffeledLetters substringWithRange:NSMakeRange(i, 1)];
        [shuffeledLetters replaceCharactersInRange:NSMakeRange(i, 1) withString:[shuffeledLetters substringWithRange:NSMakeRange(j, 1)]];
        [shuffeledLetters replaceCharactersInRange:NSMakeRange(j, 1) withString:temp];
    }
    
    NSMutableArray *shuffeledArray = [NSMutableArray array];
    
    for (int i = 0; i < shuffeledLetters.length; i++) {
        [shuffeledArray addObject:[shuffeledLetters substringWithRange:NSMakeRange(i, 1)]];
    }
    
    return shuffeledArray;
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
        if ([[aWord.word substringWithRange:NSMakeRange(index, 1)] isEqualToString:letter]) {
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
    for (int i = 0; i < [solutionWords count]; i++) {
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
    NSUInteger index = 0;
    
    //TODO
    
    revealedLetterCount++;
    
    [self filterSolutions];
    
    return index;
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
    for (MWWord *solutionWord in [self solutionWords]) {
        solutionWord.isSolution = [solutionWord matchesSolution:solution];
    }
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

- (BOOL)matchesSolution:(NSString *)aSolution
{
    BOOL matches = YES;
    
    for (int i = 0; i < aSolution.length; i++) {
        NSString *solutionLetter = [solution substringWithRange:NSMakeRange(i, 1)];
        
        if (![solutionLetter isEqualToString:kPlaceholder]) {
            NSString *wordLetter = [word substringWithRange:NSMakeRange(i, 1)];
            
            if (![solutionLetter isEqualToString:wordLetter]) {
                matches = NO;
                break;
            }
        }
    }
    
    return matches;
}

@end
