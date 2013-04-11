//
//  InAppHandler.m
//  Demo
//
//  Created by Eric McConkie on 3/23/13.
//  Copyright (c) 2013 Eric McConkie. All rights reserved.
//

#import "InAppHandler.h"



@implementation InAppHandler

#pragma mark -
#pragma mark Public
-(void)restorePastPurchases
{
    //register as transaction observer
    
    [[SKPaymentQueue defaultQueue]restoreCompletedTransactions];
}

-(void)buy:(SKProduct*)product
{
    if ([SKPaymentQueue canMakePayments]) {
        SKPayment *payUp = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addPayment:payUp]; //starts the purchase
    } else {
        // Warn the user that purchases are disabled.
        if(self.logsOutput)
            NSLog(@"%@ ",@"user does not have purhcasing enabled");
    }
    
}

- (id)init
{
    self = [super init];
    
    if (self) {
        
        //kvo to query for products when this is set
        [self addObserver:self
               forKeyPath:@"productIds"
                  options:NSKeyValueObservingOptionNew
                  context:nil];
        
        //observe the payment/transaction que
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
    }
    return self;
}

#pragma mark -
#pragma mark kvo
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    /*
     // Get the product info about each product once we set the product identifiers.
     */
    if ([keyPath isEqualToString:@"productIds"]) {
        if ([self.productIds count]>0) {
            SKProductsRequest *pR = [[SKProductsRequest alloc] initWithProductIdentifiers:self.productIds];
            [pR setDelegate:self];
            [pR start];
        }
    }
}

#pragma mark -
#pragma mark StoreKit SKRequest delegates
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    if(self.logsOutput)
    {
        NSLog(@"didReceiveResponse %@ ",response);
        NSLog(@"record  products:%@,\r\nAka %@ ",response.products,[response.products valueForKey:@"productIdentifier"]);
    }
    
    [self setProducts:response.products];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationInAppProductsReceived object:self.products];
}

- (void)requestDidFinish:(SKRequest *)request __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0)
{
    if(self.logsOutput)
        NSLog(@"request did finish");
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationInAppRequestFailure object:error];
}





#pragma mark -
#pragma mark SKPaymentQueue transaction observations
// Sent when the transaction array has changed (additions or state changes).
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0)
{
    for (SKPaymentTransaction *transaction in transactions) {
        
        switch(transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                // Unlock content
                if(self.logsOutput)
                    NSLog(@"SKPaymentTransactionStatePurchased %@", transaction.payment.productIdentifier);
                
                [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationInAppProductPurchased object:transaction];
                [[SKPaymentQueue  defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchasing:
                [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationInAppProductPurchasing object:transaction];
                break;
                
            case SKPaymentTransactionStateFailed:
                // Handle error
                // You must call finishTransaction here too!
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
            {
                if(self.logsOutput)
                    NSLog(@"SKPaymentTransactionStateRestored %@", transaction.payment.productIdentifier);
                
                [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationInAppProductRestored object:transaction];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            }
                break;
        }
    }
    
}

// Sent when transactions are removed from the queue (via finishTransaction:).
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
    if(self.logsOutput)
        NSLog(@"removedTransactions\r\n---> %@",transactions);
    
}

// Sent when an error is encountered while adding transactions from the user's purchase history back to the queue.
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    if(self.logsOutput)
        NSLog(@"restoreCompletedTransactionsFailedWithError\r\n---> %@",error);
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationInAppRequestFailure object:error];
}

// Sent when all transactions from the user's purchase history have successfully been added back to the queue.
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    
    NSArray *ids = [queue.transactions valueForKeyPath:@"payment.productIdentifier"];
    [self setRestorablePurchasedProducts:ids];
    for(NSString *trans in ids)
    {
        //we can set a NSUserDefaults by the productIdentifier name
        //this way, we can easily query the system later without having to alwasy go to apple
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:trans];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationInAppAllProductRestored object:self.restorablePurchasedProducts];
    if(self.logsOutput)
        NSLog(@"paymentQueueRestoreCompletedTransactionsFinished\r\n---> %@",queue);
}

// Sent when the download state has changed.
- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray *)downloads
{
    if(self.logsOutput)
        NSLog(@"updatedDownloads\r\n---> %@",downloads);
}


@end
