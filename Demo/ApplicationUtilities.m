//
//  ApplicationUtilities.m
//  Demo
//
//  Created by Eric McConkie on 3/23/13.
//  Copyright (c) 2013 Eric McConkie. All rights reserved.
//

#import "ApplicationUtilities.h"

static ApplicationUtilities *gInstance = NULL;



@implementation ApplicationUtilities




- (id)init
{
    self = [super init];
    if (self) {
        
        //util for creating our notifications
        ApplicationNotificationUtility *locUtil = [[ApplicationNotificationUtility alloc] init];
        [self setLocalNotificationUtility:locUtil];
        
        //Util extending  InAppHandler to handle our In-App Purchases
        DemoInAppHandler *handler = [[DemoInAppHandler alloc] init];
        [self setInAppHandler:handler];
        
        
        
        NSString *path = [[NSBundle mainBundle]pathForResource:@"datalist" ofType:@"plist"];
        NSArray *objects = [NSArray arrayWithContentsOfFile:path];
        [self setInstructions:objects];
    }
    return self;
}


+ (ApplicationUtilities *)instance
{
    @synchronized(self)
    {
        if (gInstance == NULL)
            gInstance = [[self alloc] init];
    }
    
    return(gInstance);
}
@end
