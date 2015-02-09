//
//  MWWord.h
//  WordFall
//
//  Created by eigo on 06/02/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWObject.h"

@class MWWords;
@class MWDefinitions;

@interface MWWord : MWObject {
@private
    NSNumber *wordID;
    NSString *word;
    MWWords *alternativeWords;
    MWDefinitions *definitions;
}

@property (nonatomic, readonly) NSNumber *wordID;
@property (nonatomic, readonly) NSString *word;
@property (nonatomic, strong) MWWords *alternativeWords;
@property (nonatomic, strong) MWDefinitions *definitions;

- (id)initWithString:(NSString *)word;

- (BOOL)hasWord:(NSString *)partialWord withAppendedLetter:(NSString *)letter;
- (BOOL)hasWord:(NSString *)word;
- (MWWord *)wordForWord:(NSString *)word;

@end
