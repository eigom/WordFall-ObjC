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
#import "MWDefinitionNode.h"
#import "Random.h"

static NSTimeInterval const kSolvingTime = 60.0;
static NSTimeInterval const kPullbackStreamsDuration = 1.5;
static NSTimeInterval const kPresentDefinitionDuration = 1.0;
static NSTimeInterval const kDismissDefinitionDuration = 1.0;
static NSTimeInterval const kSetupSolutionDuration = 1.0;
static NSTimeInterval const kClearSolutionDuration = 1.0;

static NSUInteger const kPhoneLetterSize = 30.0;
static NSUInteger const kPadLetterSize = 40.0;

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
    SKAction *setupWithNextWord = [SKAction runBlock:^{
        word = [[MWWordManager sharedManager] nextWordWithMaxLenght:maxWordLength];
        
        [self setupSolutionWithDuration:kSetupSolutionDuration];
        [self startStreamsWithDuration:kSolvingTime forDistance:maxStreamDistance];
    }];
    
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:kPullbackStreamsDuration], setupWithNextWord]]];
}

#pragma Streams

- (void)startStreamsWithDuration:(CFTimeInterval)duration forDistance:(CGFloat)distance
{
    const CGFloat kMinStartupMovementDistance = distance * 0.1;
    const CGFloat kMaxStartupMovementDistance = distance * 0.5;
    
    for (NSString *letter in [word shuffledLetters]) {
        MWStreamNode *node = [[MWStreamNode alloc] initWithLetter:letter inFrame:CGRectZero]; //TODO frame
        
        //
        // setup distances and durations
        //
        node.startupMovementDistance = [Random randomFloatBetween:kMinStartupMovementDistance and:kMaxStartupMovementDistance];
        node.normalMovementDistance = distance - node.startupMovementDistance;
        
        node.startupMovementDuration = (node.startupMovementDistance / distance) * duration;
        node.normalMovementDuration = (node.normalMovementDuration / distance) * duration;
        
        //
        // handle stream touch
        //
        [node setStreamTouched:^(MWStreamNode *node){
            //TODO
            // check if next word, reveal it, check solved
        }];
        
        //
        // handle stream end
        //
        [node setStreamEndReached:^(MWStreamNode *node){
            //TODO
            // reveal letter
            // check if need to reveal definition
            // check if word solved
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
    [[self definition] presentWithDuration:duration];
}

- (void)dismissDefinitionWithDuration:(CFTimeInterval)duration
{
    [[self definition] dismissWithDuration:duration];
}

- (MWDefinitionNode *)definition
{
    return (MWDefinitionNode *)[self childNodeWithName:@"definition"];
}

#pragma Solution

- (void)setupSolutionWithDuration:(CFTimeInterval)duration
{
    [[self solution] setupForWordWithLetterCount:word.letterCount withDuration:duration];
}

- (void)clearSolutionWithDuration:(CFTimeInterval)duration
{
    [[self solution] clearWithDuration:duration];
}

- (MWSolutionNode *)solution
{
    return (MWSolutionNode *)[self childNodeWithName:@"solution"];
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
    
    //
    // max word lengths that can fit on screen
    //
    maxWordLength = floor(self.frame.size.width / kPhoneLetterSize) - 40.0;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        maxWordLength = floor(self.frame.size.width / kPadLetterSize) - 60.0;
    }
    
    // TODO init scene nodes
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
