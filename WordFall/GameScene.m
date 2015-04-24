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
#import "MWSoundNode.h"
#import "Random.h"
#import "MWPurchaseManager.h"
#import "MWSoundManager.h"
#import "SKProduct+Extensions.h"

static CFTimeInterval const kSolvingTime = 160.0;
static CFTimeInterval const kSolvingTimeWithAds = 200.0;
static CFTimeInterval const kPlayInitDuration = 1.0;
static CFTimeInterval const kStreamStartupDuration = 1.0;
static CFTimeInterval const kPullbackStreamDuration = 1.5;
static CFTimeInterval const kRemoveStreamDuration = 0.5;
static CFTimeInterval const kSetupSolutionDuration = 0.2;
static CFTimeInterval const kClearSolutionDuration = 0.4;
static CFTimeInterval const kSolveRemoveStreamDuration = 1.0;
static CFTimeInterval const kSolveWordDuration = 0.15;
static CFTimeInterval const kRevealLetterDuration = 0.2;

static NSUInteger const kPhoneSolutionLetterSize = 38.0;
static NSUInteger const kPadSolutionLetterSize = 50.0;

static NSString * const kStreamNodeName = @"stream";
static NSString * const kSolutionNodeName = @"solution";
static NSString * const kDefinitionNodeName = @"definition";
static NSString * const kPurchaseNodeName = @"purchase";
static NSString * const kProgressNodeName = @"progress";
static NSString * const kSolveNodeName = @"solve";
static NSString * const kNextNodeName = @"next";
static NSString * const kSoundNodeName = @"sound";

static const NSUInteger kNumOfStreamBackgrounds = 5;

static CGFloat const kPhoneButtonGap = 5.0;
static CGFloat const kPadButtonGap = 20.0;

@implementation GameScene

#pragma Game

- (void)playWithNextWord
{
    //
    // notify block
    //
    if (_willBeginPlay) {
        _willBeginPlay();
    }
    
    //
    // disable idle timer
    //
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    //
    // load product if needed
    //
    if (![MWPurchaseManager sharedManager].isPurchased) {
        if (![MWPurchaseManager sharedManager].product && ![MWPurchaseManager sharedManager].isLoading) {
            [[MWPurchaseManager sharedManager] requestProductWithCompletionHandler:^(BOOL success, SKProduct *product) {
                if (success) {
                    [self addPurchaseNode];
                }
            }];
        }
    }
    
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
        [self startStreamsForDistance:maxStreamDistance];
        
        //
        // show sound button
        //
        [[self soundNode] present];
    }];
    
    //
    // enable controls
    //
    SKAction *enable = [SKAction runBlock:^{
        [self solveNode].enabled = YES;
        [self nextNode].enabled = YES;
    }];
    
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:kPullbackStreamDuration], setupWithNextWord, enable]]];
}

- (NSString *)initialText
{
    NSString *text = @"WordGuru";
    
    if (maxLetterCount == 8) {
        text = @"WordGuru";
    } else if (maxLetterCount < 8) {
        text = @"Guru";
    }
    
    return text;
}

