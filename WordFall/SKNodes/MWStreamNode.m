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

@implementation MWStreamNode

- (id)initWithLetter:(NSString *)letter inFrame:(CGRect)frame
{
    if ((self = [super init])) {
        self.position = CGPointMake(self.position.x, 0.0);
        
        // create nodes
    }
    
    return self;
}

- (void)startFall
{
    SKAction *startupMovement = [SKAction moveBy:CGVectorMake(0.0, _startupMovementDistance) duration:_startupMovementDuration];
    startupMovement.timingMode = SKActionTimingEaseInEaseOut;
    
    SKAction *normalMovement = [SKAction moveBy:CGVectorMake(0.0, _normalMovementDistance) duration:_normalMovementDuration];
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
    SKAction *pullback = [SKAction moveToY:0.0 duration:duration];
    pullback.timingMode = SKActionTimingEaseInEaseOut;
    
    [self runAction:pullback];
}

- (void)removeWithDuration:(CFTimeInterval)duration
{
    SKAction *disappear = [SKAction scaleTo:0.0 duration:duration];
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
