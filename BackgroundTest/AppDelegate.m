//
//  AppDelegate.m
//  BackgroundTest
//
//  Created by cjyang on 27/02/2019.
//  Copyright © 2019 NHNENT. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    return YES;
}


-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [API fetchSomeData:^(NSError *aError){
        if(aError != nil)
        {
            completionHandler(UIBackgroundFetchResultNo);
        }
        else
        {
            completionHandler(UIBackgroundFetchResultNoData);
        }
    }];
}


@end