- (void)pausePlay
{
    [self scene].paused = YES;
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (void)resumePlay
{
    [self scene].paused = NO;
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

#pragma Streams

- (void)placeInitialStreamsWithText:(NSString *)text maxDistance:(CGFloat)distance
{
    //
    // make array of letters
    //
    NSMutableArray *letters = [[NSMutableArray alloc] init];
    
    for (int i=0; i <text.length; i++) {
        [letters addObject:[text substringWithRange:NSMakeRange(i, 1)]];
    }
    
    const CGFloat kEdgeGap = 20.0;
    const CGFloat kStreamWidth = floor((self.frame.size.width - 2 * kEdgeGap) / letters.count);
    const CGFloat kStreamHeight = distance;
    
    CGFloat xOrigin = floor(kEdgeGap + ((letters.count * kStreamWidth) - (letters.count * kStreamWidth)) / 2.0);
    
    CGFloat yFactor = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 0.51:0.61;
    
    NSString *bgImageName = [self initialStreamBackgroundImageName];
    
    for (NSString *letter in letters) {
        CGFloat yOrigin = self.frame.size.height-distance*yFactor;
        
        //
        // position stream
        //
        MWStreamNode *streamNode = [[MWStreamNode alloc] initWithLetter:letter inFrame:CGRectMake(xOrigin, yOrigin, kStreamWidth, kStreamHeight) bgImageName:bgImageName];
        streamNode.name = kStreamNodeName;
        [self addChild:streamNode];
        
        [streamNode startFallWithSound:nil];
        
        xOrigin = xOrigin + kStreamWidth;
    }
}

- (void)startStreamsForDistance:(CGFloat)distance
{
    NSLog(@"%@", word.word);
    
    NSArray *shuffledLetters = [word shuffledLetters];
    BOOL adsShown = ![MWPurchaseManager sharedManager].isPurchased;
    
    const CGFloat kEdgeGap = 20.0;
    const CGFloat kMinStartupMovementDistance = distance * (adsShown?(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad?0.3:0.45):0.2);
    const CGFloat kMaxStartupMovementDistance = distance * (adsShown?0.7:0.5);
    const CGFloat kStreamWidth = floor((self.frame.size.width - 2 * kEdgeGap) / shuffledLetters.count);
    const CGFloat kStreamHeight = distance;
    
    CGFloat xOrigin = floor(kEdgeGap + ((shuffledLetters.count * kStreamWidth) - (shuffledLetters.count * kStreamWidth)) / 2.0);
    
    NSString *bgImageName = [self streamBackgroundImageName];
    CFTimeInterval solvingTime = adsShown? kSolvingTimeWithAds : kSolvingTime;
    
    for (NSString *letter in shuffledLetters) {
        //
        // position stream on top of scene
        //
        MWStreamNode *streamNode = [[MWStreamNode alloc] initWithLetter:letter inFrame:CGRectMake(xOrigin, self.frame.size.height, kStreamWidth, kStreamHeight) bgImageName:bgImageName];
        streamNode.name = kStreamNodeName;
        
        //
        // setup distances and durations
        //
        streamNode.startupMovementDistance = [Random randomFloatBetween:kMinStartupMovementDistance and:kMaxStartupMovementDistance];
        streamNode.normalMovementDistance = distance - streamNode.startupMovementDistance + 3.0; // + transparent space on bottom of stream's image
        
        streamNode.startupMovementDuration = kStreamStartupDuration;//(streamNode.startupMovementDistance / distance) * duration;
        streamNode.normalMovementDuration = solvingTime * (streamNode.normalMovementDistance / distance);//(streamNode.normalMovementDistance / distance) * duration;
        
        //
        // handle stream touch
        //
        [streamNode setStreamTouched:^(MWStreamNode *node){
            //
            // check if next word
            //
            if ([word isNextLetter:node.letter]) {
                node.enabled = NO;
                
                //
                // set letter
                //
                NSUInteger index = [word setNextLetter:node.letter];
                [[self solutionNode] revealLetter:[word wordLetterAtIndex:index] atIndex:index withDuration:kRevealLetterDuration withSound:[[MWSoundManager sharedManager] revealLetterSound]];
                
                //
                // check if selved
                //
                if (word.isSolved) {
                    [UIApplication sharedApplication].idleTimerDisabled = NO;
                }
                
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
            node.enabled = NO;
            
            //
            // reveal letter
            //
             NSUInteger index = [word revealLetter:node.letter];
            [[self solutionNode] revealLetter:[word wordLetterAtIndex:index] atIndex:index withDuration:kRevealLetterDuration withSound:[[MWSoundManager sharedManager] revealLetterSound]];
            
            //
            // check if selved
            //
            if (word.isSolved) {
                [UIApplication sharedApplication].idleTimerDisabled = NO;
            }
            
            //
            // remove stream
            //
            [node removeWithDuration:kRemoveStreamDuration];
        }];
        
        [self addChild:streamNode];
        
        [streamNode startFallWithSound:[[MWSoundManager sharedManager] streamSound]];
        
        xOrigin = xOrigin + kStreamWidth;
    }
}

- (NSString *)initialStreamBackgroundImageName
{
    NSString *imageName = @"";
    
    NSUInteger index = 2;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        imageName = [NSString stringWithFormat:@"stream-%lu_ipad", (unsigned long)index];
    } else {
        return imageName = [NSString stringWithFormat:@"stream-%lu_iphone", (unsigned long)index];
    }
    
    return imageName;
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
    if (_shouldPresentWordDefinition) {
        _shouldPresentWordDefinition(word, duration);
    }
}

- (void)dismissDefinitionWithDuration:(CFTimeInterval)duration
{
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
    NSLog(@"presentProgressWithText");
    
    if (_shouldPresentProgress) {
        _shouldPresentProgress(text);
    }
}

- (void)dismissProgress
{
    NSLog(@"dismissProgress");
    
    if (_shouldDismissProgress) {
        _shouldDismissProgress();
    }
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
    
    //
    // dim background
    //
    SKShapeNode *dimNode = [SKShapeNode node];
    dimNode.fillColor = [UIColor blackColor];
    dimNode.strokeColor = [UIColor blackColor];
    dimNode.alpha = 0.1;
    dimNode.zPosition = background.zPosition + 1;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, nil, CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height));
    dimNode.path = path;
    
    [self addChild:dimNode];
}

