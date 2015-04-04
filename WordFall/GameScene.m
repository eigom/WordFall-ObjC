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
#import "MWProgressNode.h"
#import "Random.h"
#import "MWPurchaseManager.h"
#import "SKProduct+Extensions.h"

static CFTimeInterval const kSolvingTime = 100.0;
static CFTimeInterval const kPlayInitDuration = 1.0;
static CFTimeInterval const kStreamStartupDuration = 1.0;
static CFTimeInterval const kPullbackStreamDuration = 1.5;
static CFTimeInterval const kRemoveStreamDuration = 0.5;
static CFTimeInterval const kSetupSolutionDuration = 0.2;
static CFTimeInterval const kClearSolutionDuration = 0.4;
static CFTimeInterval const kSolveWordDuration = 1.0;
//static CFTimeInterval const kDismissDefinitionDuration = 1.0;
//static CFTimeInterval const kSetupSolutionDuration = 1.0;
static CFTimeInterval const kRevealLetterDuration = 1.0;

static NSUInteger const kPhoneSolutionLetterSize = 38.0;
static NSUInteger const kPadSolutionLetterSize = 50.0;

static NSString * const kStreamNodeName = @"stream";
static NSString * const kSolutionNodeName = @"solution";
static NSString * const kDefinitionNodeName = @"definition";
static NSString * const kPurchaseNodeName = @"purchase";
static NSString * const kProgressNodeName = @"progress";

static const NSUInteger kNumOfStreamBackgrounds = 5;

@implementation GameScene

#pragma Game

- (void)playWithNextWord
{
    //
    // pullback active streams
    //
    [self pullbackStreamsWithDuration:kPlayInitDuration];
    
    //
    // dismiss definition
    //
    [self dismissDefinitionWithDuration:kPlayInitDuration];
    
    //
    // clear solution
    //
    [self clearSolutionWithDuration:kClearSolutionDuration];
    
    //
    // setup scene with new word
    //
    SKAction *setupWithNextWord = [SKAction runBlock:^{
        word = [[MWWordManager sharedManager] nextWordWithMaxLenght:maxLetterCount];
        
        [self setupSolutionWithDuration:kSetupSolutionDuration];
        [self presentDefinitionWithDuration:kPlayInitDuration];
        [self startStreamsWithDuration:kSolvingTime forDistance:maxStreamDistance];
    }];
    
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:kPullbackStreamDuration], setupWithNextWord]]];
}

#pragma Streams

