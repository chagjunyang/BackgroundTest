//
//  ViewController.m
//  BackgroundTest
//
//  Created by cjyang on 27/02/2019.
//  Copyright © 2019 NHNENT. All rights reserved.
//

#import "ViewController.h"

#import "BacktroundUseViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addButton];
}


- (void)addButton
{
    UIButton *sButton = [UIButton new];
    
    [sButton setFrame:CGRectMake(200, 200, 50, 50)];
    [sButton setTitle:@"시작" forState:UIControlStateNormal];
    [sButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sButton addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:sButton];
}


- (void)tappedButton:(id)aSender
{
    BacktroundUseViewController *sVC = [BacktroundUseViewController new];
    
    [self presentViewController:sVC animated:YES completion:nil];
}



@end