- (void)addSolutionArea
{
    MWSolutionNode *solutionNode = [[MWSolutionNode alloc] initWithFrame:solutionAreaFrame];
    solutionNode.name = kSolutionNodeName;
    [self addChild:solutionNode];
    
    [solutionNode setupWithPartialSolution:[self initialText] placeholder:[MWWord placeholder] withDuration:0.0];
}

- (void)addPurchaseNode
{
    CGRect frame = CGRectZero;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        frame = CGRectMake(0.0, solutionAreaFrame.origin.y, solutionAreaFrame.origin.x, solutionAreaFrame.size.height);
    } else {
        frame = CGRectMake(-4.0, solutionAreaFrame.origin.y, solutionAreaFrame.origin.x, solutionAreaFrame.size.height);
    }
    
    MWPurchaseNode *purchaseNode = [[MWPurchaseNode alloc] initWithFrame:frame];
    purchaseNode.name = kPurchaseNodeName;
    [purchaseNode setNodeTouched:^(MWPurchaseNode *node){
        [node disableForDuration:1.0];
        [self pausePlay];
        
        //
        // ask if want to purchase or restore
        //
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Purchase auto-solving" message:[NSString stringWithFormat:@"Unlock auto-solving mode and remove ads for %@.\n\nPress Restore if you have already unlocked in the past.", [MWPurchaseManager sharedManager].product.formattedPrice] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:[NSString stringWithFormat:@"Unlock for %@", [MWPurchaseManager sharedManager].product.formattedPrice], @"Restore", nil];
        [alertView show];
    }];
    
    [self addChild:purchaseNode];
    [purchaseNode appearWithDuration:0.5];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        if ([MWPurchaseManager canMakePayments]) {
            [[MWPurchaseManager sharedManager] buy];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Payments disabled" message:@"Purchases are currently disabled on your device. Please enable purchases and try again." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
        }
    } else if (buttonIndex == alertView.firstOtherButtonIndex+1) {
        [self presentProgressWithText:@"Restoring..."];
        [[MWPurchaseManager sharedManager] restore];
    } else {
        [self resumePlay];
    }
}

- (MWPurchaseNode *)purchaseNode
{
    return (MWPurchaseNode *)[self childNodeWithName:kPurchaseNodeName];
}

