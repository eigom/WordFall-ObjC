//
//  MWWord.h
//  WordFall
//
//  Created by eigo on 06/02/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWObject.h"

@class MWWords;
@class MWDefinitions;

@interface MWWord : MWObject {
@private
    NSNumber *wordID;
    NSString *word;
    MWWords *alternativeWords;
    MWDefinitions *definitions;
    
    NSUInteger revealedLetterCount;
    NSMutableString *solution;
    BOOL isSolution;
}

@property (nonatomic, readonly) NSNumber *wordID;
@property (nonatomic, readonly) NSString *word;
@property (nonatomic, strong) MWWords *alternativeWords;
@property (nonatomic, strong) MWDefinitions *definitions;

- (id)initWithString:(NSString *)word;

- (NSArray *)shuffledLetters;
- (NSUInteger)letterCount;
- (NSUInteger)revealLetter:(NSString *)letter;
- (BOOL)isNextLetter:(NSString *)letter;
- (NSUInteger)setNextLetter:(NSString *)letter;
- (BOOL)shouldRevealDefinition;
- (void)keepFirstSolution;
- (BOOL)isSolved;
- (MWWord *)solvedWord;


@end
