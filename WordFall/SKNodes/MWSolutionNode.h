//
//  MWSolutionNode.h
//  WordFall
//
//  Created by eigo on 10/02/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class MWWord;
@class MWObjects;

@interface MWSolutionNode : SKNode {
@private
    MWObjects *letterNodes;
}

- (void)setupForWordWithLetterCount:(NSInteger)letterCount animated:(BOOL)animated;
- (void)revealLetter:(NSString *)letter atIndex:(NSInteger)index animated:(BOOL)animated;

@end
