//
//  MWNextWordNode.h
//  WordFall
//
//  Created by eigo on 24/03/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class MWNextWordNode;

typedef void (^MWNextWordNodeTouched)(MWNextWordNode *node);

@interface MWNextWordNode : SKNode

@property (nonatomic, copy) MWNextWordNodeTouched nodeTouched;

- (id)initWithFrame:(CGRect)frame;

- (void)disableForDuration:(CFTimeInterval)duration;

@end
