//
//  ApplicationNotificationUtility.m
//  Demo
//
//  Created by Eric McConkie on 3/23/13.
//  Copyright (c) 2013 Eric McConkie. All rights reserved.
//

#import "ApplicationNotificationUtility.h"



@implementation ApplicationNotificationUtility




-(UILocalNotification*)scheduleNotificationWithDictionary:(NSDictionary*)dict
{
    UILocalNotification *locNote = [[UILocalNotification alloc] init];
    [locNote setAlertBody:[dict valueForKey:@"alertBody"]];
    [locNote setAlertLaunchImage:[dict valueForKey:@"alertLaunchImage"]];
    [locNote setUserInfo:[dict valueForKey:@"userInfo"]];
    int delay = [[dict valueForKey:@"delay"] intValue];
    [locNote setFireDate:[NSDate dateWithTimeInterval:delay
                                            sinceDate:[NSDate date]]];
    
    [[UIApplication sharedApplication]scheduleLocalNotification:locNote];
    return locNote;
}
@end
