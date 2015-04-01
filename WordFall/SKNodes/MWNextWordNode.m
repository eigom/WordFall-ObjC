//
//  MWNextWordNode.m
//  WordFall
//
//  Created by eigo on 24/03/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWNextWordNode.h"

@implementation MWNextWordNode

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super init])) {
        self.zPosition = 10;
        self.userInteractionEnabled = YES;
        
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        label.text = @"NEXT";
        label.fontSize = 15.0;
        label.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        label.userInteractionEnabled = NO;
        label.position = CGPointMake(CGRectGetMidX(frame),
                                     CGRectGetMidY(frame));
        [self addChild:label];
    }
    
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_nodeTouched) {
        _nodeTouched(self);
    }
}

- (void)disableForDuration:(CFTimeInterval)duration
{
    SKAction *disable = [SKAction runBlock:^{
        self.userInteractionEnabled = NO;
    }];
    SKAction *wait = [SKAction waitForDuration:duration];
    SKAction *enable = [SKAction runBlock:^{
        self.userInteractionEnabled = YES;
    }];
    
    [self runAction:[SKAction sequence:@[disable, wait, enable]]];
}

@end
