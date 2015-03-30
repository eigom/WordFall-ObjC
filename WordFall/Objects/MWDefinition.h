//
//  MWDefinition.h
//  WordFall
//
//  Created by eigo on 06/02/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWObject.h"

@interface MWDefinition : MWObject {
@private
    NSNumber *definitionID;
    NSString *definition;
    NSString *type;
}

@property (nonatomic, readonly) NSNumber *definitionID;
@property (nonatomic, readonly) NSString *definition;
@property (nonatomic, readonly) NSString *type;
@property (nonatomic, readonly) NSAttributedString *attributedText;

@end
