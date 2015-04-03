//
//  MWDefinition.m
//  WordFall
//
//  Created by eigo on 06/02/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWDefinition.h"
#import <UIKit/UIKit.h>

static NSString * const kTypeFont = @"GillSans";
static NSString * const kDefinitionFont = @"GillSans";

static const CGFloat kPhoneTypeFontSize = 15;
static const CGFloat kPhoneDefinitionFontSize = 16;

static const CGFloat kPadTypeFontSize = 18;
static const CGFloat kPadDefinitionSize = 20;

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
        attributes:@{NSFontAttributeName : [UIFont fontWithName:kTypeFont size:[self typeSize]],
                     NSForegroundColorAttributeName : [UIColor yellowColor]}];
    [text appendAttributedString:typeString];
    
    NSAttributedString *definitionString = [[NSAttributedString alloc] initWithString:definition
        attributes:@{NSFontAttributeName : [UIFont fontWithName:kDefinitionFont size:[self definitionSize]],
                     NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [text appendAttributedString:definitionString];
    
    return text;
}

- (CGFloat)typeSize
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return kPhoneTypeFontSize;
    } else {
        return kPadTypeFontSize;
    }
}

- (CGFloat)definitionSize
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return kPhoneDefinitionFontSize;
    } else {
        return kPadDefinitionSize;
    }
}

@end
