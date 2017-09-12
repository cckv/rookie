//
//  MYReadView.h
//  runoob
//
//  Created by zhoubaitong on 2017/8/17.
//  Copyright © 2017年 cckv. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MYReadViewDelegate <NSObject>

- (void)clickBtn:(currentReadModel*)model;

@end

@interface MYReadView : UIView
//@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (nonatomic, strong) currentReadModel *model;


@property (nonatomic, weak) id<MYReadViewDelegate> delegate; ///< <#name#>

@end
