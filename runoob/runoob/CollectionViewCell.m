//
//  CollectionViewCell.m
//  runoob
//
//  Created by zhoubaitong on 2017/8/15.
//  Copyright © 2017年 cckv. All rights reserved.
//

#import "CollectionViewCell.h"

@interface CollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *descL;

@end

@implementation CollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setUrlArray:(NSString *)urlArray
{
    _urlArray = urlArray;
    
//    NSLog(@"%@",urlArray);

    NSData *data =[urlArray dataUsingEncoding:NSUTF8StringEncoding];
    
    TFHpple *Hpple = [[TFHpple alloc]initWithHTMLData:data];
    
    NSArray *arr = [Hpple searchWithXPathQuery:@"//img"];
    
    TFHppleElement *item = arr[0];
    
    NSString *dataStr = item.raw;
    
    NSArray *dataA = [dataStr componentsSeparatedByString:@" "];
    
    NSString *iconStr = dataA[5];
    
    NSArray *dataB = [iconStr componentsSeparatedByString:@"\""];
    
    NSString *iconString = dataB[1];
    
    iconString = [iconString substringFromIndex:2];
    
    iconString = [NSString stringWithFormat:@"http://%@",iconString];
    
//    NSLog(@"%@",iconString);
//    [self.icon sd_setImageWithURL:[NSURL URLWithString:iconString] placeholderImage:[UIImage new]];
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:iconString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        UIImage *image = [UIImage imageWithData:responseObject];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //更新UI操作
            self.icon.image = image;
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"123");
    }];
    
}
-(void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    
    NSString *name = dataArray[0];
    NSString *desc = dataArray[2];
    
    name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    name = [name stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    desc = [desc stringByReplacingOccurrencesOfString:@" " withString:@""];
    desc = [desc stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    self.nameL.text = name;
    self.descL.text = desc;
}

@end
