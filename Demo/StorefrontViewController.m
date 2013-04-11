//
//  InAppPurchaseViewController.m
//  Demo
//
//  Created by Eric McConkie on 3/23/13.
//  Copyright (c) 2013 Eric McConkie. All rights reserved.
//

#import "StorefrontViewController.h"
#import "AJNotificationView.h"
@interface StorefrontViewController ()
@property (nonatomic,retain)NSArray *products;
@property (nonatomic,retain)NSArray *purchased;
@end

@implementation StorefrontViewController

/*
 // IE:
 // HANDLE RESTORED PRODUCTS
 */
-(void)onRestorePastPurchases:(id)sender
{
    InAppHandler *handler = [[ApplicationUtilities instance] inAppHandler];
    [handler restorePastPurchases];
}

-(void)updatePurchased
{
    InAppHandler *handler = [[ApplicationUtilities instance] inAppHandler];
    [self setPurchased:handler.restorablePurchasedProducts];
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark notifications
-(void)onRestorePastPurchasesComplete:(NSNotification*)note
{
    [self updatePurchased];
}

/*
 // Notifcation observer for successful SKTransactions (in-app purchases)
 // used to visually notify the user we have made the purchase complete
 // checks if this is nonConsumable so we can update the view with a checkmark
 */
-(void)onNewPurchaseComplete:(NSNotification*)note
{
    SKPaymentTransaction *transaction = [note object];
    NSString *productID = transaction.payment.productIdentifier;
    BOOL isNonConsumable = [[[ApplicationUtilities instance] inAppHandler]isNonConsumable:productID];
    if (isNonConsumable) {
        if (![self.purchased containsObject:productID]) {
            self.purchased = [self.purchased arrayByAddingObject:productID];
            [self.tableView reloadData];
        }
    }
    
    [AJNotificationView showNoticeInView:self.view
                                    type:AJNotificationTypeGreen title:transaction.payment.productIdentifier hideAfter:1.5];
}

#pragma mark -
#pragma mark lifecycle
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self setProducts:[[[ApplicationUtilities instance] inAppHandler]products]];
        [self updatePurchased];
        
        //listen up!
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onRestorePastPurchasesComplete:) name:kNotificationInAppAllProductRestored object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onNewPurchaseComplete:) name:kNotificationInAppProductPurchased object:nil];
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *restore = [[UIBarButtonItem alloc] initWithTitle:@"Restore" style:UIBarButtonItemStyleBordered
                                                               target:self
                                                               action:@selector(onRestorePastPurchases:)];
    [self.navigationItem setRightBarButtonItem:restore];
    [self updatePurchased];
    [self setTitle:@"The Store."];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.products count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SKProduct *product = [self.products objectAtIndex:indexPath.row];
    NSString *prId = product.localizedDescription;
    CGSize sz = [prId sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12.0 ]
                 constrainedToSize:CGSizeMake(100, 999)
                     lineBreakMode:NSLineBreakByWordWrapping];
    return sz.height + 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    if (cell==nil) {
        cell = [[UITableViewCell
                 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    SKProduct *product = [self.products objectAtIndex:indexPath.row];
    UIImage *img = nil;
    if ([product.productIdentifier hasSuffix:@"beer"]) {
        img = [UIImage imageNamed:@"beer.png"];
    }
    
    if ([product.productIdentifier hasSuffix:@"burrito"]) {
        img = [UIImage imageNamed:@"burrito.png"];
    }
    
    if ([product.productIdentifier hasSuffix:@"vacuum"]) {
        img = [UIImage imageNamed:@"vacuum.png"];
    }
    UIImageView *iv = [[UIImageView alloc] initWithImage:img];
    [iv setContentMode:UIViewContentModeScaleAspectFit];
    [iv setFrame:CGRectMake(0, 0, 50, 50)];
    [cell setAccessoryView:iv];
    [cell.textLabel setText:product.localizedTitle];
    [cell.detailTextLabel setText:product.localizedDescription];
    [cell.detailTextLabel setNumberOfLines:0];
    [cell.detailTextLabel setLineBreakMode:NSLineBreakByWordWrapping];
    
    
    //************
    //If user have non-consumable past purchases, make that known here in the UI
    //check if this is a past purchase
    //************
    for (NSString *identifier in self.purchased) {

        if ([product.productIdentifier isEqualToString:identifier]
            && [[[ApplicationUtilities instance]inAppHandler]isNonConsumable:identifier]) {
            
            //this is a past purchase
            [cell setUserInteractionEnabled:NO];
            UIImage *chck = [UIImage imageNamed:@"check"];
            UIImageView *checkView = [[UIImageView alloc] initWithImage:chck];
            [cell setAccessoryView:checkView];
            [[cell textLabel]setTextColor:[UIColor lightGrayColor]];
            
        }
        
    }
    
    return cell;
}


#pragma mark - Table view delegate
/*
 // IE:
 // Buy a product.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   SKProduct *product = [self.products objectAtIndex:indexPath.row];
    [[[ApplicationUtilities instance]inAppHandler]buy:product];
}

@end
