//
//  MWStream.h
//  WordFall
//
//  Created by eigo on 10/02/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class MWStream;

typedef void (^MWStreamMaxDistanceReached)(MWStream *stream);
typedef void (^MWStreamLetterTouched)(MWStream *stream);

@interface MWStream : SKNode

@property (nonatomic, strong) NSString *letter;
@property (nonatomic, copy) MWStreamLetterTouched letterTouched;
@property (nonatomic, copy) MWStreamMaxDistanceReached maxDistanceReached;

- (id)initWithLetter:(NSString *)letter;

// startup velocity for distance D, normal velocity after that
// max distance M - if reached then call block

@end
