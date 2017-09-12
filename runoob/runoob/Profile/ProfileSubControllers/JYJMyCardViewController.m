//
//  JYJMyCardViewController.m
//  JYJSlideMenuController
//
//  Created by JYJ on 2017/6/16.
//  Copyright © 2017年 baobeikeji. All rights reserved.
//

#import "JYJMyCardViewController.h"
#import "myCollectHeadView.h"
#import "collectOpenModel.h"


@interface JYJMyCardViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *collectArray;

@property (nonatomic, strong) UITableView *tableView; ///< <#name#>
@end

@implementation JYJMyCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationHeight);
    
    NSArray *collectArray = [collectModel findAll];
    
    currentReadModel *item = collectArray.firstObject;
    NSLog(@"%@",item);
    
    NSMutableArray *data = [self handleData:collectArray];
    self.collectArray = data;
    NSLog(@"%@",data);
}



- (void) headerViewClickedAction:(UITapGestureRecognizer *)sender
{
    collectOpenModel *model = self.collectArray[sender.view.tag];
    model.open = !model.open;
//    collectOpenModel *tempModel = model;
//    [self.collectArray removeObject:model];
//    [self.collectArray addObject:tempModel];
    [self.collectArray replaceObjectAtIndex:sender.view.tag withObject:model];
    
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:sender.view.tag];
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.collectArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    collectOpenModel *model = self.collectArray[section];
    if (!model.open) {
        return 0;
    } else {
        return model.dataArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    collectOpenModel *model = self.collectArray[section];
    
    myCollectHeadView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];

    view.label.text = model.title;
    view.tag = section;
    
    if (view.gestureRecognizers == nil) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewClickedAction:)];
        [view addGestureRecognizer:tap];
    }
    
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    collectOpenModel *model = self.collectArray[indexPath.section];
    collectModel *collectModel = model.dataArray[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"collectCell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"   %@",collectModel.title];
    cell.textLabel.textColor = [UIColor orangeColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    collectOpenModel *model = self.collectArray[indexPath.section];
    collectModel *collectModel = model.dataArray[indexPath.row];
    NSLog(@"%@",collectModel.type);
    
    detailViewController *detailVc = [[detailViewController alloc]init];
    detailVc.title = @"菜鸟教程";
    detailVc.to_urlStr = collectModel.currentReadURL;
    [self.navigationController pushViewController:detailVc animated:YES];
}

// 数组分类重组
- (NSMutableArray*)handleData:(NSArray*)dataArray
{
    NSMutableArray *resultArr = [NSMutableArray array];
    
    NSMutableArray *tempArr = [dataArray mutableCopy];
    
    collectModel *firstItem = tempArr.firstObject;
    
    while (tempArr.count>0) {
        
        NSMutableArray *arr = [NSMutableArray array];
        
        for (collectModel *item in tempArr) {
            
            if ([item.type isEqualToString:firstItem.type]) {
                [arr addObject:item];
            }
        }
        
        collectOpenModel *model = [[collectOpenModel alloc]init];
        model.open = NO;
        model.dataArray = arr;
        model.title = firstItem.title;
        
        [resultArr addObject:model];
        [tempArr removeObjectsInArray:arr];
        
        firstItem = tempArr.firstObject;
        
    }
    
    return resultArr;
}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"collectCell"];
        [_tableView registerClass:[myCollectHeadView class] forHeaderFooterViewReuseIdentifier:@"header"];
    }
    return _tableView;
}
@end
