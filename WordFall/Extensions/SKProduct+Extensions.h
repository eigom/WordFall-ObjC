//
//  SKProduct+Extensions.h
//  WordFall
//
//  Created by eigo on 29/03/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import <StoreKit/StoreKit.h>

@interface SKProduct (Extensions)

@property (nonatomic, readonly) NSString *formattedPrice;

@end
