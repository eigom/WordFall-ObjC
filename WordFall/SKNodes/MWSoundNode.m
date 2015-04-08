//
//  MWSoundNode.m
//  WordFall
//
//  Created by eigo on 08/04/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWSoundNode.h"

static NSString * const kSpriteNodeName = @"sprite";

static const CGFloat kAlpha = 1.0;

@implementation MWSoundNode

- (id)initWithPosition:(CGPoint)position soundEnabled:(BOOL)soundEnabled
{
    if ((self = [super init])) {
        _soundEnabled = soundEnabled;
        self.userInteractionEnabled = YES;
        self.zPosition = 20;
        
        SKSpriteNode *spriteNode = [SKSpriteNode spriteNodeWithTexture:[self soundTexture]];
        spriteNode.userInteractionEnabled = NO;
        spriteNode.name = kSpriteNodeName;
        spriteNode.anchorPoint = CGPointMake(0.0, 0.0);
        spriteNode.position = position;
        spriteNode.alpha = kAlpha;
        [self addChild:spriteNode];
    }
    
    return self;
}

- (SKTexture *)soundTexture
{
    return [SKTexture textureWithImageNamed:[self soundImageFilename]];
}

- (NSString *)soundImageFilename
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (_soundEnabled) {
            return @"sound_on_ipad";
        } else {
            return @"sound_off_ipad";
        }
    } else {
        if (_soundEnabled) {
            return @"sound_on_iphone";
        } else {
            return @"sound_off_iphone";
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self childNodeWithName:kSpriteNodeName] runAction:[SKAction fadeAlphaTo:1.0 duration:0.1]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    _soundEnabled = !_soundEnabled;
    
    if (_soundToggled) {
        _soundToggled(_soundEnabled);
    }
    
    SKSpriteNode *spriteNode = (SKSpriteNode *)[self childNodeWithName:kSpriteNodeName];
    spriteNode.texture = [self soundTexture];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    /*SKSpriteNode *spriteNode = (SKSpriteNode *)[self childNodeWithName:kSpriteNodeName];
    spriteNode.alpha = kFadeOutAlpha;*/
}

@end
