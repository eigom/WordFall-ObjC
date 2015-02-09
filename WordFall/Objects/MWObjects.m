//
//  MWObjects.m
//  WordFall
//
//  Created by eigo on 06/02/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWObjects.h"

@implementation MWObjects

@synthesize items;

- (id)init
{
    if ((self = [super init])) {
        items = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (id)initFromResultSet:(FMResultSet *)rs
{
    if ((self = [self init])) {
        ;
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [self init])) {
        items = [aDecoder decodeObjectForKey:@"items"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:items forKey:@"items"];
}

- (void)addItem:(id)object
{
    [items addObject:object];
}

- (void)addItems:(NSArray *)objects
{
    [items addObjectsFromArray:objects];
}

- (void)removeItem:(id)object
{
    [items removeObject:object];
}

- (void)removeAllItems
{
    [items removeAllObjects];
}

- (id)itemAtIndex:(NSUInteger)index
{
    return [items objectAtIndex:index];
}

- (id)firstItem
{
    id item = nil;
    
    if ([items count] > 0) {
        item = [items objectAtIndex:0];
    }
    
    return item;
}

- (id)lastItem
{
    return [items lastObject];
}

- (NSUInteger)itemCount
{
    return [items count];
}

- (NSInteger)itemIndex:(id)item
{
    NSInteger index = -1;
    NSUInteger i = 0;
    
    for (id aItem in items) {
        if ([aItem isEqual:item]) {
            index = i;
            break;
        }
        
        i++;
    }
    
    return index;
}

- (BOOL)containsItem:(id)item
{
    return [items containsObject:item];
}

@end
