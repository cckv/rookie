//
//  collectOpenModel.h
//  runoob
//
//  Created by zhoubaitong on 2017/8/18.
//  Copyright © 2017年 cckv. All rights reserved.
//

#import "JKDBModel.h"

@interface collectOpenModel : JKDBModel

@property(nonatomic, assign) BOOL open; ///< <#name#>


@property (nonatomic, copy) NSString *title; ///< <#name#>

@property (nonatomic, strong) NSArray *dataArray; ///< <#name#>

@end
