//
//  MWLengthControl.h
//  WordFall
//
//  Created by eigo on 21/05/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MWLengthControlLengthSelected)(NSInteger length);

@interface MWLengthControl : UIView {
@private
    NSMutableArray *buttons;
}

@property (nonatomic, assign) NSInteger length;
@property (nonatomic, copy) MWLengthControlLengthSelected lengthSelected;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title minValue:(NSInteger)minValue maxValue:(NSInteger)maxValue value:(NSInteger)value;

@end
