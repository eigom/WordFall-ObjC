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
static const CGFloat kPadFontSize = 26;

@implementation MWStreamNode

- (id)initWithLetter:(NSString *)letter inFrame:(CGRect)frame bgImageName:(NSString *)bgImageName
{
    if ((self = [super init])) {
        _letter = letter;
        _frame = frame;
        _bgImageName = bgImageName;
        
        self.userInteractionEnabled = YES;
        self.position = CGPointMake(self.position.x, 0.0);
        self.zPosition = 10;
        
        SKSpriteNode *bgNode = [SKSpriteNode spriteNodeWithImageNamed:bgImageName];
        bgNode.name = kBackgroundNodeName;
        bgNode.position = CGPointMake(CGRectGetMidX(_frame), _frame.origin.y+bgNode.frame.size.height/2.0);
        bgNode.zPosition = 15;
        [self addChild:bgNode];
        
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:kFont];
        label.zPosition = 20;
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
        return CGPointMake(CGRectGetMidX(bgNode.frame)-2.0, CGRectGetMidY(bgNode.frame)-2.0);
    } else {
        return CGPointMake(CGRectGetMidX(bgNode.frame), CGRectGetMidY(bgNode.frame)-2.0);
    }
}

- (void)startFallWithSound:(SKAction *)soundAction
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
}

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
