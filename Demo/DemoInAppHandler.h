//
//  DemoInAppHandler.h
//  Demo
//
//  Created by Eric McConkie on 3/24/13.
//  Copyright (c) 2013 Eric McConkie. All rights reserved.
//

#import "InAppHandler.h"

#define kProductsConsumable @"consumable"
#define kProductsNonConsumable @"nonconsumable"

@interface DemoInAppHandler : InAppHandler
-(BOOL)isNonConsumable:(NSString*)idf;
-(void)refreshProductList;
@end
