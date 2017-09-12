//
//  ViewController.m
//  runoob
//
//  Created by zhoubaitong on 2017/8/10.
//  Copyright © 2017年 cckv. All rights reserved.
//

#import "ViewController.h"

#import "AFNetworking.h"
#import "TFHpple.h"
#import "CollectionViewCell.h"
#import "CollectionReusableView.h"
#import "MBProgressHUD.h"
#import "detailViewController.h"
#import "JYJSliderMenuTool.h"


@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate,CollectionReusableViewDeleate>

@property (nonatomic, strong) UICollectionView *collectionView;


@property (nonatomic, strong) NSArray *titleArray; ///< <#name#>
@property (nonatomic, strong) NSMutableArray *contentDataArray; ///< <#name#>
@property (nonatomic, strong) NSMutableArray *urlDataArray; ///< <#name#>

@property (nonatomic, strong) UIButton *openBtn; ///< <#name#>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Rookie";
    
//    [self swipeGestureRecognizer];

    [self setUpViews];
    
    [self getNetWork];
    
    [self getCache];
    
    [self getData];

}
//清扫手势
-(void)swipeGestureRecognizer
{
    
    UISwipeGestureRecognizer *swipe =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
    //配置属性
    //一个清扫手势  只能有两个方向(上和下) 或者 (左或右)
    //如果想支持上下左右清扫  那么一个手势不能实现  需要创建两个手势
    swipe.direction =UISwipeGestureRecognizerDirectionLeft;
    //添加到指定视图
    [self.view addGestureRecognizer:swipe];
    UISwipeGestureRecognizer *swipe2 =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
    swipe2.direction =UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipe2];
    
}
//清扫事件
-(void)swipeAction:(UISwipeGestureRecognizer *)swipe
{
    
    if (swipe.direction ==UISwipeGestureRecognizerDirectionRight){
        
        [self show];
        
    }else if(swipe.direction == UISwipeGestureRecognizerDirectionLeft){
        NSLog(@"左扫一下");
    }
    
}

#pragma mark - 基础设置
- (void)getNetWork
{
    //监听网络
    AFNetworkReachabilityManager *netManager = [AFNetworkReachabilityManager sharedManager];
    [netManager startMonitoring];  //开始监听
    [netManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
        
        if (status == AFNetworkReachabilityStatusNotReachable)
        {
            if ([[[NSUserDefaults standardUserDefaults]objectForKey:isFirstEnterApp]isEqualToString:@"YES"]) {
                
                MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                //显示的文字
                HUD.labelText = @"请在设置中打开此应用的网络访问";
                //是否有庶罩
                HUD.dimBackground = NO;
                [HUD show:YES];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [HUD hide:YES];
                });
            }
        }else if (status == AFNetworkReachabilityStatusUnknown){
            
            if ([[[NSUserDefaults standardUserDefaults]objectForKey:isFirstEnterApp]isEqualToString:@"YES"]) {
                
                MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                //显示的文字
                HUD.labelText = @"请检查您的网络";
                //是否有庶罩
                HUD.dimBackground = NO;
                [HUD show:YES];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [HUD hide:YES];
                });
            }
            
        }else if ((status == AFNetworkReachabilityStatusReachableViaWWAN)||(status == AFNetworkReachabilityStatusReachableViaWiFi)){
            
            if ([[[NSUserDefaults standardUserDefaults]objectForKey:isFirstEnterApp]isEqualToString:@"YES"]) {
                // 请求数据
                [self getData];
            }
        }
        
    }];
}
- (void)open:(UIButton*)btn
{
    btn.selected = !btn.selected;
    
    for (int i = 0; i<self.contentDataArray.count; i++) {
        NSDictionary *dict = self.contentDataArray[i];
        NSString *openStr = dict[@"open"];
        if (btn.selected) {
            openStr = @"0";
        }else{
            openStr = @"1";
        }
        NSDictionary *d = @{
                            @"open":openStr,
                            @"dataArray":dict[@"dataArray"]
                            };
        [self.contentDataArray replaceObjectAtIndex:i withObject:d];
    }
    
    [self.collectionView reloadData];
    NSLog(@"%@",btn.currentTitle);
}

