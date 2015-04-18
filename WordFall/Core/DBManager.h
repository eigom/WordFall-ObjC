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
+ (void)copyToDocumentsIfNeeded;

- (MWWord *)wordWithMaxLength:(NSUInteger)maxLength;

@end
