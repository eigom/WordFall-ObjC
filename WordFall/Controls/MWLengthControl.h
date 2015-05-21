//
//  MWLengthControl.h
//  WordFall
//
//  Created by eigo on 21/05/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWLengthControl : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger minValue;
@property (nonatomic, assign) NSInteger maxValue;
@property (nonatomic, assign) NSInteger value;
@property (nonatomic, assign) BOOL isOff;

@end
