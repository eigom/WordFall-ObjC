//
//  MWDefinitions.m
//  WordFall
//
//  Created by eigo on 06/02/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWDefinitions.h"
#import "MWDefinition.h"

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

- (NSAttributedString *)combinedDefinitionTexts
{
    NSMutableAttributedString *texts = [[NSMutableAttributedString alloc] init];
    
    for (MWDefinition *definition in items) {
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:definition.definition];
        [texts appendAttributedString:attributedText];
        
        [texts appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
    }
    
    return texts;
}

- (NSAttributedString *)attributedText
{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
    
    for (MWDefinition *definition in items) {
        [text appendAttributedString:definition.attributedText];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
    }
    
    return text;
}

@end
