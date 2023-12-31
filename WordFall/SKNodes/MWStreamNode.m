//
//  MWStreamNode.m
//  WordFall
//
//  Created by eigo on 10/02/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWStreamNode.h"
#import "MWObjects.h"

static NSString * const kBackgroundNodeName = @"background";
static NSString * const kAnimatedLetterNodeName = @"animatedLetterNode";
static NSString * const kLetterNodeName = @"letterNode";
static NSString * const kMovementActionKey = @"movementAction";

static NSString * const kFont = @"Copperplate";

static const CGFloat kPhoneFontSize = 18;
static const CGFloat kPadFontSize = 30;

static const NSInteger kTrailingNodeCount = 3;

@implementation MWStreamNode

- (id)initWithLetter:(NSString *)letter inFrame:(CGRect)frame bgImageName:(NSString *)bgImageName
{
    if ((self = [super init])) {
        _letter = letter;
        _frame = frame;
        _bgImageName = bgImageName;
        
        self.userInteractionEnabled = YES;
        self.position = CGPointMake(self.position.x, 0.0);
        self.zPosition = 100;
        
        SKSpriteNode *bgNode = [SKSpriteNode spriteNodeWithImageNamed:bgImageName];
        bgNode.name = kBackgroundNodeName;
        bgNode.position = CGPointMake(CGRectGetMidX(_frame), _frame.origin.y+bgNode.frame.size.height/2.0);
        bgNode.zPosition = 150;
        [self addChild:bgNode];
        
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:kFont];
        label.zPosition = 160;
        label.text = _letter;
        label.fontSize = [self fontSize];
        label.verticalAlignmentMode = SKLabelVerticalAlignmentModeBaseline;
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        label.userInteractionEnabled = NO;
        label.position = [self letterPosition];
        [self addChild:label];
        
        SKLabelNode *dropShadow = [SKLabelNode labelNodeWithFontNamed:kFont];
        dropShadow.fontSize = [self fontSize];
        dropShadow.fontColor = [SKColor blackColor];
        dropShadow.text = _letter;
        dropShadow.zPosition = label.zPosition - 1;
        dropShadow.position = CGPointMake(label.position.x + 1.0, label.position.y - 1.0);
        
        [self addChild:dropShadow];
        
        //
        // trailing nodes
        //
        const CGFloat kMinAlpha = 0.15;
        const CGFloat kMaxAlpha = 0.4;
        const CGFloat kAlphaInc = (kMaxAlpha - kMinAlpha) / (kTrailingNodeCount - 1);
        
        for (int i = 0; i < kTrailingNodeCount; i++) {
            SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:bgImageName];
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                node.position = CGPointMake(bgNode.position.x, bgNode.position.y+((bgNode.frame.size.height-8.0)*(i+1)));
            } else {
                node.position = CGPointMake(bgNode.position.x, bgNode.position.y+((bgNode.frame.size.height-7.0)*(i+1)));
            }
            
            node.alpha = kMaxAlpha - (i * kAlphaInc);
            node.zPosition = bgNode.zPosition;
            [self addChild:node];
        }
    }
    
    return self;
}

- (CGFloat)fontSize
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return kPadFontSize;
    } else {
        return kPhoneFontSize;
    }
}

- (CGPoint)letterPosition
{
    SKSpriteNode *bgNode = (SKSpriteNode *)[self childNodeWithName:kBackgroundNodeName];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return CGPointMake(CGRectGetMidX(bgNode.frame)-1.0, CGRectGetMidY(bgNode.frame)-4.0);
    } else {
        return CGPointMake(CGRectGetMidX(bgNode.frame)-2.0, CGRectGetMidY(bgNode.frame)-2.0);
    }
}

- (void)startFall
{
    NSMutableArray *actions = [NSMutableArray array];
    
    SKAction *startupMovement = [SKAction moveBy:CGVectorMake(0.0, -_startupMovementDistance) duration:_startupMovementDuration];
    startupMovement.timingMode = SKActionTimingEaseOut;
    
    SKAction *normalMovement = [SKAction moveBy:CGVectorMake(0.0, -_normalMovementDistance) duration:_normalMovementDuration];
    normalMovement.timingMode = SKActionTimingLinear;
    
    SKAction *endReached = [SKAction runBlock:^{
        if (_streamEndReached) {
            _streamEndReached(self);
        }
    }];
    
    [actions addObject:startupMovement];
    [actions addObject:normalMovement];
    [actions addObject:endReached];
    
    [self runAction:[SKAction sequence:actions] withKey:kMovementActionKey];
}

/*- (void)startFallWithSound:(SKAction *)soundAction
{
    NSMutableArray *actions = [NSMutableArray array];
    
    SKAction *startupMovement = [SKAction moveBy:CGVectorMake(0.0, -_startupMovementDistance) duration:_startupMovementDuration];
    startupMovement.timingMode = SKActionTimingEaseOut;
    
    SKAction *normalMovement = [SKAction moveBy:CGVectorMake(0.0, -_normalMovementDistance) duration:_normalMovementDuration];
    normalMovement.timingMode = SKActionTimingLinear;
    
    SKAction *endReached = [SKAction runBlock:^{
        if (_streamEndReached) {
            _streamEndReached(self);
        }
    }];
    
    if (soundAction) {
        [actions addObject:soundAction];
    }
    
    [actions addObject:startupMovement];
    [actions addObject:normalMovement];
    [actions addObject:endReached];
    
    [self runAction:[SKAction sequence:actions] withKey:kMovementActionKey];
}*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_streamTouched) {
        _streamTouched(self);
    }
}

- (void)pullbackWithDuration:(CFTimeInterval)duration
{
    //
    // stop current fall
    //
    [self removeActionForKey:kMovementActionKey];
    
    //
    // move back to starting position
    //
    SKAction *pullback = [SKAction moveToY:_frame.size.height duration:duration];
    pullback.timingMode = SKActionTimingEaseIn;
    
    SKAction *removeFromParent = [SKAction removeFromParent];
    
    [self runAction:[SKAction sequence:@[pullback, removeFromParent]]];
}

- (void)removeWithDuration:(CFTimeInterval)duration
{
    SKAction *disappear = [SKAction fadeAlphaTo:0.0 duration:duration];
    SKAction *removeFromParent = [SKAction removeFromParent];
    
    [self runAction:[SKAction sequence:@[disappear, removeFromParent]]];
}

- (void)setEnabled:(BOOL)enabled
{
    self.userInteractionEnabled = enabled;
}

- (void)pause
{
    // pause on app inactive (ad tapped etc)
    self.paused = YES;
}

- (void)resume
{
    // resume on active
    self.paused = NO;
}

@end
