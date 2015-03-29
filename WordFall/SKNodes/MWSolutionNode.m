//
//  MWSolutionNode.m
//  WordFall
//
//  Created by eigo on 10/02/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWSolutionNode.h"
#import "MWSolutionLetterNode.h"

@implementation MWSolutionNode

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super init])) {
        letterNodes = [NSMutableArray array];
        visibleLetterNodes = [NSMutableArray array];
        
        //
        // create nodes
        //
        for (int i = 0; i < frame.size.width/frame.size.height; i++) {
            MWSolutionLetterNode *letterNode = [[MWSolutionLetterNode alloc] initWithFrame:CGRectMake(frame.origin.x + i*frame.size.height, frame.origin.y, frame.size.height, frame.size.height)];
            [letterNodes addObject:letterNode];
            
            [self addChild:letterNode];
        }
    }
    
    return self;
}

- (void)setupForWordWithLetterCount:(NSInteger)letterCount withDuration:(CFTimeInterval)duration
{
    [visibleLetterNodes removeAllObjects];
    
    //
    // create solution letter nodes, set name to letter index
    // clear boxes
    // show/hide boxes from beginning/end to accommodate new word length
    //
    NSUInteger startIndex = (letterNodes.count - letterCount) / 2;
    
    for (int i = 0; i < letterNodes.count; i++) {
        MWSolutionLetterNode *letterNode = [letterNodes objectAtIndex:i];
        [letterNode clearLetterWithDuration:duration];
        
        if (i < startIndex || i >= startIndex+letterCount) {
            if (letterNode.visible) {
                [letterNode setVisible:NO withDuration:duration];
            }
        } else {
            if (!letterNode.visible) {
                [letterNode setVisible:YES withDuration:duration];
                [visibleLetterNodes addObject:letterNode];
            }
        }
    }
}

- (void)setupWithPartialSolution:(NSString *)solution placeholder:(NSString *)placeholder withDuration:(CFTimeInterval)duration
{
    [self setupForWordWithLetterCount:solution.length withDuration:duration];
    
    SKAction *wait = [SKAction waitForDuration:duration];
    SKAction *setLetters = [SKAction runBlock:^{
        for (int i = 0; i < solution.length; i++) {
            NSString *letter = [solution substringWithRange:NSMakeRange(i, 1)];
            MWSolutionLetterNode *letterNode = [visibleLetterNodes objectAtIndex:i];
            
            [letterNode setLetter:letter withDuration:duration];
        }
    }];
    
    [self runAction:[SKAction sequence:@[wait, setLetters]]];
}

- (void)revealLetter:(NSString *)letter atIndex:(NSInteger)index withDuration:(CFTimeInterval)duration
{
    MWSolutionLetterNode *node = [visibleLetterNodes objectAtIndex:index];
    [node setLetter:letter withDuration:duration];
}

- (void)clearLettersWithDuration:(CFTimeInterval)duration
{
    for (MWSolutionLetterNode *letterNode in visibleLetterNodes) {
        [letterNode clearLetterWithDuration:duration];
    }
    
    [visibleLetterNodes removeAllObjects];
}

@end
