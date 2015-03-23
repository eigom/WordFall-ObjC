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
        
    }
    
    return self;
}

- (void)setupForWordWithLetterCount:(NSInteger)letterCount withDuration:(CFTimeInterval)duration
{
    // TODO
    // create solution letter nodes, set name to letter index
    // clear boxes
    // show/hide boxes from beginning/end to accommodate new word length
}

- (void)revealLetter:(NSString *)letter atIndex:(NSInteger)index withDuration:(CFTimeInterval)duration
{
    MWSolutionLetterNode *node = (MWSolutionLetterNode *)[self childNodeWithName:[NSString stringWithFormat:@"%d", index]];
    [node setLetter:letter withDuration:duration];
}

- (void)clearWithDuration:(CFTimeInterval)duration
{
    [self enumerateChildNodesWithName:@"*" usingBlock:^(SKNode *node, BOOL *stop) {
        MWSolutionLetterNode *letterNode = (MWSolutionLetterNode *)node;
        [letterNode removeWithDuration:duration];
    }];
}

@end
