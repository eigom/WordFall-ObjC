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

typedef void (^MWSolutionWordFormed)(NSString *solutionWord);

@interface MWSolution : SKNode {
@private
    MWSolutionLetters *letters;
}

@property (nonatomic, readonly) MWWord *word;
@property (nonatomic, copy) MWSolutionWordFormed wordFormed;

- (id)initWithMaxLetters:(NSUInteger)maxLetters;

- (void)setWord:(MWWord *)word animated:(BOOL)animated;
- (void)revealLetter:(NSString *)letter animated:(BOOL)animated;

@end
