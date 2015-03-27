//
//  MWPurchaseManager.m
//  WordFall
//
//  Created by eigo on 24/03/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "MWPurchaseManager.h"

static NSString * kProductIdentifier = @"";

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

- (id)init
{
    if ((self = [super init])) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    
    return self;
}

#pragma Load Product

- (void)requestProductsWithCompletionHandler:(MWPurchaseManagerRequestProductsCompletion)completionHandler
{
    _requestProductsCompletionHandler = [completionHandler copy];
    
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:kProductIdentifier]];
    _productsRequest.delegate = self;
    [_productsRequest start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSLog(@"Loaded list of products...");
    _productsRequest = nil;
    
    if ([response.products count] > 0) {
        NSLog(@"Loaded product");
        _product = [response.products firstObject];
    }
    
    if (_requestProductsCompletionHandler) {
        _requestProductsCompletionHandler(YES, _product);
        _requestProductsCompletionHandler = nil;
    }
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"Failed to load list of products.");
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

- (void)provideContentForProductIdentifier:(NSString *)productIdentifier
{
    //TODO save receipt
    
    /*[_purchasedProductIdentifiers addObject:productIdentifier];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];*/
    
    if (_productPurchasedCompletion) {
        _productPurchasedCompletion(_product);
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    };
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"completeTransaction...");
    
    [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"restoreTransaction...");
    
    [self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"failedTransaction...");
    
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (BOOL)isPurchased
{
    // check receipt not nil
    return NO;
}

@end
