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
typedef void (^MWPurchaseManagerPaymentTransactionUpdatedCompletion)(SKPaymentTransaction *transaction);
typedef void (^MWPurchaseManagerRestoreCompletion)();
typedef void (^MWPurchaseManagerRestoreFailedCompletion)(NSError *error);

@interface MWPurchaseManager : MWManager <SKProductsRequestDelegate, SKPaymentTransactionObserver> {
@private
    SKProductsRequest * _productsRequest;
    MWPurchaseManagerRequestProductsCompletion _requestProductsCompletionHandler;
}

@property (nonatomic, readonly) SKProduct *product;
@property (nonatomic, readonly) BOOL isLoading;
@property (nonatomic, readonly) BOOL isPurchased;
@property (nonatomic, copy) MWPurchaseManagerPaymentTransactionUpdatedCompletion paymentTransactionUpdated;
@property (nonatomic, copy) MWPurchaseManagerRestoreCompletion restoreCompletion;
@property (nonatomic, copy) MWPurchaseManagerRestoreFailedCompletion restoreFailedCompletion;

+ (MWPurchaseManager *)sharedManager;

- (void)requestProductWithCompletionHandler:(MWPurchaseManagerRequestProductsCompletion)completionHandler;
- (void)restore;
- (void)buy;

@end
