//
//  GameScene.h
//  WordFall
//

//  Copyright (c) 2015 eigo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class MWWord;
@class MWSolutionNode;

@interface GameScene : SKScene {
@private
    MWWord *word;
    CGFloat maxStreamDistance;
    NSUInteger maxLetterCount;
}

@end
