//
//  Random.m
//  WordFall
//
//  Created by eigo on 23/03/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "Random.h"

#define ARC4RANDOM_MAX 0x100000000

@implementation Random

+ (float)randomFloatBetween:(float)minValue and:(float)maxValue
{
    return ((float)arc4random() / ARC4RANDOM_MAX * (maxValue - minValue)) + minValue;
}

@end
