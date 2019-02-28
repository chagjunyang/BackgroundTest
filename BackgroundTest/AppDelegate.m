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
    return YES;
}


// 앱이 백그라운드에 있는 경우 앱이 중지될 수 있고, 이 경우 다운로드가 끝나면 시스템에서 아래 메소드 호출
// completionHandler를 들고있다가 호출하면 앱의 사용자 인터페이스가 업데이트되고 새 스냅샷을 가져올 수 있을음 시스템에게 알림
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler
{
    _backgroundURLSessionCompletionHandler = completionHandler;
}


@end
