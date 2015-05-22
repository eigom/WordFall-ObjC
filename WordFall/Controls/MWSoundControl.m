//
//  MWSoundControl.m
//  WordFall
//
//  Created by eigo on 22/05/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWSoundControl.h"

static const CGFloat kActiveAlpha = 1.0;
static const CGFloat kInactiveAlpha = 0.5;

static const NSInteger kOnButtonTag = 0;
static const NSInteger kOffButtonTag = 1;

@implementation MWSoundControl

- (id)initWithFrame:(CGRect)frame title:(NSString *)title isOn:(BOOL)isOn
{
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor clearColor];
        
        //
        // buttons
        //
        const CGFloat kButtonWidth = 24.0;
        const CGFloat kButtonHeight = 20.0;
        const CGFloat kButtonGap = 4.0;
        
        UIView *buttonView = [[UIView alloc] init];
        
        CGFloat buttonViewHeight = 0.0;
        
        // ON button
        onButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, buttonViewHeight, kButtonWidth, kButtonHeight)];
        [onButton setTitle:@"On" forState:UIControlStateNormal];
        [onButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        onButton.tag = kOnButtonTag;
        [buttonView addSubview:onButton];
        
        buttonViewHeight = buttonViewHeight + onButton.frame.size.height;
        buttonViewHeight = buttonViewHeight + kButtonGap;
        
        // OFF button
        offButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, buttonViewHeight, kButtonWidth, kButtonHeight)];
        [offButton setTitle:@"Off" forState:UIControlStateNormal];
        [offButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        offButton.tag = kOffButtonTag;
        [buttonView addSubview:offButton];
        
        buttonViewHeight = buttonViewHeight + onButton.frame.size.height;
        
        buttonView.frame = CGRectMake(0.0, 0.0, kButtonWidth, buttonViewHeight);
        buttonView.center = CGPointMake(buttonView.frame.size.width/2.0, self.frame.size.height/2.0);
        buttonView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
        buttonView.layer.cornerRadius = buttonView.frame.size.width/2.0;
        [self addSubview:buttonView];
        
        //
        // title label
        //
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor yellowColor];
        titleLabel.shadowColor = [UIColor blackColor];
        titleLabel.shadowOffset = CGSizeMake(0.0, 1.0);
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
        titleLabel.center = CGPointMake(onButton.frame.origin.x+onButton.frame.size.width+titleLabel.frame.size.width/2.0, self.frame.size.height / 2.0);
        [self addSubview:titleLabel];
        
        //
        // select value
        //
        [self setIsOn:isOn];
    }
    
    return self;
}

- (void)setIsOn:(BOOL)isOn
{
    _isOn = isOn;
    
    if (isOn) {
        onButton.alpha = kActiveAlpha;
        onButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [onButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        
        offButton.alpha = kInactiveAlpha;
        offButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [offButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        offButton.alpha = kActiveAlpha;
        offButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [offButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        
        onButton.alpha = kInactiveAlpha;
        onButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [onButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (void)buttonPressed:(UIButton *)button
{
    [self setIsOn:button.tag==kOnButtonTag];
    
    if (_stateChanged) {
        _stateChanged(button.tag==kOnButtonTag);
    }
}

@end
