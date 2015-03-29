//
//  MWProgressNode.h
//  WordFall
//
//  Created by eigo on 29/03/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MWProgressNode : SKNode {
@private
    CGRect _frame;
}

- (id)initWithFrame:(CGRect)frame;

- (void)presentWithText:(NSString *)text;
- (void)dismiss;

@end
