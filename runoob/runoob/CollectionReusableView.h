//
//  CollectionReusableView.h
//  runoob
//
//  Created by zhoubaitong on 2017/8/15.
//  Copyright © 2017年 cckv. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CollectionReusableView;

@protocol CollectionReusableViewDeleate <NSObject>

- (void)CollectionReusableView:(CollectionReusableView*)headView clickHeadViewWith:(int)index;

@end

@interface CollectionReusableView : UICollectionReusableView

@property (nonatomic, copy) NSString *title; ///< <#name#>
@property (nonatomic, assign) int index; ///< <#name#>
@property (nonatomic, weak) id<CollectionReusableViewDeleate> delegate; ///< <#name#>
@end
