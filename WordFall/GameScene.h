//
//  GameScene.h
//  WordFall
//

//  Copyright (c) 2015 eigo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class MWWord;

@interface GameScene : SKScene {
@private
    MWWord *word;
    UILabel *definitionLabel;
}

@end
