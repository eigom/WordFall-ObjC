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
#import "MWNextWordNode.h"
#import "MWPurchaseNode.h"
#import "MWSolveWordNode.h"
#import "Random.h"
#import "MWPurchaseManager.h"

static CFTimeInterval const kSolvingTime = 60.0;
static CFTimeInterval const kPullbackStreamDuration = 1.5;
static CFTimeInterval const kRemoveStreamDuration = 1.5;
static CFTimeInterval const kPresentDefinitionDuration = 1.0;
static CFTimeInterval const kDismissDefinitionDuration = 1.0;
static CFTimeInterval const kSetupSolutionDuration = 1.0;
static CFTimeInterval const kClearSolutionDuration = 1.0;
static CFTimeInterval const kRevealLetterDuration = 1.0;

static NSUInteger const kPhoneSolutionLetterSize = 30.0;
static NSUInteger const kPadSolutionLetterSize = 40.0;

@implementation GameScene

#pragma Game

- (void)playWithNextWord
{
    //
    // pullback active streams
    //
    [self pullbackStreamsWithDuration:kPullbackStreamDuration];
    
    //
    // dismiss definition
    //
    [self dismissDefinitionWithDuration:kDismissDefinitionDuration];
    
    //
    // setup scene with new word
    //
    SKAction *setupWithNextWord = [SKAction runBlock:^{
        word = [[MWWordManager sharedManager] nextWordWithMaxLenght:maxLetterCount];
        
        [self setupSolutionWithDuration:kSetupSolutionDuration];
        [self startStreamsWithDuration:kSolvingTime forDistance:maxStreamDistance];
    }];
    
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:kPullbackStreamDuration], setupWithNextWord]]];
}

#pragma Streams

- (void)startStreamsWithDuration:(CFTimeInterval)duration forDistance:(CGFloat)distance
{
    const CGFloat kMinStartupMovementDistance = self.frame.size.height - (distance * 0.1);
    const CGFloat kMaxStartupMovementDistance = self.frame.size.height - (distance * 0.5);
    
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
            //
            // check if next word
            //
            if ([word isNextLetter:node.letter]) {
                //
                // set letter
                //
                NSUInteger index = [word setNextLetter:node.letter];
                [[self solution] revealLetter:node.letter atIndex:index withDuration:kRevealLetterDuration];
                
                //
                // remove stream
                //
                [node removeWithDuration:kRemoveStreamDuration];
            }
        }];
        
        //
        // handle stream end
        //
        [node setStreamEndReached:^(MWStreamNode *node){
            //
            // reveal letter
            //
             NSUInteger index = [word revealLetter:node.letter];
            [[self solution] revealLetter:node.letter atIndex:index withDuration:kRevealLetterDuration];
            
            //
            // check if need to reveal definition
            //
            if (word.shouldRevealDefinition) {
                [word keepFirstSolution]; // pick first partially matching word as solution
                [self presentDefinitionWithDuration:kPresentDefinitionDuration];
            }
            
            //
            // remove stream
            //
            [node removeWithDuration:kRemoveStreamDuration];
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
    if (![self definition].isDefinitionPresented) {
        [[self definition] presentDefinitionOfWord:word.solutionWord withDuration:duration];
    }
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

- (MWSolutionNode *)solution
{
    return (MWSolutionNode *)[self childNodeWithName:@"solution"];
}

#pragma Scene

- (void)didMoveToView:(SKView *)view
{
    //
    // add background image
    //
    //[self addBackgroundNode];
    
    //
    // max falling distance, letter reveal level
    //
    maxStreamDistance = self.frame.size.height * 0.6;
    
    //
    // solution area
    //
    CGFloat solutionAreaWidth = floor(self.frame.size.width / [self solutionLetterSize]) * [self solutionLetterSize] - 4*[self solutionLetterSize]; // left/right gap of 4 letter sizes
    solutionAreaFrame = CGRectMake((self.frame.size.width - solutionAreaWidth) / 2.0, 0.0, solutionAreaWidth, [self solutionLetterSize]);
    
    [self addSolutionArea];
    
    //
    // max word lengths that can fit on screen
    //
    maxLetterCount = solutionAreaFrame.size.width / [self solutionLetterSize];
    
    //
    // draw reveal line
    //
    [self addRevealLineNode];
    
    //
    // purchase/solve node
    //
    if ([MWPurchaseManager sharedManager].isPurchased) {
        [self addSolveNode];
    } else {
        [self addPurchaseNode];
    }
    
    //
    // next word
    //
    [self addNextWordNode];
}

- (void)addBackgroundNode
{
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
    [self addChild:background];
}

- (void)addSolutionArea
{
    MWSolutionNode *solutionNode = [[MWSolutionNode alloc] initWithFrame:solutionAreaFrame];
    [self addChild:solutionNode];
}

- (void)addPurchaseNode
{
    MWPurchaseNode *purchaseNode = [[MWPurchaseNode alloc] initWithFrame:CGRectMake(0.0, 0.0, solutionAreaFrame.origin.x, solutionAreaFrame.size.height)];
    [purchaseNode setNodeTouched:^(MWPurchaseNode *node){
        
    }];
    [self addChild:purchaseNode];
}

- (void)addSolveNode
{
    MWSolveWordNode *solveNode = [[MWSolveWordNode alloc] initWithFrame:CGRectMake(0.0, 0.0, solutionAreaFrame.origin.x, solutionAreaFrame.size.height)];
    [solveNode setNodeTouched:^(MWSolveWordNode *node){
        
    }];
    [self addChild:solveNode];
}

- (void)addNextWordNode
{
    MWNextWordNode *nextWordNode = [[MWNextWordNode alloc] initWithFrame:CGRectMake(solutionAreaFrame.origin.x+solutionAreaFrame.size.width, 0.0, self.frame.size.width - (solutionAreaFrame.origin.x+solutionAreaFrame.size.width), solutionAreaFrame.size.height)];
    [nextWordNode setNodeTouched:^(MWNextWordNode *node){
        [self playWithNextWord];
    }];
    [self addChild:nextWordNode];
}

- (void)addRevealLineNode
{
    UIBezierPath *path=[UIBezierPath bezierPath];
    CGPoint point1 = CGPointMake(0.0, self.frame.size.height - maxStreamDistance);
    CGPoint point2 = CGPointMake(self.frame.size.width, self.frame.size.height - maxStreamDistance);
    [path moveToPoint:point1];
    [path addLineToPoint:point2];
    
    CGFloat pattern[2];
    pattern[0] = 6.0;
    pattern[1] = 6.0;
    CGPathRef dashed = CGPathCreateCopyByDashingPath([path CGPath], NULL, 0, pattern, 2);
    
    SKShapeNode *node = [SKShapeNode node];
    node.path = dashed;
    node.fillColor = [UIColor yellowColor];
    node.lineWidth = 1.0;
    //node.glowWidth = 0.5;
    [self addChild:node];
    
    CGPathRelease(dashed);
}

- (CGFloat)solutionLetterSize
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return kPadSolutionLetterSize;
    } else {
        return kPhoneSolutionLetterSize;
    }
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
