//
//  MWDefinition.m
//  WordFall
//
//  Created by eigo on 06/02/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWDefinition.h"
#import <UIKit/UIKit.h>

@implementation MWDefinition

@synthesize definitionID;
@synthesize definition;
@synthesize type;

- (id)initFromResultSet:(FMResultSet *)rs
{
    if ((self = [super initFromResultSet:rs])) {
        definitionID = [NSNumber numberWithLongLong:[rs unsignedLongLongIntForColumn:@"id"]];
        definition = [rs stringForColumn:@"definition"];
        type = [rs stringForColumn:@"type"];
    }
    
    return self;
}

- (NSAttributedString *)attributedText
{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
    
    NSAttributedString *typeString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"(%@) ", type]
        attributes:@{NSFontAttributeName : [UIFont italicSystemFontOfSize:12],
                     NSForegroundColorAttributeName : [UIColor yellowColor]}];
    [text appendAttributedString:typeString];
    
    NSAttributedString *definitionString = [[NSAttributedString alloc] initWithString:definition
        attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],
                     NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [text appendAttributedString:definitionString];
    
    return text;
}

@end
