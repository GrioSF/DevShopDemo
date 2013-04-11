//
//  ApplicationUtilities.h
//  Demo
//
//  Created by Eric McConkie on 3/23/13.
//  Copyright (c) 2013 Eric McConkie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApplicationNotificationUtility.h"
#import "DemoInAppHandler.h"

/*
 container class to hold our utilities throught the life of the app
 */
@interface ApplicationUtilities : NSObject
@property (nonatomic,retain) NSArray *instructions;
@property (nonatomic,retain) ApplicationNotificationUtility *localNotificationUtility;
@property (nonatomic,retain) DemoInAppHandler *inAppHandler ;
+ (ApplicationUtilities *)instance;
@end
