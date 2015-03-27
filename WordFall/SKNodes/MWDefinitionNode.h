//
//  MWDefinitionNode.h
//  WordFall
//
//  Created by eigo on 23/03/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class MWWord;

@interface MWDefinitionNode : SKNode {
@private
    CGRect _frame;
}

@property (nonatomic, readonly) BOOL isDefinitionPresented;

- (id)initWithFrame:(CGRect)frame;
- (void)presentDefinitionOfWord:(MWWord *)word withDuration:(CFTimeInterval)duration;
- (void)dismissWithDuration:(CFTimeInterval)duration;

@end
