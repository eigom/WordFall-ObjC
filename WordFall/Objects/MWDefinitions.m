//
//  MWDefinitions.m
//  WordFall
//
//  Created by eigo on 06/02/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWDefinitions.h"

@implementation MWDefinitions

- (id)initFromResultSet:(FMResultSet *)rs
{
    if ((self = [super initFromResultSet:rs])) {
        while ([rs next]) {
            [self addItem:[[MWDefinition alloc] initFromResultSet:rs]];
        }
    }
    
    return self;
}

@end
