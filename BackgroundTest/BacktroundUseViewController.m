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
    
    [self addButton];
    [self addCloseButton];
}


- (void)dealloc
{
    NSLog(@"dealloc call");
}


- (void)addButton
{
    UIButton *sButton = [UIButton new];
    
    [sButton setFrame:CGRectMake(200, 300, 50, 50)];
    [sButton setTitle:@"시작" forState:UIControlStateNormal];
    [sButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sButton addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:sButton];
}


- (void)addCloseButton
{
    UIButton *sButton = [UIButton new];
    
    [sButton setFrame:CGRectMake(300, 100, 50, 50)];
    [sButton setTitle:@"닫기" forState:UIControlStateNormal];
    [sButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sButton addTarget:self action:@selector(tappedCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:sButton];
}


- (void)tappedCloseButton:(id)aSender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)tappedButton:(id)aSender
{
    __block UIBackgroundTaskIdentifier taskId = UIBackgroundTaskInvalid;
    
    __block NSTimer *sTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    
    taskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        
        NSLog(@"timer call, remainingtime %lf", [[UIApplication sharedApplication] backgroundTimeRemaining]);
        
        [[UIApplication sharedApplication] endBackgroundTask:taskId];
        taskId = UIBackgroundTaskInvalid;
        
        [sTimer invalidate];
        sTimer = nil;
    }];
}


- (void)timerAction:(id)aSender
{
    NSTimeInterval sRemainingTime = [[UIApplication sharedApplication] backgroundTimeRemaining];

    NSLog(@"timer call, remainingtime %lf", [[UIApplication sharedApplication] backgroundTimeRemaining]);
}


@end
