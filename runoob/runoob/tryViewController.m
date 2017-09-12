//
//  tryViewController.m
//  runoob
//
//  Created by zhoubaitong on 2017/8/18.
//  Copyright © 2017年 cckv. All rights reserved.
//

#import "tryViewController.h"

@interface tryViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView; ///< <#name#>
@end

@implementation tryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"试试看";
    
    [self.view addSubview:self.webView];
    
    NSURL *url = [NSURL URLWithString:self.to_urlStr];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:req];

}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSURL *url = [request URL] ;
    NSString *urlStr = [url relativeString];
    
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{

    NSString *str = [webView.request.URL absoluteString];
    
    if ([self.to_urlStr isEqualToString:kInviteUrl] && [str isEqualToString:kInviteUrl]) {
        
        if ([webView subviews]){
            
            UIScrollView* scrollView = [[self.webView subviews] objectAtIndex:0];
            //CGPointMake(0, 0)回到顶部
            [scrollView setContentOffset:CGPointMake(0, scrollView.contentSize.height-kScreenHeight) animated:YES];
        }
    }
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