/** 展示左边的侧页 */
- (void)show
{
    [JYJSliderMenuTool showWithRootViewController:self];
}
/** 侧滑展示左边的侧页 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    BOOL result = NO;
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        result = YES;
    }
    return result;
}

- (void)moveViewWithGesture:(UIPanGestureRecognizer *)panGes {
    if (panGes.state == UIGestureRecognizerStateEnded) {
        [self show];
    }
}

/** 获取缓存 */
- (void)getCache
{
    [self.urlDataArray removeAllObjects];
    [self.contentDataArray removeAllObjects];
    self.urlDataArray = [KVNetWorkCacheTool cacheJsonWithURL:@"urlDataArray"];
    self.contentDataArray = [KVNetWorkCacheTool cacheJsonWithURL:@"contentDataArray"];
    [self.collectionView reloadData];
}

/** 设置控件 */
- (void)setUpViews
{
    [self.view addSubview:self.collectionView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor whiteColor];
//    self.collectionView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight);
//    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"个人 用户.png"] forState:UIControlStateNormal];
    [btn sizeToFit];
    btn.frame = CGRectMake(0, 0, 32, 32);
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:item];
    [btn addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn sizeToFit];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [rightBtn setImage:[[UIImage imageNamed:@"展开.png"] imageByTintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [rightBtn setImage:[[UIImage imageNamed:@"展开 (1).png"] imageByTintColor:[UIColor whiteColor]] forState:UIControlStateSelected];
//    [rightBtn setTitle:@"收起" forState:UIControlStateNormal];
//    [rightBtn setTitle:@"展开" forState:UIControlStateSelected];
    rightBtn.frame = CGRectMake(0, 0, 32, 32);
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:item2];
    [rightBtn addTarget:self action:@selector(open:) forControlEvents:UIControlEventTouchUpInside];
    self.openBtn = rightBtn;
    
    // 屏幕边缘pan手势(优先级高于其他手势)
    UIScreenEdgePanGestureRecognizer *leftEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self
                                                                                                          action:@selector(moveViewWithGesture:)];
    leftEdgeGesture.edges = UIRectEdgeLeft;// 屏幕左侧边缘响应
    [self.view addGestureRecognizer:leftEdgeGesture];
    // 这里是地图处理方式，遵守代理协议，实现代理方法
    leftEdgeGesture.delegate = self;
}

#pragma mark - collectionView的代理方发
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.titleArray.count;
}
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.contentDataArray.count>0) {
        
        NSDictionary *dict = self.contentDataArray[section];
        BOOL open = [dict[@"open"] boolValue];
        if (open) {
            NSArray *arr  = dict[@"dataArray"];
            return arr.count;
        }else{
            return 0;
        }
        
    }else{
        return 0;
    }

}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CollectionViewCell class]) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:(246/255.0) green:(246/255.0) blue:(246/255.0) alpha:1];
    NSDictionary *dict = self.contentDataArray[indexPath.section];
    cell.dataArray = dict[@"dataArray"][indexPath.row];
    cell.urlArray = self.urlDataArray[indexPath.section][indexPath.row];
    return cell;
    
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenWidth/2 - 15, 85);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSArray *arr = self.contentDataArray[indexPath.section][indexPath.row];
    NSDictionary *dict = self.contentDataArray[indexPath.section];
    NSArray *arr = dict[@"dataArray"][indexPath.row];
    
    NSString *dataStr = self.urlDataArray[indexPath.section][indexPath.row];
    
    NSString *title = self.titleArray[indexPath.section];
    
    homeItem *item = [homeItem new];
    item.title = title;
    item.dataStr = dataStr;
    item.itemTitle = arr[0];
    item.itemDesc = arr[2];
    
    NSArray *itemArr = [homeItem findAll];
    BOOL reHave = NO;
    for (homeItem *item1 in itemArr) {
        if ([item1.dataStr isEqualToString:item.dataStr]) {
            reHave = YES;
        }
    }
    if (!reHave) {
        [item save];
    }
    
    detailViewController *detailVc = [[detailViewController alloc]init];
    detailVc.type = title;
    detailVc.title = arr[0];
    detailVc.dataStr = dataStr;
    [self.navigationController pushViewController:detailVc animated:YES];
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView = nil;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:NSStringFromClass([CollectionReusableView class])
                                                                 forIndexPath:indexPath];
        CollectionReusableView * header = (CollectionReusableView*)reusableView;
        reusableView = header;
        header.delegate = self;
        header.index = indexPath.section;
        header.backgroundColor = [UIColor whiteColor];
        header.title = self.titleArray[indexPath.section];
    }
    return reusableView;
}

