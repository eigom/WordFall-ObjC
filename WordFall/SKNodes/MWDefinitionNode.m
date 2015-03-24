//
//  MWDefinitionNode.m
//  WordFall
//
//  Created by eigo on 23/03/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWDefinitionNode.h"

@implementation MWDefinitionNode

- (void)presentDefinitionOfWord:(MWWord *)word withDuration:(CFTimeInterval)duration
{
    
    _isDefinitionPresented = YES;
}

- (void)dismissWithDuration:(CFTimeInterval)duration
{
    
}

@end
