//
//  MWSoundManager.h
//  WordFall
//
//  Created by eigo on 07/04/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWManager.h"
#import <SpriteKit/SpriteKit.h>

@interface MWSoundManager : MWManager

+ (MWSoundManager *)sharedManager;

@property (nonatomic, assign) BOOL soundEnabled;

- (SKAction *)streamSound;
- (SKAction *)revealLetterSound;
- (SKAction *)revealWordSound;

@end
