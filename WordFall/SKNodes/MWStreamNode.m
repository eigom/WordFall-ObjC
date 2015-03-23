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
static NSString * const kFallActionKey = @"fallAction";

@implementation MWStreamNode

- (id)initWithLetter:(NSString *)letter inFrame:(CGRect)frame
{
    if ((self = [super init])) {
        // create nodes
    }
    
    return self;
}

- (void)startFall
{
    // startup velocity for distance D, normal velocity after that
    // max distance M - if reached then call block
}

- (void)pullbackWithDuration:(CFTimeInterval)duration
{
    //
    // stop current fall
    //
    [self removeActionForKey:kFallActionKey];
    
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
