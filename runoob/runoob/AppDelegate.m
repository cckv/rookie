//
//  AppDelegate.m
//  runoob
//
//  Created by zhoubaitong on 2017/8/10.
//  Copyright © 2017年 cckv. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "JYJNavigationController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    
//    ViewController *home = [[ViewController alloc]init];
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:home];
//    
//    self.window.rootViewController = nav;
//    [self.window makeKeyAndVisible];
    
//    UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default,animated: true)
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // 1.设置窗口的根控制器
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor =[UIColor whiteColor];
//    self.window.rootViewController = [[JYJNavigationController alloc] initWithRootViewController:[[mainViewController alloc] init]];
    self.window.rootViewController = [[mainViewController alloc] init];

    [self.window makeKeyAndVisible];
    
    // 2.判断程序是否是第一次打开app（数据ton）
    if([[NSUserDefaults standardUserDefaults] objectForKey:isFirstEnterApp] == nil){
        
        [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:isFirstEnterApp];
        
        NSString *currentTime = [TimeTool getCurrentTimes];
        
        [[NSUserDefaults standardUserDefaults]setObject:currentTime forKey:firstEnterAppTime];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }else{

        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:isFirstEnterApp];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    // 3.
    
    return YES;
}

@end
