//
//  MWSolution.h
//  WordFall
//
//  Created by eigo on 10/02/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class MWWord;
@class MWSolutionLetters;

@interface MWSolution : SKNode {
@private
    MWSolutionLetters *letters;
}

@property (nonatomic, readonly) MWWord *word;

- (void)setWord:(MWWord *)word animated:(BOOL)animated;
- (void)revealLetter:(NSString *)letter animated:(BOOL)animated;

@end
