//
//  MWLengthControl.m
//  WordFall
//
//  Created by eigo on 21/05/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWLengthControl.h"
#import <QuartzCore/QuartzCore.h>

static const CGFloat kActiveAlpha = 1.0;
static const CGFloat kInactiveAlpha = 0.7;

@implementation MWLengthControl

- (id)initWithFrame:(CGRect)frame title:(NSString *)title minValue:(NSInteger)minValue maxValue:(NSInteger)maxValue value:(NSInteger)value
{
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor clearColor];
        
        //
        // title label
        //
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:12.0];
        titleLabel.numberOfLines = title.length;
        titleLabel.alpha = kInactiveAlpha;
        
        NSMutableString *titleText = [[NSMutableString alloc] init];
        
        for (int i = 0; i < title.length; i++) {
            NSString *letter = [title substringWithRange:NSMakeRange(i, 1)];
            [titleText appendString:letter];
            
            if (i < title.length-1) {
                [titleText appendString:@"\n"];
            }
        }
        
        titleLabel.text = titleText;
        
        [titleLabel sizeToFit];
        titleLabel.center = CGPointMake(titleLabel.frame.size.width / 2.0, self.frame.size.height / 2.0);
        [self addSubview:titleLabel];
        
        //
        // buttons
        //
        const CGFloat kButtonWidth = 30.0;
        const CGFloat kButtonHeight = 20.0;
        const CGFloat kButtonGap = 5.0;
        
        buttons = [[NSMutableArray alloc] init];
        
        UIView *buttonView = [[UIView alloc] init];
        buttonView.backgroundColor = [UIColor clearColor];
        
        CGFloat buttonViewHeight = 0.0;
        
        for (int i = minValue; i <= maxValue; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0, buttonViewHeight, kButtonWidth, kButtonHeight)];
            [button setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i;
            [buttonView addSubview:button];
            [buttons addObject:button];
            
            buttonViewHeight = buttonViewHeight + button.frame.size.height;
            buttonViewHeight = buttonViewHeight + kButtonGap;
        }
        
        // ALL button
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0, buttonViewHeight, kButtonWidth, kButtonHeight)];
        [button setTitle:@"All" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = -1;
        [buttonView addSubview:button];
        [buttons addObject:button];
        
        buttonViewHeight = buttonViewHeight + button.frame.size.height;
        
        buttonView.frame = CGRectMake(0.0, 0.0, kButtonWidth, buttonViewHeight);
        buttonView.center = CGPointMake(titleLabel.frame.origin.x+titleLabel.frame.size.width+buttonView.frame.size.width/2.0, self.frame.size.height/2.0);
        [self addSubview:buttonView];
        
        //
        // select value
        //
        [self setLength:value];
    }
    
    return self;
}

- (void)setLength:(NSInteger)length
{
    _length = length;
    
    for (UIButton *button in buttons) {
        if (button.tag == length) {
            button.alpha = kActiveAlpha;
            button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
            [button setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        } else {
            button.alpha = kInactiveAlpha;
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}


- (void)buttonPressed:(UIButton *)button
{
    [self setLength:button.tag];
    
    if (_lengthSelected) {
        _lengthSelected(button.tag);
    }
}

@end
