//
//  MWSoundControl.h
//  WordFall
//
//  Created by eigo on 22/05/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MWSoundControlStateChanged)(BOOL isOn);

@interface MWSoundControl : UIView {
@private
    UIButton *onButton;
    UIButton *offButton;
}

@property (nonatomic, assign) BOOL isOn;
@property (nonatomic, copy) MWSoundControlStateChanged stateChanged;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title isOn:(BOOL)isOn;

@end
