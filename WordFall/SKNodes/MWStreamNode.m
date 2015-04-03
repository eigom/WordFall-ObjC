//
//  MWStreamNode.m
//  WordFall
//
//  Created by eigo on 10/02/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWStreamNode.h"
#import "MWObjects.h"

static NSString * const kAnimatedLetterNodeName = @"animatedLetterNode";
static NSString * const kLetterNodeName = @"letterNode";
static NSString * const kMovementActionKey = @"movementAction";

static NSString * const kFont = @"Copperplate";

@implementation MWStreamNode

- (id)initWithLetter:(NSString *)letter inFrame:(CGRect)frame
{
    if ((self = [super init])) {
        _letter = letter;
        _frame = frame;
        
        self.userInteractionEnabled = YES;
        self.position = CGPointMake(self.position.x, 0.0);
        self.zPosition = 10;
        
        SKSpriteNode *bgNode = [SKSpriteNode spriteNodeWithImageNamed:@"stream-0_iphone"];
        bgNode.position = CGPointMake(CGRectGetMidX(_frame), _frame.origin.y+bgNode.frame.size.height/2.0);
        bgNode.zPosition = self.zPosition + 1;
        [self addChild:bgNode];
        
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:kFont];
        label.zPosition = bgNode.zPosition + 1;
        label.text = _letter;
        label.fontSize = 17.0;
        label.verticalAlignmentMode = SKLabelVerticalAlignmentModeBaseline;
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        label.userInteractionEnabled = NO;
        label.position = CGPointMake(CGRectGetMidX(bgNode.frame), CGRectGetMidY(bgNode.frame)-4);
        [self addChild:label];
    }
    
    return self;
}

- (void)startFall
{
    SKAction *startupMovement = [SKAction moveBy:CGVectorMake(0.0, -_startupMovementDistance) duration:_startupMovementDuration];
    startupMovement.timingMode = SKActionTimingEaseOut;
    
    SKAction *normalMovement = [SKAction moveBy:CGVectorMake(0.0, -_normalMovementDistance) duration:_normalMovementDuration];
    normalMovement.timingMode = SKActionTimingLinear;
    
    SKAction *endReached = [SKAction runBlock:^{
        if (_streamEndReached) {
            _streamEndReached(self);
        }
    }];
    
    [self runAction:[SKAction sequence:@[startupMovement, normalMovement, endReached]] withKey:kMovementActionKey];
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
