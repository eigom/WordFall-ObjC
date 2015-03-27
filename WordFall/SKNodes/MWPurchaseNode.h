//
//  MWPurchaseNode.h
//  WordFall
//
//  Created by eigo on 24/03/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class MWPurchaseNode;

typedef void (^MWPurchaseNodeTouched)(MWPurchaseNode *node);

@interface MWPurchaseNode : SKNode

@property (nonatomic, copy) MWPurchaseNodeTouched nodeTouched;

- (id)initWithFrame:(CGRect)frame;

- (void)removeWithDuration:(CFTimeInterval)duration;

@end
