//
//  ViewController.h
//  Demo
//
//  Created by Eric McConkie on 3/23/13.
//  Copyright (c) 2013 Eric McConkie. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ViewController : UIViewController 
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *txtViewDescription;
@property (nonatomic)BOOL needsAction;

-(void)handleNotification:(UILocalNotification*)localNotification;
@end
