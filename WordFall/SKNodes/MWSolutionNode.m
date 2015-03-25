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
        letterNodes = [NSMutableArray array];
        visibleLetterNodes = [NSMutableArray array];
        
        //TODO create nodes, add to array
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

- (void)revealLetter:(NSString *)letter atIndex:(NSInteger)index withDuration:(CFTimeInterval)duration
{
    MWSolutionLetterNode *node = (MWSolutionLetterNode *)[self childNodeWithName:[NSString stringWithFormat:@"%d", index]];
    [node setLetter:letter withDuration:duration];
}

/*- (void)clearWithDuration:(CFTimeInterval)duration
{
    for (MWSolutionLetterNode *letterNode in letterNodes) {
        [letterNode clearLetterWithDuration:duration];
    }
}*/

@end
