//
//  MWStreamNode.m
//  WordFall
//
//  Created by eigo on 10/02/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWStreamNode.h"
#import "MWObjects.h"

@implementation MWStreamNode

- (id)initWithLetter:(NSString *)letter inFrame:(CGRect)frame
{
    if ((self = [super init])) {
        // create nodes
    }
    
    return self;
}

- (void)startFallWithVelocity:(CGFloat)startupVelocity forDistance:(CGFloat)startupDistance normalVelocity:(CGFloat)normalVelocity forDistance:(CGFloat)normalVelocityDistance
{
    // startup velocity for distance D, normal velocity after that
    // max distance M - if reached then call block
}

- (void)pause
{
    // pause on app inactive (ad tapped etc)
}

- (void)resume
{
    // resume on active
}

@end
