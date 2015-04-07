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
    CGRect _frame;
    NSString *_bgImageName;
}

@property (nonatomic, strong) NSString *letter;
@property (nonatomic, assign) CGFloat startupMovementDistance;
@property (nonatomic, assign) CGFloat startupMovementDuration;
@property (nonatomic, assign) CGFloat normalMovementDistance;
@property (nonatomic, assign) CGFloat normalMovementDuration;
@property (nonatomic, copy) MWStreamTouched streamTouched;
@property (nonatomic, copy) MWStreamEndReached streamEndReached;

- (id)initWithLetter:(NSString *)letter inFrame:(CGRect)frame bgImageName:(NSString *)bgImageName;

- (void)startFallWithSound:(SKAction *)soundAction;
- (void)pullbackWithDuration:(CFTimeInterval)duration;
- (void)removeWithDuration:(CFTimeInterval)duration;

@end
