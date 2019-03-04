//
//  CustomImageView.m
//  BackgroundTest
//
//  Created by cjyang on 28/02/2019.
//  Copyright © 2019 NHNENT. All rights reserved.
//

#import "CustomImageView.h"


@implementation CustomImageView


#pragma mark - override



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSLog(@"layoutSubViews call");
}


- (void)setImage:(UIImage *)image
{
    [super setImage:image];
    
    NSLog(@"setImage call");
}


@end
