//
//  MWWordManager.m
//  WordFall
//
//  Created by eigo on 06/02/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWWordManager.h"
#import "MWWord.h"
#import "MWWords.h"
#import "MWDefinitions.h"
#import "DBManager.h"

@implementation MWWordManager

+ (MWWordManager *)sharedManager
{
    static id manager = nil;
    static dispatch_once_t onceToken = 0;
    
    dispatch_once(&onceToken, ^{
        manager = [[MWWordManager alloc] init];
    });
    
    return manager;
}

- (id)init
{
    if ((self = [super init])) {
        
    }
    
    return self;
}

- (MWWord *)nextWordWithMaxLenght:(NSUInteger)maxLength
{
    return [[DBManager sharedManager] wordWithMaxLength:maxLength];
}

@end
