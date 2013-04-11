//
//  AppDelegate.m
//  Demo
//
//  Created by Eric McConkie on 3/23/13.
//  Copyright (c) 2013 Eric McConkie. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

@interface AppDelegate()
@property (nonatomic) int currentAppState;
@end

@interface AppDelegate()
@property (nonatomic,retain)ApplicationUtilities *utils;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];

    
    ApplicationUtilities *utility = [ApplicationUtilities instance];
    [self setUtils:utility];
    
    //welcome message
    [self doNotification:0];
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSArray *arrayInstructions = [self.utils instructions];
    self.currentAppState ++;
    if (self.currentAppState > [arrayInstructions count]-1) {
        self.currentAppState = 0;
    }
    [self doNotification:self.currentAppState];
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    self.currentAppState = [[NSUserDefaults standardUserDefaults] integerForKey:kApplicationLaunchState];
   // NSLog(@"current App lauch state\r\n---> %d",self.currentAppState);
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{

    [self.viewController handleNotification:notification];
}

#pragma mark -------------->>notification on exit
-(void)doNotification:(int)idx
{
    [self.viewController.navigationController popToRootViewControllerAnimated:NO];
    //every exit will concatonate
    NSArray *arrayInstructions = [self.utils instructions];
    
    
    [[NSUserDefaults standardUserDefaults] setInteger:self.currentAppState forKey:kApplicationLaunchState];
    NSDictionary *dict = [arrayInstructions objectAtIndex:idx];
    
    //send off notification
    [[self.utils localNotificationUtility]scheduleNotificationWithDictionary:dict];
}
@end
