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
    NSUInteger definitionID;
    NSString *definition;
}

@property (nonatomic, readonly) NSUInteger definitionID;
@property (nonatomic, readonly) NSString *definition;

@end
