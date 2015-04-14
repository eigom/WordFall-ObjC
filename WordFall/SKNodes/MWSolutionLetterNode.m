//
//  MWSolutionLetterNode.m
//  WordFall
//
//  Created by eigo on 10/02/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWSolutionLetterNode.h"

static NSString * const kBackgroundNodeName = @"background";
static NSString * const kLetterLabelNodeName = @"label";
static NSString * const kShadowLabelNodeName = @"shadow";

static NSString * const kPhoneLetterBackgroundImageName = @"letterbox_iphone";
static NSString * const kPadLetterBackgroundImageName = @"letterbox_ipad";

static NSString * const kFont = @"Copperplate";

static const CGFloat kPhoneFontSize = 22;
static const CGFloat kPadFontSize = 28;

@implementation MWSolutionLetterNode

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super init])) {
        _frame = frame;
        self.zPosition = 10;
        //self.alpha = 0.0;
        
        SKSpriteNode *bgNode = [SKSpriteNode spriteNodeWithImageNamed:[self backgroundImageName]];
        bgNode.name = kBackgroundNodeName;
        bgNode.position = CGPointMake(CGRectGetMidX(_frame), _frame.origin.y+bgNode.frame.size.height/2.0);
        bgNode.zPosition = self.zPosition + 1;
        //bgNode.alpha = 0.0;
        [self addChild:bgNode];
        
        [self setVisible:NO withDuration:0.0];
    }
    
    return self;
}

- (NSString *)backgroundImageName
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return kPadLetterBackgroundImageName;
    } else {
        return kPhoneLetterBackgroundImageName;
    }
}

- (void)setVisible:(BOOL)visible withDuration:(CFTimeInterval)duration
{
    _visible = visible;
    
    if (_visible) {
        //SKAction *fadeIn = [SKAction fadeInWithDuration:duration];
        //[self runAction:[SKAction runAction:fadeIn onChildWithName:kBackgroundNodeName]];
        /*if ([self childNodeWithName:kBackgroundNodeName].xScale < 1.0) {
            [[self childNodeWithName:kBackgroundNodeName] runAction:[SKAction scaleXTo:1.0 duration:duration]];
        }*/
        [[self childNodeWithName:kBackgroundNodeName] runAction:[SKAction fadeInWithDuration:duration]];
    } else {
        [[self childNodeWithName:kBackgroundNodeName] runAction:[SKAction fadeOutWithDuration:duration]];
        /*if ([self childNodeWithName:kBackgroundNodeName].xScale > 0.0) {
            [[self childNodeWithName:kBackgroundNodeName] runAction:[SKAction scaleXTo:0.0 duration:duration]];
        }*/
    }
}

- (void)setLetter:(NSString *)letter withDuration:(CFTimeInterval)duration
{
    _letter = letter;
    
    SKSpriteNode *backgroundNode = (SKSpriteNode *)[self childNodeWithName:kBackgroundNodeName];
    
    SKAction *addLetter = [SKAction runBlock:^{
        //
        // letter
        //
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:kFont];
        label.name = kLetterLabelNodeName;
        label.text = _letter;
        label.fontSize = [self fontSize];
        label.fontColor = [UIColor yellowColor];
        label.verticalAlignmentMode = SKLabelVerticalAlignmentModeBaseline;
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        label.userInteractionEnabled = NO;
        label.zPosition = backgroundNode.zPosition + 1;
        label.position = [self letterPosition];
        label.xScale = 0.0;
        //label.alpha = 0.0;
        [self addChild:label];
        
        //
        // drop shadow
        //
        SKLabelNode *dropShadow = [SKLabelNode labelNodeWithFontNamed:kFont];
        dropShadow.name = kShadowLabelNodeName;
        dropShadow.fontSize = [self fontSize];
        dropShadow.fontColor = [SKColor blackColor];
        dropShadow.text = _letter;
        dropShadow.zPosition = label.zPosition - 1;
        dropShadow.position = CGPointMake(label.position.x + 1.0, label.position.y - 1.0);
        dropShadow.xScale = 0.0;
        //dropShadow.alpha = 0.0;
        [self addChild:dropShadow];
    }];
    
    SKAction *wait = [SKAction waitForDuration:duration];
    
    SKAction *scaleOut = [SKAction runBlock:^{
        [[self childNodeWithName:kBackgroundNodeName] runAction:[SKAction scaleXTo:0.0 duration:duration]];
    }];
    
    SKAction *scaleIn = [SKAction runBlock:^{
        [[self childNodeWithName:kBackgroundNodeName] runAction:[SKAction scaleXTo:1.0 duration:duration]];
        [[self childNodeWithName:kLetterLabelNodeName] runAction:[SKAction scaleXTo:1.0 duration:duration]];
        [[self childNodeWithName:kShadowLabelNodeName] runAction:[SKAction scaleXTo:1.0 duration:duration]];
    }];
    
    if (duration > 0.0) {
        [self runAction:[SKAction sequence:@[scaleOut, addLetter, wait, scaleIn]]];
    } else {
        [self runAction:[SKAction sequence:@[addLetter, scaleIn]]];
    }
}

- (CGPoint)letterPosition
{
    SKSpriteNode *bgNode = (SKSpriteNode *)[self childNodeWithName:kBackgroundNodeName];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return CGPointMake(CGRectGetMidX(bgNode.frame)-2.0, CGRectGetMidY(bgNode.frame)-5.0);
    } else {
        return CGPointMake(CGRectGetMidX(bgNode.frame)-2.0, CGRectGetMidY(bgNode.frame)-4.0);
    }
}

- (CGFloat)fontSize
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return kPadFontSize;
    } else {
        return kPhoneFontSize;
    }
}

- (void)clearLetterWithDuration:(CFTimeInterval)duration
{
    _letter = nil;
    
    SKAction *fadeOut = [SKAction fadeOutWithDuration:duration];
    SKAction *remove = [SKAction removeFromParent];
    
    [[self childNodeWithName:kLetterLabelNodeName] runAction:[SKAction sequence:@[fadeOut, remove]]];
    [[self childNodeWithName:kShadowLabelNodeName] runAction:[SKAction sequence:@[fadeOut, remove]]];
}


@end
