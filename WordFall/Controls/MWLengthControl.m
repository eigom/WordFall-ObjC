//
//  MWLengthControl.m
//  WordFall
//
//  Created by eigo on 21/05/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWLengthControl.h"

@implementation MWLengthControl

- (id)initWithFrame:(CGRect)frame title:(NSString *)title minValue:(NSInteger)minValue maxValue:(NSInteger)maxValue isOff:(BOOL)isOff
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
    }
    
    return self;
}

@end
