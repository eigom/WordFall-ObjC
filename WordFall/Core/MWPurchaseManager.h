//
//  MWPurchaseManager.h
//  WordFall
//
//  Created by eigo on 24/03/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWManager.h"
#import <StoreKit/StoreKit.h>

typedef void (^MWPurchaseManagerRequestProductsCompletion)(BOOL success, SKProduct *product);
typedef void (^MWPurchaseManagerProductPurchasedCompletion)(SKProduct *product);

@interface MWPurchaseManager : MWManager <SKProductsRequestDelegate, SKPaymentTransactionObserver> {
@private
    SKProductsRequest * _productsRequest;
    MWPurchaseManagerRequestProductsCompletion _requestProductsCompletionHandler;
}

@property (nonatomic, readonly) SKProduct *product;
@property (nonatomic, readonly) BOOL isPurchased;
@property (nonatomic, copy) MWPurchaseManagerProductPurchasedCompletion productPurchasedCompletion;

+ (MWPurchaseManager *)sharedManager;

- (void)requestProductsWithCompletionHandler:(MWPurchaseManagerRequestProductsCompletion)completionHandler;
- (void)buy;

@end
