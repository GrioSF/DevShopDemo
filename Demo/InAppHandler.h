//
//  InAppHandler.h
//  Demo
//
//  Created by Eric McConkie on 3/23/13.
//  Copyright (c) 2013 Eric McConkie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>




/*
 // posted on any SKRequest Failure
 // Object: the error object
 */
#define kNotificationInAppRequestFailure        @"kNotificationInAppRequestFailure"

/*
 // posted after products are successfully returned
 // Object: Array of the SKProduct objects
 */
#define kNotificationInAppProductsReceived      @"kNotificationInAppProductsReceived"

/*
 // posted on successful restore of a past purchase
 // Object: SKPaymentTransaction object
 */
#define kNotificationInAppProductRestored       @"kNotificationInAppProductRestored"

/*
 // posted after products are successfully returned
 // Object: Array of the SKProduct objects
 */
#define kNotificationInAppAllProductRestored    @"kNotificationInAppAllProductRestored"

/*
 // posted during the purchase of an SKProduct, but before final status
 // Object: SKPaymentTransaction object
 */
#define kNotificationInAppProductPurchasing      @"kNotificationInAppProductPurchasing"

/*
 // posted after purchase transaction succesfully completes
 // Object: SKPaymentTransaction object
 */
#define kNotificationInAppProductPurchased      @"kNotificationInAppProductPurchased"

@interface InAppHandler : NSObject<
SKProductsRequestDelegate,
SKRequestDelegate,
SKPaymentTransactionObserver>

@property (nonatomic)BOOL logsOutput;

//collection of unique strings for getting our products...
// these are the product identifiers from iTunes Connect,
// most commonly something like com.yourcompany.app.productname
@property (nonatomic,retain)NSSet *productIds;

//collection of SKProduct objects which represent our options for purchase
@property (nonatomic,retain)NSArray *products;

//collection of past purchases (non-consumable)
@property (nonatomic,retain)NSArray *restorablePurchasedProducts;

//making an in-app purchase
-(void)buy:(SKProduct*)product;

//non-consumables should always be restored
-(void)restorePastPurchases;


@end
