//
//  MWSolutionNode.h
//  WordFall
//
//  Created by eigo on 10/02/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class MWObjects;

@interface MWSolutionNode : SKNode {
@private
    NSMutableArray *letterNodes;
    NSMutableArray *visibleLetterNodes;
}

- (id)initWithFrame:(CGRect)frame;

- (void)setupForWordWithLetterCount:(NSInteger)letterCount withDuration:(CFTimeInterval)duration;
- (void)setupWithPartialSolution:(NSString *)solution placeholder:(NSString *)placeholder withDuration:(CFTimeInterval)duration;
- (void)revealLetter:(NSString *)letter atIndex:(NSInteger)index withDuration:(CFTimeInterval)duration withSound:(SKAction *)soundAction;
- (void)revealWord:(NSString *)word withDuration:(CFTimeInterval)duration withSound:(SKAction *)soundAction;
- (void)clearLettersWithDuration:(CFTimeInterval)duration;

@end
