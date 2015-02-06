//
//  MWManager.h
//  WordFall
//
//  Created by eigo on 06/02/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWManager : NSObject

- (void)storeObject:(id)object forKey:(NSString *)key;
- (id)objectForKey:(NSString *)key;
- (void)archiveObject:(id)object forKey:(NSString *)key;
- (id)unarchiveObjectForKey:(NSString *)key;
- (void)removeArchiveWithKey:(NSString *)key;

@end
