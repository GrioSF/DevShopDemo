//
//  ApplicationNotificationUtility.h
//  Demo
//
//  Created by Eric McConkie on 3/23/13.
//  Copyright (c) 2013 Eric McConkie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplicationNotificationUtility : NSObject

-(UILocalNotification*)scheduleNotificationWithDictionary:(NSDictionary*)dict;
@end
