//
//  BacktroundUseViewController.m
//  BackgroundTest
//
//  Created by cjyang on 27/02/2019.
//  Copyright © 2019 NHNENT. All rights reserved.
//

#import "BacktroundUseViewController.h"


@interface BacktroundUseViewController()

@end


@implementation BacktroundUseViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}


- (void)dealloc
{
    NSLog(@"call dealloc");
}


#pragma mark - Action


- (IBAction)tappedCloseButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)tappedTimerButton:(id)sender
{
    __block UIBackgroundTaskIdentifier taskId = UIBackgroundTaskInvalid;
    __block NSTimer *sTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    
    taskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"call expiration handler");
        
        [[UIApplication sharedApplication] endBackgroundTask:taskId];
        taskId = UIBackgroundTaskInvalid;
        
        [sTimer invalidate];
        sTimer = nil;
    }];
}


- (void)timerAction:(id)aSender
{
    NSLog(@"timer call, remainingtime %lf", [[UIApplication sharedApplication] backgroundTimeRemaining]);
}


@end
