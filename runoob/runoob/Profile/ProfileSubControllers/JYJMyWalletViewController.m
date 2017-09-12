//
//  JYJMyWalletViewController.m
//  JYJSlideMenuController
//
//  Created by JYJ on 2017/6/16.
//  Copyright © 2017年 baobeikeji. All rights reserved.
//

#import "JYJMyWalletViewController.h"
#import "currentReadView.h"
#import "browseLogView.h"

#import "MYReadView.h"

#import "readItem.h"

#import "PNChart.h"


@interface JYJMyWalletViewController ()<MYReadViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIScrollView *scrollView; ///< <#name#>
@property (nonatomic, strong) browseLogView *bv1;
@property (nonatomic, strong) browseLogView *bv2;
@property (nonatomic, strong) browseLogView *bv3;
@property (nonatomic, strong) browseLogView *bv4;
@property (nonatomic, strong)MYReadView *readV;
@property (nonatomic, strong) currentReadModel *currentReadModel;

@property (nonatomic, strong) UILabel *showPowerLabel;

@property (nonatomic, strong) NSMutableArray *dataArray; ///< <#name#>


@property (nonatomic, strong) UICollectionView *collectionView; ///< <#name#>

@end

@implementation JYJMyWalletViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.currentReadModel = [[currentReadModel findAll] firstObject];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentReadModel = [[currentReadModel findAll] firstObject];
    
    [self setUpViews];
    
    NSArray *homeItemCache = [homeItem findAll];
    NSLog(@"%@",homeItemCache);
    
    [self setData:homeItemCache];
    
}

-(void)clickBtn:(currentReadModel *)model
{
    detailViewController *detailVc = [[detailViewController alloc]init];
    detailVc.title = @"菜鸟教程";
    detailVc.to_urlStr = model.currentReadURL;
    [self.navigationController pushViewController:detailVc animated:YES];

}

-(void)setCurrentReadModel:(currentReadModel *)currentReadModel
{
    _currentReadModel = currentReadModel;
    
    self.readV.model = currentReadModel;
}

- (void)setData:(NSArray*)dataArray
{
    NSLog(@"%lu",(unsigned long)dataArray.count);
    NSMutableArray *dataArr = [self handleData:dataArray];
    self.dataArray = dataArr;
    
    [self setPower:dataArray.count];
    
}
- (void)setPower:(int)cnt
{
    if (cnt <= 0) {
        self.showPowerLabel.text = @"菜鸟";
    }else if (cnt>0 && cnt<=3)
    {
        self.showPowerLabel.text = @"小鸟";
    }else if (cnt>3 && cnt<=9)
    {
        self.showPowerLabel.text = @"老鸟";
    }else if (cnt>9 && cnt<=20)
    {
        self.showPowerLabel.text = @"人才";
    }else
    {
        self.showPowerLabel.text = @"大神";
    }
}
// 数组分类重组
- (NSMutableArray*)handleData:(NSArray*)dataArray
{
    NSMutableArray *resultArr = [NSMutableArray array];
    
    NSMutableArray *tempArr = [dataArray mutableCopy];
    
    homeItem *firstItem = tempArr.firstObject;
    
    while (tempArr.count>0) {
        
        NSMutableArray *arr = [NSMutableArray array];
        
        for (homeItem *item in tempArr) {
            
            if ([item.title isEqualToString:firstItem.title]) {
                [arr addObject:item];
            }
        }
        
        [resultArr addObject:arr];
        [tempArr removeObjectsInArray:arr];
        
        firstItem = tempArr.firstObject;

    }
    
    return resultArr;
}

