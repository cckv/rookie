//
//  CollectionReusableView.m
//  runoob
//
//  Created by zhoubaitong on 2017/8/15.
//  Copyright © 2017年 cckv. All rights reserved.
//

#import "CollectionReusableView.h"

@interface CollectionReusableView()

@property (weak, nonatomic) IBOutlet UILabel *nameL;

@end

@implementation CollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setTitle:(NSString *)title
{
    _title = title;
    self.nameL.text = title;
}
- (IBAction)clickHeadView:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(CollectionReusableView:clickHeadViewWith:)]) {
        [self.delegate CollectionReusableView:self clickHeadViewWith:self.index];
    }
}
@end
