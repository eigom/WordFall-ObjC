//
//  MWPurchaseManager.h
//  WordFall
//
//  Created by eigo on 24/03/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWManager.h"

@interface MWPurchaseManager : MWManager

@property (nonatomic, readonly) BOOL isPurchased;

+ (MWPurchaseManager *)sharedManager;

@end
