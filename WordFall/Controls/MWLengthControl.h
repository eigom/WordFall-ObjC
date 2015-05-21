//
//  MWLengthControl.h
//  WordFall
//
//  Created by eigo on 21/05/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MWLengthControl : UIView

@property (nonatomic, assign) NSInteger value;
@property (nonatomic, readonly) BOOL isOff;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title minValue:(NSInteger)minValue maxValue:(NSInteger)maxValue isOff:(BOOL)isOff;

@end
