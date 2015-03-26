//
//  MWSolutionLetterNode.m
//  WordFall
//
//  Created by eigo on 10/02/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWSolutionLetterNode.h"

@implementation MWSolutionLetterNode

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super init])) {
        _frame = frame;
    }
    
    return self;
}

- (void)setVisible:(BOOL)visible withDuration:(CFTimeInterval)duration
{
    
}

- (void)setLetter:(NSString *)letter withDuration:(CFTimeInterval)duration
{
    _letter = letter;
    
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    label.text = _letter;
    label.fontSize = 15.0;
    label.verticalAlignmentMode = SKLabelVerticalAlignmentModeBaseline;
    label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    label.userInteractionEnabled = NO;
    label.position = CGPointMake(CGRectGetMidX(_frame),
                                 CGRectGetMidY(_frame));
    [self addChild:label];
}

- (void)clearLetterWithDuration:(CFTimeInterval)duration
{
    _letter = nil;
}


@end
