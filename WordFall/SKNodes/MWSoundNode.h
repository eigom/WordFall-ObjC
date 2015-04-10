//
//  MWSoundNode.h
//  WordFall
//
//  Created by eigo on 08/04/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class MWSoundNode;

typedef void (^MWSoundNodeSoundToggled)(BOOL soundEnabled);

@interface MWSoundNode : SKNode {
@private
    BOOL _soundEnabled;
}

@property (nonatomic, copy) MWSoundNodeSoundToggled soundToggled;

+ (CGSize)size;

- (id)initWithFrame:(CGRect)frame soundEnabled:(BOOL)soundEnabled;

@end
