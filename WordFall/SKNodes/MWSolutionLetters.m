//
//  MWSolutionLetters.m
//  WordFall
//
//  Created by eigo on 10/02/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWSolutionLetters.h"
#import "MWSolutionLetter.h"

@implementation MWSolutionLetters

+ (MWSolutionLetters *)solutionLettersOfCount:(NSUInteger)count
{
    MWSolutionLetters *letters = [[MWSolutionLetters alloc] init];
    
    for (int i = 0; i < count; i++) {
        [letters addItem:[[MWSolutionLetter alloc] init]];
    }
    
    return letters;
}

- (MWSolutionLetter *)nextAvailableLetter
{
    MWSolutionLetter *nextLetter = nil;
    
    for (MWSolutionLetter *letter in items) {
        if (letter.letter == nil) {
            nextLetter = letter;
            break;
        }
    }
    
    return nextLetter;
}

- (BOOL)hasMoreLetters
{
    BOOL has = NO;
    
    for (MWSolutionLetter *letter in items) {
        if (letter.letter == nil) {
            has = YES;
            break;
        }
    }
    
    return has;
}

- (void)clearAllLettersAnimated:(BOOL)animated
{
    for (MWSolutionLetter *letter in items) {
        [letter clearLetterAnimated:animated];
    }
}

- (NSString *)word
{
    NSMutableString *word = [NSMutableString string];
    
    for (MWSolutionLetter *letter in items) {
        if (letter.letter) {
            [word appendString:letter.letter];
        }
    }
    
    return word;
}

@end
