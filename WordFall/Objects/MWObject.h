//
//  MWObject.h
//  WordFall
//
//  Created by eigo on 06/02/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMResultSet.h"

@interface MWObject : NSObject

- (id)initFromResultSet:(FMResultSet *)rs;

@end
