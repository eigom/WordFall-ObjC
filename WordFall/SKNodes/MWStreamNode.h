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
    
}

@property (nonatomic, strong) NSString *letter;
@property (nonatomic, assign) CGFloat startupVelocity;
@property (nonatomic, assign) CGFloat startupDistance;
@property (nonatomic, assign) CGFloat normalVelocity;
@property (nonatomic, assign) CGFloat normalVelocityDistance;
@property (nonatomic, copy) MWStreamTouched streamTouched;
@property (nonatomic, copy) MWStreamEndReached streamEndReached;

- (id)initWithLetter:(NSString *)letter inFrame:(CGRect)frame;

- (void)startFall;
- (void)pullbackWithDuration:(CFTimeInterval)duration;
- (void)removeWithDuration:(CFTimeInterval)duration;

@end
