//
//  AppDelegate.h
//  Demo
//
//  Created by Eric McConkie on 3/23/13.
//  Copyright (c) 2013 Eric McConkie. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kApplicationLaunchState  @"kApplicationLaunchState"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@end
