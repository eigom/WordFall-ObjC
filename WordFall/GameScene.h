//
//  GameScene.h
//  WordFall
//

//  Copyright (c) 2015 eigo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AdBuddiz/AdBuddiz.h>

@class MWWord;
@class MWSolutionNode;

typedef void (^GameSceneShouldPresentWordDefinition)(MWWord *word, CFTimeInterval duration);
typedef void (^GameSceneShouldDismissWordDefinition)(CFTimeInterval duration);
typedef void (^GameSceneShouldPresentProgress)(NSString *text);
typedef void (^GameSceneShouldDismissProgress)();
typedef void (^GameSceneWillBeginPlay)(void);
typedef void (^GameSceneShouldRemoveAds)(void);

@interface GameScene : SKScene <UIAlertViewDelegate, AdBuddizDelegate> {
@private
    MWWord *word;
    CGFloat maxStreamDistance;
    NSUInteger maxLetterCount;
    CGRect solutionAreaFrame;
    NSInteger showAdCounter;
}

@property (nonatomic, readonly) CGFloat definitionAreaYOrigin;
@property (nonatomic, readonly) CGFloat definitionAreaHeight;
@property (nonatomic, readonly) NSUInteger maxLetterCount;
@property (nonatomic, copy) GameSceneShouldPresentWordDefinition shouldPresentWordDefinition;
@property (nonatomic, copy) GameSceneShouldDismissWordDefinition shouldDismissWordDefinition;
@property (nonatomic, copy) GameSceneShouldPresentProgress shouldPresentProgress;
@property (nonatomic, copy) GameSceneShouldDismissProgress shouldDismissProgress;
@property (nonatomic, copy) GameSceneWillBeginPlay willBeginPlay;
@property (nonatomic, copy) GameSceneShouldRemoveAds shouldRemoveAds;

- (void)pausePlay;
- (void)resumePlay;


@end
