//
//  MWDefinitionNode.m
//  WordFall
//
//  Created by eigo on 23/03/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWDefinitionNode.h"
#import "MWDefinitions.h"
#import "MWDefinition.h"
#import "MWWord.h"
#import "NSString+Extensions.h"

@implementation MWDefinitionNode

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super init])) {
        _frame = frame;
        self.alpha = 0.0;
    }
    
    return self;
}

- (SKNode*)nodeWithText:(NSString *)text wrappedToLength:(NSUInteger)wrapLength
{
    NSMutableArray *labelNodes = [NSMutableArray array];
    
    CGFloat height = 0.0;
    
    for (NSString *line in [text wrapToLength:wrapLength]) {
        SKLabelNode *labelNode = [SKLabelNode labelNodeWithFontNamed:@"TimesNewRoman"];
        labelNode.text = line;
        labelNode.fontSize = 15.0;
        labelNode.verticalAlignmentMode = SKLabelVerticalAlignmentModeBaseline;
        labelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        labelNode.userInteractionEnabled = NO;
        
        height = height + labelNode.frame.size.height;
        [labelNodes addObject:labelNode];
    }
    
    SKNode *node = [SKNode node];
    
    for (SKLabelNode *labelNode in labelNodes) {
        labelNode.position = CGPointMake(0.0, height);
        height = height - labelNode.frame.size.height;
        
        [node addChild:labelNode];
    }
    
    return node;
}

- (SKNode *)nodeWithWordDefinitions:(MWWord *)word
{
    SKNode *node = [SKNode node];
    
    CGFloat height = 0.0;
    
    NSMutableArray *definitionNodes = [NSMutableArray array];
    
    for (MWDefinition *definition in word.definitions.items) {
        SKNode *definitionNode = [self nodeWithText:definition.definition wrappedToLength:50];
        [definitionNodes addObject:definitionNode];
        height = height + [definitionNode calculateAccumulatedFrame].size.height;
    }
    
    for (SKNode *definitionNode in definitionNodes) {
        definitionNode.position = CGPointMake(0.0, height);
        [node addChild:definitionNode];
        
        height = height - [definitionNode calculateAccumulatedFrame].size.height;
    }
    
    return node;
}

- (void)presentDefinitionOfWord:(MWWord *)word withDuration:(CFTimeInterval)duration
{
    SKNode *definitionsNode = [self nodeWithWordDefinitions:word];
    definitionsNode.position = CGPointMake(_frame.origin.x + (_frame.size.width - definitionsNode.calculateAccumulatedFrame.size.width) / 2.0,
                                           _frame.origin.y + (_frame.size.height - definitionsNode.calculateAccumulatedFrame.size.height) / 2.0);
    [self addChild:definitionsNode];
    
    [self runAction:[SKAction fadeInWithDuration:duration]];
    
    _isDefinitionPresented = YES;
}

- (void)dismissWithDuration:(CFTimeInterval)duration
{
    SKAction *disappear = [SKAction fadeAlphaTo:0.0 duration:duration];
    SKAction *removeFromParent = [SKAction removeFromParent];
    
    [self runAction:[SKAction sequence:@[disappear, removeFromParent]]];
}

@end
