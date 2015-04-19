//
//  MWPurchaseNode.m
//  WordFall
//
//  Created by eigo on 24/03/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWPurchaseNode.h"

static NSString * const kSpriteNodeName = @"sprite";
static NSString * const kPhoneBackgroundImageName = @"auto-solve_iphone";
static NSString * const kPadBackgroundImageName = @"auto-solve_ipad";
static CGFloat const kPhoneWidth = 75.0;
static CGFloat const kPadWidth = 90.0;

static const CGFloat kAlpha = 1.0;

@implementation MWPurchaseNode

+ (CGFloat)width
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return kPadWidth;
    } else {
        return kPhoneWidth;
    }
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super init])) {
        self.zPosition = 10;
        self.userInteractionEnabled = YES;
        self.alpha = 0.0;
        
        SKSpriteNode *spriteNode = [SKSpriteNode spriteNodeWithImageNamed:[self backgroundImageName]];
        spriteNode.userInteractionEnabled = NO;
        spriteNode.name = kSpriteNodeName;
        spriteNode.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
        [self addChild:spriteNode];
        
        /*SKLabelNode *label1 = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        label1.text = @"Auto-solve";
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
        [self addChild:label2];*/
    }
    
    return self;
}

- (NSString *)backgroundImageName
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return kPadBackgroundImageName;
    } else {
        return kPhoneBackgroundImageName;
    }
}

- (void)appearWithDuration:(CFTimeInterval)duration
{
    [self runAction:[SKAction fadeAlphaTo:kAlpha duration:duration]];
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
