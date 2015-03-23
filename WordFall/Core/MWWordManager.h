//
//  MWWordManager.h
//  WordFall
//
//  Created by eigo on 06/02/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWManager.h"

@class MWWord;
@class MWDefinitions;

@interface MWWordManager : MWManager {
@private
    MWWord *currentWord;
    NSUInteger wordCount;
}

+ (MWWordManager *)sharedManager;

- (MWWord *)nextWordWithMaxLenght:(NSUInteger)maxLength;

@end
