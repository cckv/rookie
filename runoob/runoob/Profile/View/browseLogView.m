//
//  browseLogView.m
//  runoob
//
//  Created by zhoubaitong on 2017/8/16.
//  Copyright © 2017年 cckv. All rights reserved.
//

#import "browseLogView.h"



@implementation browseLogView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    
    self.layer.shadowOpacity = 0.8f;
    
    self.layer.shadowRadius = 2.f;
    
    self.layer.shadowOffset = CGSizeMake(2,2);

}

@end
