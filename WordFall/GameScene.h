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
typedef void (^GameSceneWillPresentProgress)(CFTimeInterval duration, CGFloat alpha);
typedef void (^GameSceneWillDismissProgress)(CFTimeInterval duration);

@interface GameScene : SKScene <UIAlertViewDelegate> {
@private
    MWWord *word;
    CGFloat maxStreamDistance;
    NSUInteger maxLetterCount;
    CGRect solutionAreaFrame;
}

@property (nonatomic, assign) BOOL adsShown;
@property (nonatomic, readonly) CGFloat definitionAreaYOrigin;
@property (nonatomic, readonly) CGFloat definitionAreaHeight;
@property (nonatomic, copy) GameSceneShouldPresentWordDefinition shouldPresentWordDefinition;
@property (nonatomic, copy) GameSceneShouldDismissWordDefinition shouldDismissWordDefinition;
@property (nonatomic, copy) GameSceneWillPresentProgress willPresentProgress;
@property (nonatomic, copy) GameSceneWillDismissProgress willDismissProgress;

@end
