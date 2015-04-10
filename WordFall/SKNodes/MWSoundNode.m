//
//  MWSoundNode.m
//  WordFall
//
//  Created by eigo on 08/04/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWSoundNode.h"

static NSString * const kSpriteNodeName = @"sprite";
static CGFloat const kPhoneHeight = 30.0;
static CGFloat const kPadHeight = 46.0;

static const CGFloat kAlpha = 0.9;

@implementation MWSoundNode

+ (CGSize)size
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return CGSizeMake(kPadHeight, kPadHeight);
    } else {
        return CGSizeMake(kPhoneHeight, kPhoneHeight);
    }
}

- (id)initWithFrame:(CGRect)frame soundEnabled:(BOOL)soundEnabled
{
    if ((self = [super init])) {
        _soundEnabled = soundEnabled;
        self.userInteractionEnabled = YES;
        self.zPosition = 20;
        
        SKSpriteNode *spriteNode = [SKSpriteNode spriteNodeWithTexture:[self soundTexture]];
        spriteNode.userInteractionEnabled = NO;
        spriteNode.name = kSpriteNodeName;
        spriteNode.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
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
    
}

@end
