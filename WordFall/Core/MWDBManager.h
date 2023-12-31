//
//  MWDBManager.h
//  WordFall
//
//  Created by eigo on 06/02/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabaseQueue;
@class MWWord;

@interface MWDBManager : NSObject {
@private
    FMDatabaseQueue *dbQueue;
}

+ (MWDBManager *)sharedManager;
+ (void)copyToDocumentsIfNeeded;

- (MWWord *)wordWithMaxLength:(NSUInteger)maxLength limitToLength:(BOOL)limitToLength;

@end
