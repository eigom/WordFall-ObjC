//
//  MWProgressNode.h
//  WordFall
//
//  Created by eigo on 29/03/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef void (^MWProgressNodeWillPresentProgressCompletion)(CFTimeInterval duration, CGFloat alpha);
typedef void (^MWProgressNodeWillDismissProgressCompletion)(CFTimeInterval duration);

@interface MWProgressNode : SKNode {
@private
    CGRect _frame;
}

@property (nonatomic, copy) MWProgressNodeWillPresentProgressCompletion willPresentProgress;
@property (nonatomic, copy) MWProgressNodeWillDismissProgressCompletion willDismissProgress;

- (id)initWithFrame:(CGRect)frame;

- (void)presentWithText:(NSString *)text;
- (void)dismiss;

@end
