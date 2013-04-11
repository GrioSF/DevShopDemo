//
//  ViewController.m
//  Demo
//
//  Created by Eric McConkie on 3/23/13.
//  Copyright (c) 2013 Eric McConkie. All rights reserved.
//

#import "ViewController.h"
#import "StorefrontViewController.h"

#define kFirstLaunch @"kFirstLaunch"

@interface ViewController ()

@end

@implementation ViewController


#pragma mark -
#pragma mark public
/*
 // interperts the notification for the view
 */
-(void)handleNotification:(UILocalNotification*)localNotification
{
    NSDictionary *dict = localNotification.userInfo;
    
    //************
    //message
    //************
    NSString *msg = [dict valueForKey:@"message"];
    [self.txtViewDescription setText:msg];
    
    //************
    //image
    //************
    NSString *imageName =[dict valueForKey:@"image"];
    UIImage *image = [UIImage imageNamed:imageName];
    [self.imageView setImage:image];
}

#pragma mark -
#pragma mark action handlers
-(void)onBuy:(id)sender
{
    StorefrontViewController *purchaseVC = [[StorefrontViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:purchaseVC animated:YES];
}

-(void)onRefresh:(id)sender
{
    [[[ApplicationUtilities instance]inAppHandler]refreshProductList];
}

#pragma mark -
#pragma mark notifications
-(void)onInAppError:(NSNotification*)note
{
    NSLog(@"error loading in app data\r\n---> %@",note);
}

//once our products have loaded, we can put a buy button on the navbar
-(void)onProducts:(NSNotification*)note
{
    if ([[note object]count]>0) {
        [self setNeedsAction:YES];
    }
}

#pragma mark -
#pragma mark lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.imageView setBackgroundColor:[UIColor whiteColor]];
    
    UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStyleBordered target:self action:@selector(onRefresh:)];
    [self.navigationItem setRightBarButtonItem:refresh];
    
    //listen up!
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onInAppError:) name:kNotificationInAppRequestFailure object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onProducts:) name:kNotificationInAppProductsReceived object:nil];
    
    //kvo
    [self addObserver:self forKeyPath:@"needsAction" options:NSKeyValueObservingOptionNew context:nil];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setTitle:@"The DevShop"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"needsAction"]) {
        UIBarButtonItem *action = [[UIBarButtonItem alloc] initWithTitle:@"Store"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(onBuy:)];
        [self.navigationItem setRightBarButtonItem:action];
    }
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self removeObserver:self forKeyPath:@"needsAction"];
}


@end
