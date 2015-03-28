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
static CFTimeInterval const kStreamStartupDuration = 1.0;
static CFTimeInterval const kPullbackStreamDuration = 1.5;
static CFTimeInterval const kRemoveStreamDuration = 0.5;
static CFTimeInterval const kPresentDefinitionDuration = 1.0;
static CFTimeInterval const kDismissDefinitionDuration = 1.0;
static CFTimeInterval const kSetupSolutionDuration = 1.0;
static CFTimeInterval const kRevealLetterDuration = 1.0;

static NSUInteger const kPhoneSolutionLetterSize = 30.0;
static NSUInteger const kPadSolutionLetterSize = 40.0;

static NSString * const kStreamNodeName = @"stream";
static NSString * const kSolutionNodeName = @"solution";
static NSString * const kDefinitionNodeName = @"definition";
static NSString * const kPurchaseNodeName = @"purchase";

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
        
        [self presentDefinitionWithDuration:1];
    }];
    
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:kPullbackStreamDuration], setupWithNextWord]]];
}

#pragma Streams

- (void)startStreamsWithDuration:(CFTimeInterval)duration forDistance:(CGFloat)distance
{
    NSLog(@"%@", word.word);
    
    NSArray *shuffeledLetters = [word shuffledLetters];
    
    const CGFloat kEdgeGap = 20.0;
    const CGFloat kMinStartupMovementDistance = distance * 0.1;
    const CGFloat kMaxStartupMovementDistance = distance * 0.5;
    const CGFloat kStreamWidth = floor((self.frame.size.width - 2 * kEdgeGap) / shuffeledLetters.count);
    const CGFloat kStreamHeight = maxStreamDistance;
    
    CGFloat xOrigin = floor(kEdgeGap + ((shuffeledLetters.count * kStreamWidth) - (shuffeledLetters.count * kStreamWidth)) / 2.0);
    
    for (NSString *letter in shuffeledLetters) {
        //
        // position stream on top of scene
        //
        MWStreamNode *streamNode = [[MWStreamNode alloc] initWithLetter:letter inFrame:CGRectMake(xOrigin, self.frame.size.height, kStreamWidth, kStreamHeight)];
        streamNode.name = kStreamNodeName;
        
        //
        // setup distances and durations
        //
        streamNode.startupMovementDistance = [Random randomFloatBetween:kMinStartupMovementDistance and:kMaxStartupMovementDistance];
        streamNode.normalMovementDistance = distance - streamNode.startupMovementDistance;
        
        streamNode.startupMovementDuration = kStreamStartupDuration;//(streamNode.startupMovementDistance / distance) * duration;
        streamNode.normalMovementDuration = kSolvingTime * (streamNode.normalMovementDistance / distance);//(streamNode.normalMovementDistance / distance) * duration;
        
        //
        // handle stream touch
        //
        [streamNode setStreamTouched:^(MWStreamNode *node){
            NSLog(@"Touched: %@", node.letter);
            
            //
            // check if next word
            //
            if ([word isNextLetter:node.letter]) {
                //
                // set letter
                //
                NSUInteger index = [word setNextLetter:node.letter];
                [[self solutionNode] revealLetter:node.letter atIndex:index withDuration:kRevealLetterDuration];
                
                //
                // remove stream
                //
                [node removeWithDuration:kRemoveStreamDuration];
            }
        }];
        
        //
        // handle stream end
        //
        [streamNode setStreamEndReached:^(MWStreamNode *node) {
            NSLog(@"Reached end: %@", node.letter);
            
            //
            // reveal letter
            //
             NSUInteger index = [word revealLetter:node.letter];
            [[self solutionNode] revealLetter:node.letter atIndex:index withDuration:kRevealLetterDuration];
            
            //
            // check if need to reveal definition
            //
            if (word.shouldRevealDefinition) {
                //[word keepFirstSolution]; // pick first partially matching word as solution
                [self presentDefinitionWithDuration:kPresentDefinitionDuration];
            }
            
            //
            // remove stream
            //
            [node removeWithDuration:kRemoveStreamDuration];
        }];
        
        [self addChild:streamNode];
        
        [streamNode startFall];
        
        xOrigin = xOrigin + kStreamWidth;
    }
}

- (void)pullbackStreamsWithDuration:(CFTimeInterval)duration
{
    for (MWStreamNode *node in [self streamNodes]) {
        [node pullbackWithDuration:duration];
    }
}

- (NSArray *)streamNodes
{
    NSMutableArray *nodes = [NSMutableArray array];
    
    [self enumerateChildNodesWithName:kStreamNodeName usingBlock:^(SKNode *node, BOOL *stop) {
        [nodes addObject:node];
    }];
    
    return nodes;
}

#pragma Definition

- (void)presentDefinitionWithDuration:(CFTimeInterval)duration
{
    if (![self definitionNode].isDefinitionPresented) {
        MWDefinitionNode *definitionNode = [[MWDefinitionNode alloc] initWithFrame:CGRectMake(0.0, solutionAreaFrame.origin.y+solutionAreaFrame.size.height, self.frame.size.width, self.frame.size.height - maxStreamDistance)];
        definitionNode.name = kDefinitionNodeName;
        [self addChild:definitionNode];
        
        [[self definitionNode] presentDefinitionOfWord:word.solutionWord withDuration:duration];
    }
}

- (void)dismissDefinitionWithDuration:(CFTimeInterval)duration
{
    [[self definitionNode] dismissWithDuration:duration];
}

- (MWDefinitionNode *)definitionNode
{
    return (MWDefinitionNode *)[self childNodeWithName:kDefinitionNodeName];
}

#pragma Solution

- (void)setupSolutionWithDuration:(CFTimeInterval)duration
{
    [[self solutionNode] setupForWordWithLetterCount:word.letterCount withDuration:duration];
}

- (MWSolutionNode *)solutionNode
{
    return (MWSolutionNode *)[self childNodeWithName:kSolutionNodeName];
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
    
    //
    // add solution area
    //
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
        [[MWPurchaseManager sharedManager] requestProductWithCompletionHandler:^(BOOL success, SKProduct *product) {
            if (success) {
                [self addPurchaseNode];
            }
        }];
    }
    
    [[MWPurchaseManager sharedManager] setProductPurchasedCompletion:^(SKProduct *product) {
        [[self purchaseNode] remove];
        [self addSolveNode];
    }];
    
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
    solutionNode.name = kSolutionNodeName;
    [self addChild:solutionNode];
    
    [solutionNode setupWithPartialSolution:@"Word Guru" placeholder:[MWWord placeholder] withDuration:0.0];
}

- (void)addPurchaseNode
{
    MWPurchaseNode *purchaseNode = [[MWPurchaseNode alloc] initWithFrame:CGRectMake(0.0, 0.0, solutionAreaFrame.origin.x, solutionAreaFrame.size.height)];
    purchaseNode.name = kPurchaseNodeName;
    [purchaseNode setNodeTouched:^(MWPurchaseNode *node){
        // TODO ask if want to purchase or restore
    }];
    [self addChild:purchaseNode];
}

- (MWPurchaseNode *)purchaseNode
{
    return (MWPurchaseNode *)[self childNodeWithName:kPurchaseNodeName];
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
