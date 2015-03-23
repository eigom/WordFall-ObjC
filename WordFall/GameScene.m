//
//  GameScene.m
//  WordFall
//
//  Created by eigo on 26/01/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "GameScene.h"
#import "MWWordManager.h"
#import "MWWord.h"
#import "MWSolutionNode.h"
#import "MWStreamNode.h"

static NSTimeInterval const kSolvingTime = 60.0;
static NSTimeInterval const kPullbackStreamsDuration = 1.5;
static NSTimeInterval const kPresentDefinitionDuration = 1.0;
static NSTimeInterval const kDismissDefinitionDuration = 1.0;
static NSTimeInterval const kSetupSolutionDuration = 1.0;
static NSTimeInterval const kClearSolutionDuration = 1.0;

@implementation GameScene

#pragma Game

- (void)playWithNextWordAnimated:(BOOL)animated
{
    //
    // pullback active streams
    //
    [self pullbackStreamsWithDuration:kPullbackStreamsDuration];
    
    //
    // dismiss definition
    //
    [self dismissDefinitionWithDuration:kDismissDefinitionDuration];
    
    //
    // clear solution
    //
    [self clearSolutionWithDuration:kClearSolutionDuration];
    
    //
    // setup scene with new word
    //
    SKAction *delay = [SKAction waitForDuration:kPullbackStreamsDuration];
    SKAction *setupWithNextWord = [SKAction runBlock:^{
        word = [[MWWordManager sharedManager] nextWord];
        
        [self setupSolutionWithDuration:kSetupSolutionDuration];
        [self startStreamsWithDuration:kSolvingTime forDistance:maxStreamDistance];
    }];
    
    [self runAction:[SKAction sequence:@[delay, setupWithNextWord]]];
}

#pragma Streams

- (void)startStreamsWithDuration:(CFTimeInterval)duration forDistance:(CGFloat)distance
{
    for (NSString *letter in [word shuffledLetters]) {
        MWStreamNode *node = [[MWStreamNode alloc] initWithLetter:letter inFrame:CGRectZero];
        
        // TODO setup velocities/distances
        
        [node setStreamTouched:^(MWStreamNode *node){
            //TODO
        }];
        
        [node setStreamEndReached:^(MWStreamNode *node){
            //TODO
        }];
        
        [node startFall];
    }
}

- (void)pullbackStreamsWithDuration:(CFTimeInterval)duration
{
    for (MWStreamNode *node in [self streams]) {
        [node pullbackWithDuration:duration];
    }
}

- (NSArray *)streams
{
    NSMutableArray *nodes = [NSMutableArray array];
    
    [self enumerateChildNodesWithName:@"stream" usingBlock:^(SKNode *node, BOOL *stop) {
        [nodes addObject:node];
    }];
    
    return nodes;
}

#pragma Definition

- (void)presentDefinitionWithDuration:(CFTimeInterval)duration
{
    
}

- (void)dismissDefinitionWithDuration:(CFTimeInterval)duration
{
    
}

#pragma Solution

- (void)setupSolutionWithDuration:(CFTimeInterval)duration
{
    
}

- (void)clearSolutionWithDuration:(CFTimeInterval)duration
{
    
}

#pragma Scene

- (void)didMoveToView:(SKView *)view
{
    /* Setup scene */
    
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
    [self addChild:background];
    
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    myLabel.text = word.word;
    myLabel.fontSize = 65;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    
    [self addChild:myLabel];
    
    //
    // max falling distance, letter reveal level
    //
    maxStreamDistance = (self.frame.origin.y - self.frame.size.height) * 0.7;
    
    // add definitions label
    // determine solution node width and max letters it can hold,
    // skip words that won't fit there
}

/*- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
    }
}*/

- (void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
}

@end
