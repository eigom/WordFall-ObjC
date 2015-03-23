//
//  DBManager.h
//  WordFall
//
//  Created by eigo on 06/02/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabaseQueue;
@class MWWord;

@interface DBManager : NSObject {
@private
    FMDatabaseQueue *dbQueue;
}

+ (DBManager *)sharedManager;

- (MWWord *)wordWithMaxLength:(NSUInteger)maxLength andMaxWordID:(NSUInteger)maxWordID;
- (NSUInteger)wordCount;

@end
