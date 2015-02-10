//
//  MWSolutionLetter.h
//  WordFall
//
//  Created by eigo on 10/02/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MWSolutionLetter : SKNode

@property (nonatomic, readonly) NSString *letter;

- (void)setLetter:(NSString *)letter animated:(BOOL)animated;
- (void)clearLetterAnimated:(BOOL)animated;

@end
