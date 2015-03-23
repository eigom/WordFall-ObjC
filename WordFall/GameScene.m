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
        [self startStreamsWithDuration:kSolvingTime];
    }];
    
    [self runAction:[SKAction sequence:@[delay, setupWithNextWord]]];
}

#pragma Streams

- (void)startStreamsWithDuration:(NSTimeInterval)duration
{
    
}

- (void)pullbackStreamsWithDuration:(NSTimeInterval)duration
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

- (void)presentDefinitionWithDuration:(NSTimeInterval)duration
{
    
}

- (void)dismissDefinitionWithDuration:(NSTimeInterval)duration
{
    
}

#pragma Solution

- (void)setupSolutionWithDuration:(NSTimeInterval)duration
{
    
}

- (void)clearSolutionWithDuration:(NSTimeInterval)duration
{
    
}

#pragma Scene

- (void)didMoveToView:(SKView *)view
{
    /* Setup your scene here */
    
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
    [self addChild:background];
    
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    myLabel.text = word.word;
    myLabel.fontSize = 65;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    
    [self addChild:myLabel];
    
    // add definitions label
    // determine solution node width and max letters it can hold,
    // skip words that won't fit there
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.xScale = 0.5;
        sprite.yScale = 0.5;
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }
}

- (void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
}

@end
