//
//  detailViewController.m
//  runoob
//
//  Created by zhoubaitong on 2017/8/15.
//  Copyright © 2017年 cckv. All rights reserved.
//

#import "detailViewController.h"

#import "MBProgressHUD.h"
#import "JYJNavigationController.h"
#import "tryViewController.h"
#import "HyBridBridge.h"

#import <JavaScriptCore/JSContext.h>

@interface detailViewController ()<UIWebViewDelegate,HybridUrlHanlder>


@property (nonatomic, copy) NSString *urlStr; ///< <#name#>


@property (nonatomic, strong) UIWebView *webView; ///< <#name#>
@property (nonatomic, strong) MBProgressHUD *HUD;

@property (nonatomic, copy) NSString *currentTitle; ///< <#name#>
@property (nonatomic, copy) NSString *currentReadURL; ///< <#name#>

@property (nonatomic, strong) WebViewJavascriptBridge* bridge;
@property (strong, nonatomic) HyBridBridge *hybridBridge;
@end

@implementation detailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.to_urlStr.length>0) {
        
        self.urlStr = self.to_urlStr;
        
    }else{
        
        NSArray *dataArray = [self.dataStr componentsSeparatedByString:@"href"];
        NSString *dataA = dataArray[1];
        NSArray *dataB = [dataA componentsSeparatedByString:@"\""];
        
        NSString *urlStr = [dataB[1] substringFromIndex:2];
        
        urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        urlStr = [NSString stringWithFormat:@"http://%@",urlStr];
        
        self.urlStr = urlStr;
    }
    
    [self.view addSubview:self.webView];
    
    NSURL *url = [NSURL URLWithString:self.urlStr];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:req];

        
    if ([self.title isEqualToString:@"菜鸟教程"]) {
        
    }else{
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:@"收藏" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn sizeToFit];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
        [self.navigationItem setRightBarButtonItem:item];
        [btn addTarget:self action:@selector(college) forControlEvents:UIControlEventTouchUpInside];

    }
    
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //显示的文字
    self.HUD.labelText = @"加载中...";
    //是否有庶罩
    self.HUD.dimBackground = NO;
    [self.HUD show:YES];
    
    [self.bridge setWebViewDelegate:self];
    [self.hybridBridge registerHybridUrlHanlder:self andBridge:self.bridge];
    
    [self.bridge callHandler:@"testJavascriptHandler" data:@{ @"foo":@"before ready" }];
    [self.bridge registerHandler:@"wp-content/themes/runoob/option/addnote.php" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"234");
    }];
    
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"log"] = ^() {
        
        NSLog(@"+++++++Begin Log+++++++");
        NSArray *args = [JSContext currentArguments];
        
        for (JSValue *jsVal in args) {
            NSLog(@"%@", jsVal);
        }
        
        JSValue *this = [JSContext currentThis];
        NSLog(@"this: %@",this);
        NSLog(@"-------End Log-------");
        
    };
}

- (void)college
{
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //显示的文字
     self.HUD.mode = MBProgressHUDModeAnnularDeterminate;
    self.HUD.labelText = @"收藏成功";
    //是否有庶罩
    self.HUD.dimBackground = NO;
    [self.HUD show:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.HUD hide:YES];
    });
    
    collectModel *model = [collectModel new];
    model.type = self.type;
    model.title = self.currentTitle;
    model.currentReadURL = self.currentReadURL;
    [model save];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSLog(@"123");
}

//http://www.runoob.com/wp-content/themes/runoob/option/addnote.php
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    NSURL *url = [request URL] ;
    NSString *urlStr = [url relativeString];
    
