//
//  MWSolveWordNode.m
//  WordFall
//
//  Created by eigo on 24/03/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWSolveWordNode.h"

static NSString * const kSpriteNodeName = @"sprite";
static NSString * const kPhoneBackgroundImageName = @"solve_iphone";
static NSString * const kPadBackgroundImageName = @"solve_ipad";
static CGFloat const kPhoneWidth = 75.0;
static CGFloat const kPadWidth = 90.0;

@implementation MWSolveWordNode

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
        
        SKSpriteNode *spriteNode = [SKSpriteNode spriteNodeWithImageNamed:[self backgroundImageName]];
        spriteNode.userInteractionEnabled = NO;
        spriteNode.name = kSpriteNodeName;
        spriteNode.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
        spriteNode.alpha = 0.0;
        [self addChild:spriteNode];
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

- (void)present
{
    [[self childNodeWithName:kSpriteNodeName] runAction:[SKAction fadeAlphaTo:1.0 duration:1.0]];
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

- (void)setEnabled:(BOOL)enabled
{
    self.userInteractionEnabled = enabled;
}

@end
