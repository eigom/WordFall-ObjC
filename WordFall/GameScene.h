//
//  GameScene.h
//  WordFall
//

//  Copyright (c) 2015 eigo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class MWWord;
@class MWSolution;

@interface GameScene : SKScene {
@private
    MWWord *word;
    MWSolution *solution;
    UILabel *definitionLabel;
}

@end
