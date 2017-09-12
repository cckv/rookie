//
//  readItem.m
//  runoob
//
//  Created by zhoubaitong on 2017/8/18.
//  Copyright © 2017年 cckv. All rights reserved.
//

#import "readItem.h"

@interface readItem()
@property (weak, nonatomic) IBOutlet UIImageView *icon;


@end

@implementation readItem

-(void)setTitle:(NSString *)title
{
    _title = title;
    
    NSLog(@"%@",title);
    self.icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",title]];
    if ([title isEqualToString:@"HTML/CSS"]) {
        self.icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"HTML.CSS.png"]];
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
