//
//  NSString+Extensions.m
//  WordFall
//
//  Created by eigo on 27/03/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "NSString+Extensions.h"

@implementation NSString (Extensions)

- (NSArray *)wrapToLength:(NSUInteger)wrapLength
{
    NSMutableArray *strings = [NSMutableArray array];
    
    NSString *str = [self copy];
    
    while (str.length > wrapLength) {
        NSString *s = [str substringToIndex:wrapLength];
        
        NSInteger lastSpaceIndex = [s lastSpaceIndex];
        
        if (lastSpaceIndex == -1) {
            [strings addObject:s];
            str = [str substringFromIndex:wrapLength];
        } else {
            [strings addObject:[s substringToIndex:lastSpaceIndex]];
            str = [NSString stringWithFormat:@"%@%@", [s substringFromIndex:lastSpaceIndex+1], [str substringFromIndex:wrapLength]];
        }
    }
    
    [strings addObject:str];
    
    return strings;
}

- (NSInteger)lastSpaceIndex
{
    NSInteger index = -1;
    
    for (int i = (int)self.length-1; i >= 0; i--) {
        if ([[self substringWithRange:NSMakeRange(i, 1)] isEqualToString:@" "]) {
            index = i;
            break;
        }
    }
    
    return index;
}

@end
