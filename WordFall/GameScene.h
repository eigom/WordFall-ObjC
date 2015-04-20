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
typedef void (^GameSceneShouldPresentProgress)(NSString *text);
typedef void (^GameSceneShouldDismissProgress)();
typedef void (^GameSceneWillBeginPlay)(void);
typedef void (^GameSceneShouldDismissAds)(void);

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
@property (nonatomic, copy) GameSceneShouldPresentProgress shouldPresentProgress;
@property (nonatomic, copy) GameSceneShouldDismissProgress shouldDismissProgress;
@property (nonatomic, copy) GameSceneWillBeginPlay willBeginPlay;
@property (nonatomic, copy) GameSceneShouldDismissAds shouldDismissAds;

- (void)pausePlay;
- (void)resumePlay;


@end
