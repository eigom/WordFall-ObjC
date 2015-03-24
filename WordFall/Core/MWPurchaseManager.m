//
//  MWPurchaseManager.m
//  WordFall
//
//  Created by eigo on 24/03/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWPurchaseManager.h"

@implementation MWPurchaseManager

+ (MWPurchaseManager *)sharedManager
{
    static id manager = nil;
    static dispatch_once_t onceToken = 0;
    
    dispatch_once(&onceToken, ^{
        manager = [[MWPurchaseManager alloc] init];
    });
    
    return manager;
}

@end
