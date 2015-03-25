//
//  MWSolutionLetterNode.h
//  WordFall
//
//  Created by eigo on 10/02/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MWSolutionLetterNode : SKNode

@property (nonatomic, readonly) NSString *letter;
@property (nonatomic, readonly) BOOL visible;

- (id)initWithFrame:(CGRect)frame;

- (void)setVisible:(BOOL)visible withDuration:(CFTimeInterval)duration;
- (void)setLetter:(NSString *)letter withDuration:(CFTimeInterval)duration;
- (void)clearLetterWithDuration:(CFTimeInterval)duration;

@end
