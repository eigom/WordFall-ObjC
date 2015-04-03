//
//  MWSolutionLetterNode.m
//  WordFall
//
//  Created by eigo on 10/02/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWSolutionLetterNode.h"

static NSString * const kLetterLabelNodeName = @"label";

static NSString * const kFont = @"Copperplate";

static const CGFloat kPhoneFontSize = 20;
static const CGFloat kPadFontSize = 26;

@implementation MWSolutionLetterNode

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super init])) {
        _frame = frame;
        self.zPosition = 10;
    }
    
    return self;
}

- (void)setVisible:(BOOL)visible withDuration:(CFTimeInterval)duration
{
    // TODO animate visible - flip empty pentagon from nothing with particle effect
    
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
    label.position = CGPointMake(CGRectGetMidX(_frame),
                                 CGRectGetMidY(_frame));
    [self addChild:label];
    
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
    
    //TODO flip to empty side with particle effect
}


@end