- (void)addSolveNode
{
    CGRect frame = CGRectZero;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        frame = CGRectMake([self buttonGap], solutionAreaFrame.origin.y, [MWSolveWordNode width], solutionAreaFrame.size.height);
    } else {
        frame = CGRectMake([self buttonGap], solutionAreaFrame.origin.y, [MWSolveWordNode width], solutionAreaFrame.size.height);
    }
    
    MWSolveWordNode *solveNode = [[MWSolveWordNode alloc] initWithFrame:frame];
    solveNode.name = kSolveNodeName;
    [solveNode setNodeTouched:^(MWSolveWordNode *node){
        if (!word.isSolved) {
            node.enabled = NO;
            
            [self removeStreamsWithDuration:kSolveRemoveStreamDuration];
            [[self solutionNode] revealWord:[word solutionWord].word withDuration:kSolveWordDuration withSound:[[MWSoundManager sharedManager] revealWordSound]];
        }
    }];
    [self addChild:solveNode];
}

- (MWSolveWordNode *)solveNode
{
    return (MWSolveWordNode *)[self childNodeWithName:kSolveNodeName];
}

- (void)addNextWordNode
{
    CGRect frame = CGRectZero;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        frame = CGRectMake(self.frame.size.width-[MWNextWordNode width]-[self buttonGap], solutionAreaFrame.origin.y, [MWNextWordNode width], solutionAreaFrame.size.height);
    } else {
        frame = CGRectMake(self.frame.size.width-[MWNextWordNode width]-[self buttonGap], solutionAreaFrame.origin.y+2.0, [MWNextWordNode width], solutionAreaFrame.size.height);
    }
    
    MWNextWordNode *nextWordNode = [[MWNextWordNode alloc] initWithFrame:frame];
    nextWordNode.name = kNextNodeName;
    [nextWordNode setNodeTouched:^(MWNextWordNode *node){
        //[node disableForDuration:kPlayInitDuration+1.0];
        node.enabled = NO;
        [self playWithNextWord];
    }];
    [self addChild:nextWordNode];
}

- (MWNextWordNode *)nextNode
{
    return (MWNextWordNode *)[self childNodeWithName:kNextNodeName];
}

- (void)addSoundNode
{
    CGRect frame;
    
    if ([MWPurchaseManager sharedManager].isPurchased) {
        frame = CGRectMake(self.frame.size.width-[MWSoundNode size].width-5.0, self.frame.size.height-[MWSoundNode size].height-5.0, [MWSoundNode size].width, [MWSoundNode size].height);
    } else {
        frame = CGRectMake(self.frame.size.width-[MWSoundNode size].width, self.frame.size.height-maxStreamDistance+4.0, [MWSoundNode size].width, [MWSoundNode size].height);
    }
    
    MWSoundNode *soundNode = [[MWSoundNode alloc] initWithFrame:frame soundEnabled:[MWSoundManager sharedManager].soundEnabled];
    soundNode.name = kSoundNodeName;
    
    [soundNode setSoundToggled:^(BOOL soundEnabled){
        [MWSoundManager sharedManager].soundEnabled = soundEnabled;
    }];
    
    [self addChild:soundNode];
}

- (void)removeSoundNode
{
    [[self soundNode] removeFromParent];
}

- (MWSoundNode *)soundNode
{
    return (MWSoundNode *)[self childNodeWithName:kSoundNodeName];
}