- (void)setUpViews
{

    browseLogView *bv1 = [browseLogView viewFromXib];
    self.bv1 = bv1;
    bv1.titleL.text = @"   当前阅读";
    bv1.frame = CGRectMake(10, 30, kScreenWidth - 20, 80);
    [self.scrollView addSubview:bv1];

    MYReadView *readV = [MYReadView viewFromXib];
    self.readV = readV;
    readV.frame = self.bv1.contentV.bounds;
    readV.model = self.currentReadModel;
    readV.delegate = self;
    [self.bv1.contentV addSubview:readV];
    
    
    browseLogView *bv2 = [browseLogView viewFromXib];
    self.bv2 = bv2;
    bv2.titleL.text = @"   技能 Get";
    bv2.frame = CGRectMake(10, CGRectGetMaxY(bv1.frame)+ 20, kScreenWidth - 20, 90);
    [self.bv2.contentV addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:bv2];
    
    browseLogView *bv3 = [browseLogView viewFromXib];
    self.bv3 = bv3;
    bv3.titleL.text = @"   一直在努力";
    bv3.frame = CGRectMake(10, CGRectGetMaxY(bv2.frame)+ 20, kScreenWidth - 20, 300);
    [self.scrollView addSubview:bv3];
    //对于折线图
    PNLineChart *lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake( 0, 10,kScreenWidth - 20, 250.0)];
    [self.bv3.contentV addSubview:lineChart];
    lineChart.yFixedValueMax = 100;
    lineChart.yFixedValueMin = 0;
    [lineChart setXLabels: @ [ @"SEP 1 ", @"SEP 2 ", @"SEP 3 ", @"SEP 4 ", @"SEP 5 " , @"SEP 2 ", @"SEP 3 ", @"SEP 4 ", @"SEP 5 " ]];
    
    // Line Chart No.1
    NSArray * data01Array = @ [@ 0,@ 15,@ 55,@ 32,@ 46,@ 15,@ 55,@ 32,@ 46 ];
    PNLineChartData * data01 = [PNLineChartData new ];
    data01.color = PNFreshGreen;
    data01.itemCount = lineChart.xLabels.count;
    data01.getData = ^(NSUInteger index){
        CGFloat yValue = [data01Array [ index ] floatValue ];
        return [PNLineChartDataItem dataItemWithY: yValue];
    };
    // Line Chart No.2
//    NSArray * data02Array = @ [@ 20.1,@ 180.1,@ 26.4,@ 202.2,@ 126.2 ];
//    PNLineChartData * data02 = [PNLineChartData new ];
//    data02.color = PNTwitterColor;
//    data02.itemCount = lineChart.xLabels.count;
//    data02.getData = ^(NSUInteger index){
//        CGFloat yValue = [data02Array [ index ] floatValue ];
//        return [PNLineChartDataItem dataItemWithY: yValue];
//    };
    
    lineChart.chartData = @ [data01];
    [lineChart strokeChart ];
    
    browseLogView *bv4 = [browseLogView viewFromXib];
    self.bv4 = bv4;
    bv4.titleL.text = @"   综合评估";
    bv4.frame = CGRectMake(10, CGRectGetMaxY(bv3.frame)+ 20, kScreenWidth - 20, 80);
    [self.scrollView addSubview:bv4];
    UILabel *showPowerLabel = [[UILabel alloc]init];
    self.showPowerLabel = showPowerLabel;
    showPowerLabel.frame = CGRectMake(15, 0, kScreenWidth/2, 50);
    showPowerLabel.font = [UIFont systemFontOfSize:17];
    showPowerLabel.textColor = [UIColor orangeColor];
    [self.bv4.contentV addSubview:showPowerLabel];

    NSLog(@"%f",self.bv4.bottom);
    self.scrollView.contentSize = CGSizeMake(0, self.bv4.bottom + 80);

}

#pragma mark - collectionView的代理方发
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    readItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([readItem class]) forIndexPath:indexPath];
    NSArray *dataA = self.dataArray[indexPath.row];
    homeItem *item = dataA.firstObject;
    cell.title = item.title;
    return cell;
    
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(50, 60);
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
    NSArray *dataA = self.dataArray[indexPath.row];
    homeItem *item = dataA.firstObject;
    NSLog(@"%@",item.title);
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



#pragma mark - 懒加载
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        UICollectionView *cv = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 20, 60) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView = cv;
        cv.showsHorizontalScrollIndicator = NO;
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        //注册Cell,必须要有
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([readItem class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([readItem class])];
        
    }
    return _collectionView;
}
-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.frame = self.view.bounds;
        [self.view addSubview:_scrollView];
        _scrollView.alwaysBounceVertical = YES;
    }
    return _scrollView;
}

@end
