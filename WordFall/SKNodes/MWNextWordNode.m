//
//  MWNextWordNode.m
//  WordFall
//
//  Created by eigo on 24/03/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWNextWordNode.h"

static NSString * const kSpriteNodeName = @"sprite";
static NSString * const kPhoneBackgroundImageName = @"next_iphone";
static NSString * const kPadBackgroundImageName = @"next_ipad";
static CGFloat const kPhoneWidth = 75.0;
static CGFloat const kPadWidth = 90.0;

@implementation MWNextWordNode

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