//    [self.bridge callHandler:@"" data:nil responseCallback:^(id responseData) {
//        
//    }];
    
    if([urlStr rangeOfString:@"runoob.com"].location !=NSNotFound)
    {
        if ([urlStr hasPrefix:@"http://www.runoob.com/try"]) {
            
            tryViewController *tryVc = [[tryViewController alloc]init];
            tryVc.to_urlStr = urlStr;
            JYJNavigationController *navi = [[JYJNavigationController alloc]initWithRootViewController:tryVc];
            
            UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            negativeSpacer.width = -15;
            
            UIButton *button = [[UIButton alloc] init];
            // 设置按钮的背景图片
            [button setImage:[UIImage imageNamed:@"navigation_back_normal"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"navigation_back_hl"] forState:UIControlStateHighlighted];
            // 设置按钮的尺寸为背景图片的尺寸
            button.frame = CGRectMake(0, 0, 33, 33);
            
            //监听按钮的点击
            [button addTarget:tryVc action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
            
            //设置导航栏的按钮
            UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
            
            tryVc.navigationItem.leftBarButtonItems = @[negativeSpacer, backButton];
            
            [self presentViewController:navi animated:YES completion:^{
                
            }];
            
            return NO;
        }
        
        if ([urlStr isEqualToString:kInviteUrl]) {
            tryViewController *tryVc = [[tryViewController alloc]init];
            tryVc.to_urlStr = urlStr;
            JYJNavigationController *navi = [[JYJNavigationController alloc]initWithRootViewController:tryVc];
            
            UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            negativeSpacer.width = -15;
            
            UIButton *button = [[UIButton alloc] init];
            // 设置按钮的背景图片
            [button setImage:[UIImage imageNamed:@"navigation_back_normal"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"navigation_back_hl"] forState:UIControlStateHighlighted];
            // 设置按钮的尺寸为背景图片的尺寸
            button.frame = CGRectMake(0, 0, 33, 33);
            
            //监听按钮的点击
            [button addTarget:tryVc action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
            
            //设置导航栏的按钮
            UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
            
            tryVc.navigationItem.leftBarButtonItems = @[negativeSpacer, backButton];
            
            [self presentViewController:navi animated:YES completion:^{
                
            }];
            
            return NO;

        }
        
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.HUD hide:YES];
    //隐藏back按钮
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSString *currentReadURL = [webView.request.URL absoluteString];
    
    self.currentTitle = title;
    self.currentReadURL = currentReadURL;
    
    currentReadModel *model = [currentReadModel new];
    model.title = title;
    model.currentReadURL = currentReadURL;
    [currentReadModel clearTable];
    [model save];

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

}

- (void)getData:(NSString*)urlStr
{
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
        
        TFHpple *Hpple = [[TFHpple alloc]initWithHTMLData:data];
        
        NSArray *TRElements1 = [Hpple searchWithXPathQuery:@"//div[@class = 'container main']"];
        

        for (TFHppleElement *item in TRElements1) {
            NSArray *TRElements2 = [item searchWithXPathQuery:@"//div[@class = 'row']"];
            
            for (TFHppleElement *item in TRElements2) {
                
                NSArray *leftData = [item searchWithXPathQuery:@"//div[@class = 'col left-column']"];
                for (TFHppleElement *item in leftData) {
                    NSArray *leftData = [item searchWithXPathQuery:@"//div[@class = 'silebar-box gallery-list']"];
                    NSLog(@"123");
                }
                
                NSArray *rightData = [item searchWithXPathQuery:@"//div[@class = 'col middle-column']"];
                for (TFHppleElement *item in rightData) {
                    NSArray *leftData = [item searchWithXPathQuery:@"//div[@class = 'article']"];
                    NSLog(@"123");
                }
                NSLog(@"123");
            }
            
        }
        
        NSLog(@"123");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",@"123");
        
    }];
    
}

-(UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc]init];
//        _webView.frame = self.view.bounds;
        _webView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);
        _webView.delegate = self;
    }
    return _webView;
}

-(WebViewJavascriptBridge *)bridge
{
    if (!_bridge) {
        //    简单的初始化 注册方法   WebViewJavascriptBridge 有详细的介绍
        [WebViewJavascriptBridge enableLogging];
        
        _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    }
    return _bridge;
}

//懒加载
- (HyBridBridge *)hybridBridge {
    if (!_hybridBridge) {
        _hybridBridge = [[HyBridBridge alloc] init];
    }
    return _hybridBridge;
}

#pragma mark - HybridUrlHanlder

- (NSArray *)actionNames {  //定义可支持的方法名称
    return @[ @"selectionchanged", @"tabbar", @"push", @"showToast", @"pay" ];
}

//HTML 部分 需要定义 方法名称
//传参的时候 带上方法名字  我这里写的是actionName
- (BOOL)handleDictionAry:(NSDictionary *)dictionary callback:(HybridCallbackBlock)callbackBlock {
    NSString *actionTag = dictionary[@"actionName"];
    if ([actionTag isEqualToString:@"login"]) {
        [self nativeLogin];
        return YES;
    } else if ([actionTag isEqualToString:@"tabbar"]) {
        [self nativeAppHome:[dictionary[@"tab"] intValue]];
        return YES;
    } else if ([actionTag isEqualToString:@"push"]) {
        [self nativePushSubViewControllerWithDeatilID:[dictionary[@"detailID"] integerValue]];
        return YES;
    } else if ([actionTag isEqualToString:@"showToast"]) {
//        [self.view makeToast:dictionary[@"message"] duration:1.0f position:CSToastPositionCenter];
        return YES;
    } else if ([actionTag isEqualToString:@"pay"]) {
        [self nativePushPayViewControllerWithOrderID:[dictionary[@"orderID"] integerValue] Callback:callbackBlock];
        return YES;
    }
    
    return NO;
}

#pragma mark - 方法的实现

- (void)nativeLogin {
//    LoginViewController *loginVC = [[LoginViewController alloc]init];
//    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:loginVC];
//    [self presentViewController:navigation animated:YES completion:nil];
}

- (void)nativeAppHome:(NSInteger)tabIndex {
    UITabBarController *tabBarC = self.navigationController.tabBarController;
    if (tabIndex < 0 || tabIndex >= tabBarC.viewControllers.count) {
        return;
    }
    if (tabBarC.selectedIndex == tabIndex) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        self.navigationController.tabBarController.selectedIndex = tabIndex;
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}

- (void)nativePushSubViewControllerWithDeatilID:(NSInteger)deatilID {
//    DetailViewController *detailVC = [[DetailViewController alloc]init];
//    [self.navigationController pushViewController:detailVC animated:YES];
}


- (void)nativePushPayViewControllerWithOrderID:(NSInteger)orderID Callback:(HybridCallbackBlock)callbackBlock{
//    LDPayViewController * payVC = [[LDPayViewController alloc]init];
//    payVC.orderId = orderID;
//    payVC.resultBlock = ^(BOOL isPaySucc){  //回调参数  Block 相信大家都会用吧
//        if (isPaySucc){
//            callbackBlock(YES,@{ @"code": @(10000), @"message" : @"支付成功"});
//        }else{
//            callbackBlock(YES,@{ @"code": @(10001), @"message" : @"支付失败" });
//        }
//    };
//    [self.navigationController pushViewController:payVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