- (void)addRevealLineNode
{
    UIBezierPath *path=[UIBezierPath bezierPath];
    CGPoint point1 = CGPointMake(1.0, self.frame.size.height - maxStreamDistance + 4.0); // stream image has shadow on bottom so add small constant
    CGPoint point2 = CGPointMake(self.frame.size.width, self.frame.size.height - maxStreamDistance + 4.0);
    [path moveToPoint:point1];
    [path addLineToPoint:point2];
    
    CGFloat pattern[2];
    pattern[0] = 7.0;
    pattern[1] = 3.0;
    CGPathRef dashed = CGPathCreateCopyByDashingPath([path CGPath], NULL, 0, pattern, 2);
    
    SKShapeNode *node = [SKShapeNode node];
    node.zPosition = 1;
    node.path = dashed;
    node.fillColor = [UIColor clearColor];
    node.strokeColor = [UIColor colorWithRed:1.0 green:1.0 blue:223.0/256.0 alpha:1.0];
    node.lineWidth = 0.5;
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
    maxStreamDistance = self.frame.size.height * 0.5 + 5.0;
    
    //
    // solution area
    //
    CGFloat leftButtonAreaWidth = [self buttonGap] + [MWSolveWordNode width] + [self buttonGap];
    CGFloat rightButtonAreaWidth = [self buttonGap] + [MWNextWordNode width] + [self buttonGap];
    CGFloat solutionAreaWidth = floor((self.frame.size.width - leftButtonAreaWidth-rightButtonAreaWidth) / [self solutionLetterSize]) * [self solutionLetterSize];
    CGFloat solutionAreaOriginX = leftButtonAreaWidth + (self.frame.size.width - rightButtonAreaWidth - leftButtonAreaWidth - solutionAreaWidth) / 2.0;
    CGFloat solutionAreaOriginY = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone? 10.0 : 20.0;
    solutionAreaFrame = CGRectMake(solutionAreaOriginX, solutionAreaOriginY, solutionAreaWidth, [self solutionLetterSize]);
    
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
    }
    
    [[MWPurchaseManager sharedManager] setPaymentTransactionUpdated:^(SKPaymentTransaction *transaction) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                [self presentProgressWithText:@"Processing..."];
                break;
            case SKPaymentTransactionStateDeferred:
                [self presentProgressWithText:@"Processing..."];
                break;
            case SKPaymentTransactionStateFailed:
                [self dismissProgress];
                [self resumePlay];
                
                if (transaction.error.code != SKErrorPaymentCancelled) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchase" message:transaction.error.localizedDescription delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [alert show];
                }
                break;
            case SKPaymentTransactionStatePurchased:
                if (_shouldRemoveAds) {
                    _shouldRemoveAds();
                }
                
                [[self purchaseNode] remove];
                [self addSolveNode];
                [self removeSoundNode];
                [self addSoundNode];
                [[self soundNode] present];
                [self dismissProgress];
                [self resumePlay];
                break;
            case SKPaymentTransactionStateRestored:
                if (_shouldRemoveAds) {
                    _shouldRemoveAds();
                }
                
                [[self purchaseNode] remove];
                [self addSolveNode];
                [self removeSoundNode];
                [self addSoundNode];
                [[self soundNode] present];
                [self dismissProgress];
                [self resumePlay];
                break;
            default:
                NSLog(@"Unexpected transaction state %@", @(transaction.transactionState));
                break;
        }
    }];
    
    [[MWPurchaseManager sharedManager] setRestoreCompletion:^() {
        [self dismissProgress];
        [self resumePlay];
    }];
    
    [[MWPurchaseManager sharedManager] setRestoreFailedCompletion:^(NSError *error) {
        [self dismissProgress];
        [self resumePlay];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Restore" message:error.localizedDescription delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }];
    
    //
    // sound On/Off
    //
    [self addSoundNode];
    
    //
    // next word
    //
    [self addNextWordNode];
    
    //
    // initial text
    //
    [self placeInitialStreamsWithText:[self initialText] maxDistance:maxStreamDistance];
}

- (CGFloat)definitionAreaYOrigin
{
    return maxStreamDistance-4.0;
}

- (CGFloat)definitionAreaHeight
{
    return self.frame.size.height - maxStreamDistance - (solutionAreaFrame.origin.y+solutionAreaFrame.size.height);
}

- (CGFloat)buttonGap
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return kPadButtonGap;
    } else {
        //
        // check if iPhone 4S
        //
        if ([[UIScreen mainScreen] bounds].size.height == 480.0) {
            return 4.0;
        } else {
            return kPhoneButtonGap;
        }
    }
}

- (void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
}

@end
