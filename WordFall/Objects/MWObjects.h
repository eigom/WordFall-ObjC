//
//  MWObjects.h
//  WordFall
//
//  Created by eigo on 06/02/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWObject.h"

@interface MWObjects : MWObject<NSCoding> {
@protected
    NSMutableArray *items;
}


@property (nonatomic, readonly) NSArray *items;

- (void)addItem:(id)object;
- (void)addItems:(NSArray *)objects;
- (void)removeItem:(id)object;
- (void)removeAllItems;
- (NSUInteger)itemCount;
- (id)itemAtIndex:(NSUInteger)index;
- (id)firstItem;
- (id)lastItem;
- (NSInteger)itemIndex:(id)item;
- (BOOL)containsItem:(id)item;

@end
