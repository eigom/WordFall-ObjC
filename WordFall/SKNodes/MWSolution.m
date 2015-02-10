//
//  MWSolution.m
//  WordFall
//
//  Created by eigo on 10/02/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWSolution.h"
#import "MWSolutionLetter.h"
#import "MWSolutionLetters.h"

@implementation MWSolution

- (id)init
{
    if ((self = [super init])) {
        letters = [[MWSolutionLetters alloc] init];
    }
    
    return self;
}

- (void)setWord:(MWWord *)word animated:(BOOL)animated
{
    _word = word;
    
    // add or remove letter boxes to/from existing (beginning or end), clear existing boxes
}

- (void)revealLetter:(NSString *)letter animated:(BOOL)animated
{
    MWSolutionLetter *nextLetter = [letters nextAvailableLetter];
    [nextLetter setLetter:letter animated:animated];
    
    //
    // check if word formed
    //
    if (![letters hasMoreLetters]) {
        self.wordFormed(letters.word);
    }
}

@end
