//
//  MWSolutionLetters.h
//  WordFall
//
//  Created by eigo on 10/02/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWObjects.h"

@class MWSolutionLetter;

@interface MWSolutionLetters : MWObjects

@property (nonatomic, readonly) NSString *word;

- (MWSolutionLetter *)nextAvailableLetter;
- (BOOL)hasMoreLetters;

@end
