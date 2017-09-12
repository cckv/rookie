//
//  MYReadView.m
//  runoob
//
//  Created by zhoubaitong on 2017/8/17.
//  Copyright © 2017年 cckv. All rights reserved.
//

#import "MYReadView.h"

@interface MYReadView()
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UIImageView *imaV;

@end

@implementation MYReadView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.imaV.image = [[UIImage imageNamed:@"阅读.png"] imageByTintColor:[UIColor orangeColor]];
}
- (IBAction)click:(UIButton *)sender {
    if (self.model.title.length<=0) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(clickBtn:)]) {
        [self.delegate clickBtn:self.model];
    }
}

-(void)setModel:(currentReadModel *)model
{
    _model = model;
    if (model.title.length<=0) {
        self.nameL.text = @"暂无";
    }else{
        self.nameL.text = model.title;
    }
}

@end
