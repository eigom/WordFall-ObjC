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

static NSString * const kLetterBackgroundImageName = @"stream-0_iphone";
static NSString * const kEmptyBackgroundImageName = @"stream-1_iphone";

static NSString * const kFont = @"Copperplate";

static const CGFloat kPhoneFontSize = 20;
static const CGFloat kPadFontSize = 26;

@implementation MWSolutionLetterNode

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super init])) {
        _frame = frame;
        self.zPosition = 10;
        //self.alpha = 0.0;
        
        letterBackgroundTexture = [SKTexture textureWithImageNamed:kLetterBackgroundImageName];
        emptyBackgroundTexture = [SKTexture textureWithImageNamed:kEmptyBackgroundImageName];
        
        /*SKSpriteNode *bgNode = [SKSpriteNode spriteNodeWithTexture:emptyBackgroundTexture];
        bgNode.name = kBackgroundNodeName;
        bgNode.position = CGPointMake(CGRectGetMidX(_frame), _frame.origin.y+bgNode.frame.size.height/2.0);
        bgNode.zPosition = self.zPosition + 1;
        [self addChild:bgNode];
        
        [self setVisible:NO withDuration:0.0];*/
    }
    
    return self;
}

- (void)setVisible:(BOOL)visible withDuration:(CFTimeInterval)duration
{
    // TODO animate visible - flip empty pentagon from nothing with particle effect
    /*
    _visible = visible;
    
    if (_visible) {
        SKAction *grow = [SKAction scaleXTo:1.0 duration:duration];
        [self runAction:grow];
    } else {
        SKAction *shrink = [SKAction scaleXTo:0.0 duration:duration];
        [self runAction:[SKAction runAction:shrink onChildWithName:kBackgroundNodeName]];
    }*/
}

- (void)setLetter:(NSString *)letter withDuration:(CFTimeInterval)duration
{
    _letter = letter;
    
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:kFont];
    label.name = kLetterLabelNodeName;
    label.text = _letter;
    label.fontSize = [self fontSize];
    label.fontColor = [UIColor yellowColor];
    label.verticalAlignmentMode = SKLabelVerticalAlignmentModeBaseline;
    label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    label.userInteractionEnabled = NO;
    label.zPosition = [self childNodeWithName:kBackgroundNodeName].zPosition + 1;
    label.position = CGPointMake(CGRectGetMidX(_frame),
                                 CGRectGetMidY(_frame));
    [self addChild:label];
    
    SKLabelNode *dropShadow = [SKLabelNode labelNodeWithFontNamed:kFont];
    dropShadow.name = kShadowLabelNodeName;
    dropShadow.fontSize = [self fontSize];
    dropShadow.fontColor = [SKColor blackColor];
    dropShadow.text = _letter;
    dropShadow.zPosition = label.zPosition - 1;
    dropShadow.position = CGPointMake(label.position.x + 1.0, label.position.y - 1.0);
    
    [self addChild:dropShadow];
    
    // TODO flip to label side
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
    
    SKLabelNode *labelNode = (SKLabelNode *)[self childNodeWithName:kLetterLabelNodeName];
    [labelNode removeFromParent];
    
    SKLabelNode *shadowLabel = (SKLabelNode *)[self childNodeWithName:kShadowLabelNodeName];
    [shadowLabel removeFromParent];
    
    //TODO flip to empty side with particle effect
}


@end
