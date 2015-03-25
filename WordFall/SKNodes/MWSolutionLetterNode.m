//
//  MWSolutionLetterNode.m
//  WordFall
//
//  Created by eigo on 10/02/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWSolutionLetterNode.h"

@implementation MWSolutionLetterNode

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super init])) {
        
    }
    
    return self;
}

- (void)setVisible:(BOOL)visible withDuration:(CFTimeInterval)duration
{
    
}

- (void)setLetter:(NSString *)letter withDuration:(CFTimeInterval)duration
{
    _letter = letter;
}

- (void)clearLetterWithDuration:(CFTimeInterval)duration
{
    _letter = nil;
}


@end