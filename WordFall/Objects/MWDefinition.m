//
//  MWDefinition.m
//  WordFall
//
//  Created by eigo on 06/02/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWDefinition.h"

@implementation MWDefinition

@synthesize definitionID;
@synthesize definition;

- (id)initFromResultSet:(FMResultSet *)rs
{
    if ((self = [super initFromResultSet:rs])) {
        definitionID = [rs unsignedLongLongIntForColumn:@"id"];
        definition = [rs stringForColumn:@"definition"];
    }
    
    return self;
}

@end
