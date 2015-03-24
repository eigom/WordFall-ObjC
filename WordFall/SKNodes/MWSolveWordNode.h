//
//  MWSolveWordNode.h
//  WordFall
//
//  Created by eigo on 24/03/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class MWSolveWordNode;

typedef void (^MWSolveWordNodeTouched)(MWSolveWordNode *node);

@interface MWSolveWordNode : SKNode

@property (nonatomic, copy) MWSolveWordNodeTouched nodeTouched;

- (id)initWithFrame:(CGRect)frame;

@end
