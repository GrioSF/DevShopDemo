//
//  DemoInAppHandler.m
//  Demo
//
//  Created by Eric McConkie on 3/24/13.
//  Copyright (c) 2013 Eric McConkie. All rights reserved.
//

#import "DemoInAppHandler.h"

@implementation DemoInAppHandler


/*
 For demonstration purposes, we will have a few helper methods to determine the type of purchases in our app when we handle transactions,etc
 */
-(NSDictionary*)list
{
    NSString *productLists = [[NSBundle mainBundle] pathForResource:@"products" ofType:@"plist"];
    NSDictionary *products =[NSDictionary dictionaryWithContentsOfFile:productLists];
    return products;
}
-(NSArray*)consumables
{
    NSDictionary *list = [self list];
    NSArray *consumables = [list objectForKey:kProductsConsumable];
    return consumables;
}

-(NSArray*)nonconsumables
{
    NSDictionary *list = [self list];
    NSArray *nonconsumables = [list objectForKey:kProductsNonConsumable];
    return nonconsumables;
}

-(NSSet*)productsList
{
    NSArray *consumables = [self consumables];
    NSArray *nonconsumables = [self nonconsumables];
    NSSet *setOfConsumables = [NSSet setWithArray:consumables];
    NSSet *ids = [setOfConsumables setByAddingObjectsFromArray:nonconsumables];
    return ids;
}


#pragma mark -
#pragma mark public
- (id)init
{
    self = [super init];
    if (self) {
        
        [self refreshProductList];
        /*
         // useful for offline mode, if we have that situation
         // nonetheless, always call from Apple the true restored purchases
         */
        NSSet *ids = [self productsList];
        NSMutableArray *mAr = [NSMutableArray array];
        for (NSString *anID in [ids allObjects]) {
            BOOL flag = [[NSUserDefaults standardUserDefaults] boolForKey:anID];
            if (flag) {
                [mAr addObject:anID];
            }
        }
        [self setRestorablePurchasedProducts:[NSArray arrayWithArray:mAr]];
        self.logsOutput = YES;
    }
    return self;
}

#pragma mark -
#pragma mark public
-(void)refreshProductList
{
    /*
     // NOTE:
     // in a real prodcution, we would consider getting this list of prduct identifiers more dynamically (ping a server/api)
     // for this demo, we will hard code to complete the example
     */
    NSSet *ids = [self productsList];
    [self setProductIds:ids];
    
    
    
}

-(BOOL)isNonConsumable:(NSString*)idf
{
    NSArray *plist = [self nonconsumables];
    if ([plist containsObject:idf])
        return YES;
    
    return NO;
}
@end
