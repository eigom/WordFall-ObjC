//
//  MWPurchaseNode.m
//  WordFall
//
//  Created by eigo on 24/03/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWPurchaseNode.h"

@implementation MWPurchaseNode

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super init])) {
        self.userInteractionEnabled = YES;
        
        SKLabelNode *label1 = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        label1.text = @"Auto-solve words";
        label1.fontSize = 13.0;
        label1.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        label1.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        label1.userInteractionEnabled = NO;
        label1.position = CGPointMake(CGRectGetMidX(frame),
                                     CGRectGetMidY(frame) + label1.frame.size.height / 2.0);
        [self addChild:label1];
        
        SKLabelNode *label2 = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        label2.text = @"+ remove ads";
        label2.fontSize = 11.0;
        label2.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        label2.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        label2.userInteractionEnabled = NO;
        label2.position = CGPointMake(CGRectGetMidX(frame),
                                      CGRectGetMidY(frame) - label2.frame.size.height / 2.0);
        [self addChild:label2];
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

- (void)remove
{
    SKAction *disappear = [SKAction fadeAlphaTo:0.0 duration:0.5];
    SKAction *removeFromParent = [SKAction removeFromParent];
    
    [self runAction:[SKAction sequence:@[disappear, removeFromParent]]];
}

@end