-(void)CollectionReusableView:(CollectionReusableView *)headView clickHeadViewWith:(int)index
{

    NSDictionary *dict = self.contentDataArray[index];
    BOOL open = [dict[@"open"] boolValue];
    NSString *openStr = nil;
    if (open) {
        openStr = @"0";
    }else{
        openStr = @"1";
    }
    NSDictionary *dataD = @{
                            @"open":openStr,
                            @"dataArray":dict[@"dataArray"]
                            };
    [self.contentDataArray replaceObjectAtIndex:index withObject:dataD];
        
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:index];
    [self.collectionView reloadSections:set];
    
}

// 头视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, 50);
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - 网络请求数据
- (void)getData
{
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:kBaseUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.urlDataArray removeAllObjects];
        [self.contentDataArray removeAllObjects];
        
        //        NSLog(@"%@",responseObject);
        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
        //        NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];   //data转字符串 为了打印不是乱码
        //        NSLog(@"------%@",result);
        
        TFHpple *Hpple = [[TFHpple alloc]initWithHTMLData:data];
        //        NSArray *TRElements1 =[Hpple searchWithXPathQuery:@"//div"]; //获取到为title的标题
        NSArray *TRElements1 = [Hpple searchWithXPathQuery:@"//div[@class = 'col left-column']"];
        for (TFHppleElement *HppleElement in TRElements1) {
            NSLog(@"%@",HppleElement.content);
            NSString *sre = HppleElement.content;
            
            sre = [sre stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            sre = [sre stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            NSLog(@"%@",sre);
            
            NSArray *titleArray = [sre componentsSeparatedByString:@" "];
            
            NSLog(@"%@",titleArray);
        }
        
        NSArray *TRElements2 = [Hpple searchWithXPathQuery:@"//div[@class = 'col middle-column-home']"];
        
        for (TFHppleElement *HppleElement in TRElements2) {
            
            for (int i = 1; i<11; i++) {
                
                NSString *str = [NSString stringWithFormat:@"//div[@class = 'codelist codelist-desktop cate%d']",i];
                
                NSArray *TRElements3 = [HppleElement searchWithXPathQuery:str];
                
                NSMutableArray *contentArray = [NSMutableArray array];
                
                NSMutableArray *urlArray = [NSMutableArray array];
                
                for (TFHppleElement *HppleElement in TRElements3) {
                    
                    NSLog(@"%@",HppleElement.content);
                    
                    NSArray *TRElements4 = [HppleElement searchWithXPathQuery:@"//a[@class = 'item-top item-1']"];
                    
                    //                    NSArray *childArray = HppleElement.children;
                    
                    //                    TFHppleElement *dataDict = childArray[3];
                    //                    NSLog(@"%@",dataDict.raw);
                    
                    
                    
                    for (TFHppleElement *HppleElement in TRElements4) {
                        
                        NSLog(@"%@",HppleElement.content);
                        
                        NSLog(@"%@",HppleElement.raw);
                        
                        NSString *content = HppleElement.content;
                        
                        NSLog(@"%@",content);
                        NSArray *conArray = [content componentsSeparatedByString:@"\n"];
                        NSLog(@"%@",contentArray);
                        
                        [urlArray addObject:HppleElement.raw];
                        [contentArray addObject:conArray];
                    }
                }
                
                [self.urlDataArray addObject:urlArray];
                
                NSDictionary *dict = @{
                                       @"open":@(1),
                                       @"dataArray":contentArray
                                       };
                
                [self.contentDataArray addObject:dict];
                
                
                [KVNetWorkCacheTool save_asyncJsonResponseToCacheFile:self.urlDataArray andURL:@"urlDataArray" completed:^(BOOL result) {
                    
                }];
                
                [KVNetWorkCacheTool save_asyncJsonResponseToCacheFile:self.contentDataArray andURL:@"contentDataArray" completed:^(BOOL result) {
                    
                }];
                
            }
            //            [self.urlDataArray addObject:urlArray];
            
            NSLog(@"123");
            
            //            NSArray *TRElements3 = HppleElement.children;
            //
            //            for (TFHppleElement *HppleElement in TRElements3) {
            //
            //                NSArray *TRElements4 = HppleElement.children;
            //
            //                for (TFHppleElement *HppleElement in TRElements4) { // 取出每一个类
            //
            ////                    NSLog(@"%@",HppleElement.content);
            //                    NSArray *TRElements5 = HppleElement.children;
            //
            //                    for (TFHppleElement *HppleElement in TRElements5) { // 取出每个子类
            //
            //                        NSLog(@"%@",HppleElement.content);
            //
            //
            //                    }
            //
            //                }
            //
            //            }
            
        }
        
        [self.collectionView reloadData];
        
        //        for (TFHppleElement *HppleElement in TRElements1) {
        //            NSLog(@"测试1的目的标签内容:-- %@",HppleElement.text);
        //            if ([[HppleElement objectForKey:@"class"] isEqualToString:@"container main"]) {
        //
        //                NSArray *TRElements2 =[Hpple searchWithXPathQuery:@"//div"]; //获取到为title的标题
        //                for (TFHppleElement *HppleElement in TRElements2) {
        //                    NSLog(@"测试2的目的标签内容:-- %@",HppleElement.text);
        //
        //                    if ([[HppleElement objectForKey:@"class"] isEqualToString:@"row"]) {
        //                        NSArray *TRElements3 =[Hpple searchWithXPathQuery:@"//div"]; //获取到为title的标题
        //                        for (TFHppleElement *HppleElement in TRElements3) {
        //                            NSLog(@"测试3的目的标签内容:-- %@",HppleElement.text);
        //
        //                            if ([[HppleElement objectForKey:@"class"] isEqualToString:@"tab"]) {
        //                                NSArray *TRElements4 =[Hpple searchWithXPathQuery:@"//div"]; //获取到为title的标题
        //                                for (TFHppleElement *HppleElement in TRElements4) {
        //                                    NSLog(@"测试4的目的标签内容:-- %@",HppleElement.text);
        //
        //                                    if ([[HppleElement objectForKey:@"class"] isEqualToString:@"sidebar-box gallery-list"]) {
        //                                        NSArray *TRElements5 =[Hpple searchWithXPathQuery:@"//div"]; //获取到为title的标题
        //                                        for (TFHppleElement *HppleElement in TRElements5) {
        //                                            NSLog(@"测试4的目的标签内容:-- %@",HppleElement.text);
        //
        //                                            if ([[HppleElement objectForKey:@"class"] isEqualToString:@"col left-column"]) {
        //                                                NSArray *TRElements6 =[Hpple searchWithXPathQuery:@"//div"]; //获取到为title的标题
        //                                                for (TFHppleElement *HppleElement6 in TRElements6) {
        //                                                    NSLog(@"测试4的目的标签内容:-- %@",HppleElement.text);
        //
        //                                                    if ([[HppleElement6 objectForKey:@"class"] isEqualToString:@"navto-nav"]) {
        //
        //                                                    }
        //                                                }
        //                                            }
        //                                        }
        //                                    }
        //                                }
        //                            }
        //                        }
        //                    }
        //                }
        //
        //            }
        //        }
        
        //测试1：获取简单的标题
        //        div
        //        NSArray *TRElements =[Hpple searchWithXPathQuery:@"//h2"]; //获取到为title的标题
        //
        //        for (TFHppleElement *HppleElement in TRElements) {
        //
        //            NSLog(@"测试1的目的标签内容:-- %@",HppleElement.text);
        //
        //
        //            NSArray *arr =[HppleElement searchWithXPathQuery:@"//a"]; //获取到为title的标题
        //
        //            for (TFHppleElement *HppleElement in arr) {
        //
        //                if ([HppleElement text] != nil) {
        //
        //                    NSLog(@"%@", [HppleElement text]);
        //                }
        //
        //                if ([[HppleElement objectForKey:@"class"] isEqualToString:@"item-top item-1"]) {
        //                    NSLog(@"%@",HppleElement.text);
        //
        //                }
        //            }
        //
        //        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
        NSLog(@"code:%ld",(long)response.statusCode);// 状态码
        if (response.statusCode == 403) {
            //方式1.直接在浏览上显示
            MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            HUD.labelText = @"访问过于频繁！您已被限制访问";
            //是否有庶罩
            HUD.dimBackground = NO;
            [HUD show:YES];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [HUD hide:YES];
            });
            
        }
    }];
    
}
#pragma mark - 懒加载
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        
        UICollectionView *cv = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView = cv;
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        //注册Cell，必须要有
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([CollectionViewCell class])];

        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CollectionReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([CollectionReusableView class])];
        
    }
    return _collectionView;
}

-(NSMutableArray *)urlDataArray
{
    if (!_urlDataArray) {
        _urlDataArray = [NSMutableArray array];
    }
    return _urlDataArray;
}
-(NSMutableArray *)contentDataArray
{
    if (!_contentDataArray) {
        _contentDataArray = [NSMutableArray array];
    }
    return _contentDataArray;
}
-(NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = @[@"HTML/CSS",@"JavaScript",@"服务端",@"数据库", @"移动端", @"XML教程", @"ASP.NET", @"Web Service", @"开发工具" ,@"网站建设"];
    }
    return _titleArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
