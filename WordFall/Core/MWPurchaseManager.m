//
//  MWPurchaseManager.m
//  WordFall
//
//  Created by eigo on 24/03/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWPurchaseManager.h"

static NSString * const kPurchasedKey = @"purchased";
static NSString * const kProductIdentifier = @"autosolve.and.removeads";

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

+ (BOOL)canMakePayments
{
    return [SKPaymentQueue canMakePayments];
}

- (id)init
{
    if ((self = [super init])) {
        _isPurchased = ([[NSUserDefaults standardUserDefaults] objectForKey:kPurchasedKey] != nil);
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    
    return self;
}

#pragma Load Product

- (void)requestProductWithCompletionHandler:(MWPurchaseManagerRequestProductsCompletion)completionHandler
{
    _isLoading = YES;
    
    _requestProductsCompletionHandler = [completionHandler copy];
    
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:kProductIdentifier]];
    _productsRequest.delegate = self;
    [_productsRequest start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSLog(@"Loaded list of products...");
    _productsRequest = nil;
    _isLoading = NO;
    
    if ([response.products count] > 0) {
        NSLog(@"Loaded product");
        _product = [response.products firstObject];
        
        if (_requestProductsCompletionHandler) {
            _requestProductsCompletionHandler(YES, _product);
        }
    } else {
        if (_requestProductsCompletionHandler) {
            _requestProductsCompletionHandler(NO, nil);
        }
    }
    
    _requestProductsCompletionHandler = nil;
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"Failed to load list of products: %@", error.localizedDescription);
    _productsRequest = nil;
    
    if (_requestProductsCompletionHandler) {
        _requestProductsCompletionHandler(NO, nil);
        _requestProductsCompletionHandler = nil;
    }
}

#pragma Purchase

- (void)buy
{
    NSLog(@"Buying %@...", _product.productIdentifier);
    
    SKPayment * payment = [SKPayment paymentWithProduct:_product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)restore
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"paymentQueueRestoreCompletedTransactionsFinished...");
    
    if (_restoreCompletion) {
        _restoreCompletion();
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    NSLog(@"restoreCompletedTransactionsFailedWithError...");
    
    if (_restoreFailedCompletion) {
        _restoreFailedCompletion(error);
    }
}

- (void)provideContent
{
    _isPurchased = YES;
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kPurchasedKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                //[self showTransactionAsInProgress:transaction deferred:NO];
                break;
            case SKPaymentTransactionStateDeferred:
                //[self showTransactionAsInProgress:transaction deferred:YES];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                NSLog(@"Unexpected transaction state %@", @(transaction.transactionState));
                break;
        }
        
        if (_paymentTransactionUpdated) {
            _paymentTransactionUpdated(transaction);
        }
    };
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"completeTransaction...");
    
    [self provideContent];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"restoreTransaction...");
    
    [self provideContent];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"failedTransaction...");
    
    if (transaction.error.code != SKErrorPaymentCancelled) {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

@end
