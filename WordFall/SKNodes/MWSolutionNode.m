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
        self.zPosition = 10;
        
        letterNodes = [NSMutableArray array];
        visibleLetterNodes = [NSMutableArray array];
        
        //
        // create nodes
        //
        NSLog(@"%@", NSStringFromCGRect(frame));
        for (int i = 0; i < frame.size.width/frame.size.height; i++) {
            MWSolutionLetterNode *letterNode = [[MWSolutionLetterNode alloc] initWithFrame:CGRectIntegral(CGRectMake(frame.origin.x + i*frame.size.height, frame.origin.y, frame.size.height, frame.size.height))];
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
        //[letterNode clearLetterWithDuration:duration];
        
        if (i < startIndex || i >= startIndex+letterCount) {
            [letterNode setVisible:NO withDuration:duration];
        } else {
            [letterNode setVisible:YES withDuration:duration];
            [visibleLetterNodes addObject:letterNode];
        }
    }
}

- (void)setupWithPartialSolution:(NSString *)solution placeholder:(NSString *)placeholder withDuration:(CFTimeInterval)duration
{
    [self setupForWordWithLetterCount:solution.length withDuration:0.0];
    
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

- (void)revealLetter:(NSString *)letter atIndex:(NSInteger)index withDuration:(CFTimeInterval)duration withSound:(SKAction *)soundAction
{
    MWSolutionLetterNode *node = [visibleLetterNodes objectAtIndex:index];
    [node setLetter:letter withDuration:duration];
    
    if (soundAction) {
        [self runAction:soundAction];
    }
}

- (void)revealWord:(NSString *)word withDuration:(CFTimeInterval)duration withSound:(SKAction *)soundAction
{
    for (int i = 0; i < word.length; i++) {
        MWSolutionLetterNode *node = [visibleLetterNodes objectAtIndex:i];
        
        if (node.letter == nil) {
            NSString *letter = [word substringWithRange:NSMakeRange(i, 1)];
            [node setLetter:letter withDuration:duration];
        }
    }
    
    if (soundAction) {
        [self runAction:soundAction];
    }
}

- (void)clearLettersWithDuration:(CFTimeInterval)duration
{
    for (MWSolutionLetterNode *letterNode in visibleLetterNodes) {
        [letterNode clearLetterWithDuration:duration];
    }
    
    [visibleLetterNodes removeAllObjects];
}

@end