- (void)startStreamsWithDuration:(CFTimeInterval)duration forDistance:(CGFloat)distance
{
    NSLog(@"%@", word.word);
    
    NSArray *shuffeledLetters = [word shuffledLetters];
    
    const CGFloat kEdgeGap = 20.0;
    const CGFloat kMinStartupMovementDistance = distance * (_adsShown?0.35:0.1);
    const CGFloat kMaxStartupMovementDistance = distance * 0.5;
    const CGFloat kStreamWidth = floor((self.frame.size.width - 2 * kEdgeGap) / shuffeledLetters.count);
    const CGFloat kStreamHeight = distance;
    
    CGFloat xOrigin = floor(kEdgeGap + ((shuffeledLetters.count * kStreamWidth) - (shuffeledLetters.count * kStreamWidth)) / 2.0);
    
    NSString *bgImageName = [self streamBackgroundImageName];
    
    for (NSString *letter in shuffeledLetters) {
        //
        // position stream on top of scene
        //
        MWStreamNode *streamNode = [[MWStreamNode alloc] initWithLetter:letter inFrame:CGRectMake(xOrigin, self.frame.size.height, kStreamWidth, kStreamHeight) bgImageName:bgImageName];
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
                //[self presentDefinitionWithDuration:kPresentDefinitionDuration];
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

- (NSString *)streamBackgroundImageName
{
    NSString *imageName = @"";
    
    NSUInteger index = arc4random_uniform(kNumOfStreamBackgrounds);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        imageName = [NSString stringWithFormat:@"stream-%lu_ipad", (unsigned long)index];
    } else {
        return imageName = [NSString stringWithFormat:@"stream-%lu_iphone", (unsigned long)index];
    }
    
    return imageName;
}

- (void)pullbackStreamsWithDuration:(CFTimeInterval)duration
{
    for (MWStreamNode *node in [self streamNodes]) {
        [node pullbackWithDuration:duration];
    }
}

- (void)removeStreamsWithDuration:(CFTimeInterval)duration
{
    for (MWStreamNode *node in [self streamNodes]) {
        [node removeWithDuration:duration];
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
    /*if (![self definitionNode].isDefinitionPresented) {
        MWDefinitionNode *definitionNode = [[MWDefinitionNode alloc] initWithFrame:CGRectMake(0.0, solutionAreaFrame.origin.y+solutionAreaFrame.size.height, self.frame.size.width, self.frame.size.height - maxStreamDistance)];
        definitionNode.name = kDefinitionNodeName;
        [self addChild:definitionNode];
        
        [[self definitionNode] presentDefinitionOfWord:word.solutionWord withDuration:duration];
    }*/
    if (_shouldPresentWordDefinition) {
        _shouldPresentWordDefinition(word, duration);
    }
}

- (void)dismissDefinitionWithDuration:(CFTimeInterval)duration
{
    //[[self definitionNode] dismissWithDuration:duration];
    if (_shouldDismissWordDefinition) {
        _shouldDismissWordDefinition(duration);
    }
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

- (void)clearSolutionWithDuration:(CFTimeInterval)duration
{
    [[self solutionNode] clearLettersWithDuration:duration];
}

- (MWSolutionNode *)solutionNode
{
    return (MWSolutionNode *)[self childNodeWithName:kSolutionNodeName];
}

#pragma Progress

- (void)presentProgressWithText:(NSString *)text
{
    MWProgressNode *progressNode = [[MWProgressNode alloc] initWithFrame:self.frame];
    progressNode.name = kProgressNodeName;
    [progressNode setWillPresentProgress:^(CFTimeInterval duration, CGFloat alpha){
        if (_willPresentProgress) {
            _willPresentProgress(duration, alpha);
        }
    }];
    [progressNode setWillDismissProgress:^(CFTimeInterval duration){
        if (_willDismissProgress) {
            _willDismissProgress(duration);
        }
    }];
    [self addChild:progressNode];
    
    [progressNode presentWithText:text];
}

- (void)dismissProgress
{
    [[self progressNode] dismiss];
}

- (MWProgressNode *)progressNode
{
    return (MWProgressNode *)[self childNodeWithName:kProgressNodeName];
}

#pragma Scene

- (void)addBackgroundNode
{
    NSUInteger sceneWidth = self.frame.size.width;
    NSString *filename = [NSString stringWithFormat:@"background-%lu", (unsigned long)sceneWidth];
    
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:filename];
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    background.zPosition = 0;
    [self addChild:background];
}

- (void)addSolutionArea
{
    MWSolutionNode *solutionNode = [[MWSolutionNode alloc] initWithFrame:solutionAreaFrame];
    solutionNode.name = kSolutionNodeName;
    [self addChild:solutionNode];
    
    NSString *solution = @"Word Guru";
    
    if (maxLetterCount == 8) {
        solution = @"WordGuru";
    } else if (maxLetterCount < 8) {
        solution = @"";
    }
    
    [solutionNode setupWithPartialSolution:solution placeholder:[MWWord placeholder] withDuration:0.0];
}

- (void)addPurchaseNode
{
    MWPurchaseNode *purchaseNode = [[MWPurchaseNode alloc] initWithFrame:CGRectMake(0.0, 0.0, solutionAreaFrame.origin.x, solutionAreaFrame.size.height)];
    purchaseNode.name = kPurchaseNodeName;
    [purchaseNode setNodeTouched:^(MWPurchaseNode *node){
        [node disableForDuration:1.0];
        
        //
        // ask if want to purchase or restore
        //
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Purchase auto-solving" message:[NSString stringWithFormat:@"Unlock auto-solving mode and remove ads for %@.\n\nPress Restore if you have already unlocked in the past.", [MWPurchaseManager sharedManager].product.formattedPrice] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:[NSString stringWithFormat:@"Unlock for %@", [MWPurchaseManager sharedManager].product.formattedPrice], @"Restore", nil];
        [alertView show];
    }];
    [self addChild:purchaseNode];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        [self presentProgressWithText:@"Processing purchase..."];
        [[MWPurchaseManager sharedManager] buy];
    } else if (buttonIndex == alertView.firstOtherButtonIndex+1) {
        [self presentProgressWithText:@"Restoring purchase..."];
        [[MWPurchaseManager sharedManager] restore];
    }
}

- (MWPurchaseNode *)purchaseNode
{
    return (MWPurchaseNode *)[self childNodeWithName:kPurchaseNodeName];
}

- (void)addSolveNode
{
    MWSolveWordNode *solveNode = [[MWSolveWordNode alloc] initWithFrame:CGRectMake(0.0, 0.0, solutionAreaFrame.origin.x, solutionAreaFrame.size.height)];
    [solveNode setNodeTouched:^(MWSolveWordNode *node){
        if (!word.isSolved) {
            [node disableForDuration:kSolveWordDuration+1.0];
            [self removeStreamsWithDuration:kSolveWordDuration];
            [[self solutionNode] revealWord:[word solutionWord].word withDuration:kSolveWordDuration];
        }
    }];
    [self addChild:solveNode];
}

- (void)addNextWordNode
{
    MWNextWordNode *nextWordNode = [[MWNextWordNode alloc] initWithFrame:CGRectMake(solutionAreaFrame.origin.x+solutionAreaFrame.size.width, 0.0, self.frame.size.width - (solutionAreaFrame.origin.x+solutionAreaFrame.size.width), solutionAreaFrame.size.height)];
    [nextWordNode setNodeTouched:^(MWNextWordNode *node){
        [node disableForDuration:kPlayInitDuration+1.0];
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
    pattern[0] = 3.0;
    pattern[1] = 5.0;
    CGPathRef dashed = CGPathCreateCopyByDashingPath([path CGPath], NULL, 0, pattern, 2);
    
    SKShapeNode *node = [SKShapeNode node];
    node.zPosition = 1;
    node.path = dashed;
    node.fillColor = [UIColor blackColor];
    node.strokeColor = [UIColor whiteColor];
    node.lineWidth = 0.5;
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

- (void)didMoveToView:(SKView *)view
{
    //
    // add background image
    //
    [self addBackgroundNode];
    
    //
    // max falling distance, letter reveal level
    //
    maxStreamDistance = self.frame.size.height * 0.5;
    
    //
    // solution area
    //
    CGFloat solutionAreaWidth = floor(self.frame.size.width / [self solutionLetterSize]) * [self solutionLetterSize] - 4*[self solutionLetterSize]; // left/right gap of 4 letter sizes
    solutionAreaFrame = CGRectMake((self.frame.size.width - solutionAreaWidth) / 2.0, 5.0, solutionAreaWidth, [self solutionLetterSize]);
    
    //
    // max word lengths that can fit on screen
    //
    maxLetterCount = solutionAreaFrame.size.width / [self solutionLetterSize];
    
    //
    // add solution area
    //
    [self addSolutionArea];
    
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
    
    [[MWPurchaseManager sharedManager] setProductPurchasedCompletion:^(SKProduct *product, NSError *error) {
        [self dismissProgress];
        
        if (error) {
            if (error.code != SKErrorPaymentCancelled){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unlock auto-solve" message:error.localizedDescription delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
            }
        } else {
            [[self purchaseNode] remove];
            [self addSolveNode];
        }
    }];
    
    //
    // next word
    //
    [self addNextWordNode];
}

- (CGFloat)definitionAreaYOrigin
{
    return maxStreamDistance;
}

- (CGFloat)definitionAreaHeight
{
    return self.frame.size.height - maxStreamDistance - (solutionAreaFrame.origin.y+solutionAreaFrame.size.height);
}

- (void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
}

@end
