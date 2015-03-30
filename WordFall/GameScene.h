//
//  GameScene.h
//  WordFall
//

//  Copyright (c) 2015 eigo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class MWWord;
@class MWSolutionNode;

typedef void (^GameSceneShouldPresentWordDefinition)(MWWord *word, CFTimeInterval duration);
typedef void (^GameSceneShouldDismissWordDefinition)(CFTimeInterval duration);

@interface GameScene : SKScene <UIAlertViewDelegate> {
@private
    MWWord *word;
    CGFloat maxStreamDistance;
    NSUInteger maxLetterCount;
    CGRect solutionAreaFrame;
}

@property (nonatomic, copy) GameSceneShouldPresentWordDefinition shouldPresentWordDefinition;
@property (nonatomic, copy) GameSceneShouldDismissWordDefinition shouldDismissWordDefinition;

@end
