//
//  JYJMyFriendViewController.m
//  JYJSlideMenuController
//
//  Created by JYJ on 2017/6/16.
//  Copyright © 2017年 baobeikeji. All rights reserved.
//

#import "JYJMyFriendViewController.h"

#import "NSData+ImageContentType.h"

@interface JYJMyFriendViewController ()

@end

@implementation JYJMyFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *str = @"http://v7.pstatp.com/194328c94ee0cb8120addbb339fd7b43/5996a015/video/m/220bf0c2b9ddf1e48c299608af9ea538fbc114f3ad00005d4339ac86c5/";
    
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"123");
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"123");
    }];
}


@end
