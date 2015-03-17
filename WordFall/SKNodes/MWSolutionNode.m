//
//  MWSolutionNode.m
//  WordFall
//
//  Created by eigo on 10/02/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWSolutionNode.h"
#import "MWSolutionLetterNode.h"
#import "MWObjects.h"

@implementation MWSolutionNode

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super init])) {
        letterNodes = [[MWObjects alloc] init];
    }
    
    return self;
}

- (void)setupForWordWithLetterCount:(NSInteger)letterCount animated:(BOOL)animated
{
    // TODO show/hide boxes from beginning/end to accommodate new word length
}

- (void)revealLetter:(NSString *)letter atIndex:(NSInteger)index animated:(BOOL)animated
{
    MWSolutionLetterNode *nextLetter = [letterNodes itemAtIndex:index];
    [nextLetter setLetter:letter animated:animated];
}

@end
