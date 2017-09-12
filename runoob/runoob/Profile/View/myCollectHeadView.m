//
//  myCollectHeadView.m
//  runoob
//
//  Created by zhoubaitong on 2017/8/18.
//  Copyright © 2017年 cckv. All rights reserved.
//

#import "myCollectHeadView.h"

@implementation myCollectHeadView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self addAllViews];
        self.contentView.backgroundColor = [UIColor colorWithRed:(246/255.0) green:(246/255.0) blue:(246/255.0) alpha:1];
    }
    return self;
}


- (void)addAllViews
{
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth, 39)];
    self.label.textColor = [UIColor colorWithDisplayP3Red:(125/255.0) green:(212/255.0) blue:(250/255.0) alpha:1];
    [self.contentView addSubview:self.label];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 39, kScreenWidth, 1)];
    view.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:view];
}

@end
