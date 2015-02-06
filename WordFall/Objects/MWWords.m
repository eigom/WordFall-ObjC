//
//  MWWords.m
//  WordFall
//
//  Created by eigo on 06/02/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWWords.h"
#import "MWWord.h"

@implementation MWWords

- (id)initFromResultSet:(FMResultSet *)rs
{
    if ((self = [super initFromResultSet:rs])) {
        while ([rs next]) {
            [self addItem:[[MWWord alloc] initFromResultSet:rs]];
        }
    }
    
    return self;
}

@end
