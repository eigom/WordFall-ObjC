//
//  GameScene.m
//  WordFall
//
//  Created by eigo on 26/01/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "GameScene.h"
#import "MWWordManager.h"
#import "MWWord.h"

@implementation GameScene

- (void)didMoveToView:(SKView *)view
{
    /* Setup your scene here */
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    myLabel.text = word.word;
    myLabel.fontSize = 65;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    
    [self addChild:myLabel];
    
    // add definitions label
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.xScale = 0.5;
        sprite.yScale = 0.5;
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }
}

- (void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
}

- (void)playWithNextWordAnimated:(BOOL)animated
{
    word = [[MWWordManager sharedManager] nextWord];
}

- (void)showDefinitionAnimated:(BOOL)animated
{
    
}

- (void)hideDefinitionAnimated:(BOOL)animated
{
    
}

@end
