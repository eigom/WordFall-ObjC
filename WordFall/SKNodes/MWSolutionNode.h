//
//  MWSolutionNode.h
//  WordFall
//
//  Created by eigo on 10/02/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class MWWord;
@class MWObjects;

@interface MWSolutionNode : SKNode {
@private
    
}

- (id)initWithFrame:(CGRect)frame;

- (void)setupForWordWithLetterCount:(NSInteger)letterCount withDuration:(CFTimeInterval)duration;
- (void)revealLetter:(NSString *)letter atIndex:(NSInteger)index withDuration:(CFTimeInterval)duration;
- (void)clearWithDuration:(CFTimeInterval)duration;

@end
