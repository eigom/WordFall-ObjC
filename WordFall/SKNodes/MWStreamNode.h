//
//  MWStreamNode.h
//  WordFall
//
//  Created by eigo on 10/02/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class MWStreamNode;
@class MWObjects;

typedef void (^MWStreamEndReached)(MWStreamNode *stream);
typedef void (^MWStreamTouched)(MWStreamNode *stream);

@interface MWStreamNode : SKNode {
@private
    MWObjects *letterNodes;
    SKLabelNode *letterNode;
}

@property (nonatomic, strong) NSString *letter;
@property (nonatomic, copy) MWStreamTouched streamTouched;
@property (nonatomic, copy) MWStreamEndReached streamEndReached;

- (id)initWithLetter:(NSString *)letter inFrame:(CGRect)frame;

- (void)startFallWithVelocity:(CGFloat)startupVelocity forDistance:(CGFloat)startupDistance normalVelocity:(CGFloat)normalVelocity forDistance:(CGFloat)normalVelocityDistance;

- (void)pullbackWithDuration:(NSTimeInterval)duration;
- (void)removeAnimated:(BOOL)animated;

@end
