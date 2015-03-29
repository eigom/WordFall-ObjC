//
//  MWProgressNode.m
//  WordFall
//
//  Created by eigo on 29/03/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWProgressNode.h"

static NSString * const kBackgroundNodeName = @"background";
static NSString * const kContentNodeName = @"content";

static const CGFloat kPresentationDuration = 1.0;
static const CGFloat kAnimationAreaSize = 30.0;

@implementation MWProgressNode

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super init])) {
        _frame = frame;
        
        self.userInteractionEnabled = YES;
    }
    
    return self;
}

- (void)presentWithText:(NSString *)text
{
    //
    // semitransparent background in full frame
    //
    SKShapeNode *background = [SKShapeNode shapeNodeWithRect:_frame];
    background.name = kBackgroundNodeName;
    background.userInteractionEnabled = YES;
    background.fillColor = [UIColor blackColor];
    background.alpha = 0.0;
    [self addChild:background];
    
    //
    // content
    //
    SKNode *contentNode = [SKNode node];
    contentNode.name = kContentNodeName;
    
    // animation
    SKShapeNode *rect = [SKShapeNode shapeNodeWithRect:CGRectMake(0.0, 0.0, kAnimationAreaSize, kAnimationAreaSize)];
    [contentNode addChild:rect];
    
    SKLabelNode *dot = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    dot.userInteractionEnabled = YES;
    dot.text = @"●";
    dot.fontSize = 15.0;
    dot.verticalAlignmentMode = SKLabelVerticalAlignmentModeBaseline;
    dot.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    dot.position = CGPointMake(kAnimationAreaSize, 0.0);
    [rect addChild:dot];
    
    SKAction *moveDot = [SKAction moveToX:kAnimationAreaSize duration:0.3];
    SKAction *moveDotBack = [moveDot reversedAction];
    SKAction *animation = [SKAction sequence:@[moveDot, moveDotBack]];
    [dot runAction:[SKAction repeatActionForever:animation]];
    
    // text
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    label.userInteractionEnabled = YES;
    label.text = text;
    label.fontSize = 15.0;
    label.verticalAlignmentMode = SKLabelVerticalAlignmentModeBaseline;
    label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    label.position = CGPointMake(kAnimationAreaSize, 0.0);
    [contentNode addChild:label];
    
    contentNode.position = CGPointMake(CGRectGetMidX(_frame)-contentNode.frame.size.width/2.0,
                                       CGRectGetMidY(_frame)-contentNode.frame.size.height/2.0);
    [self addChild:contentNode];
    
    //
    // present
    //
    SKAction *presentBackground = [SKAction runAction:[SKAction fadeAlphaTo:60.0 duration:kPresentationDuration] onChildWithName:kBackgroundNodeName];
    SKAction *presentContent = [SKAction runAction:[SKAction fadeAlphaTo:60.0 duration:kPresentationDuration] onChildWithName:kContentNodeName];
    
    [self runAction:[SKAction group:@[presentBackground, presentContent]]];
}

- (void)dismiss
{
    
}

@end
