//
//  UIView+YGCExtension.m
//
//  Created by Young on 15/9/2.
//  Copyright (c) 2015年 Young. All rights reserved.
//

#import "UIView+YGCExtension.h"

@implementation UIView (YGCExtension)

+ (instancetype)viewFromXib
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

+ (instancetype (^)())initFromXib{
    return ^{
        return [self viewFromXib];
    };
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}
- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (id)GetParentViewBySubView:(UIView *)subView parentViewClass:(Class)parentViewClass{
    UIView *view = self.superview;
    while (![view isKindOfClass:parentViewClass] && view) {
        
     view = self.superview;
    
    }
    return view;
}

- (id)GetParentViewControllerBySubView:(UIView *)subView ParentViewControllerClass:(Class)parentViewControllerClass{
    for (UIView* next = self.superview; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
    
        if ([nextResponder isKindOfClass:parentViewControllerClass]) {
            return nextResponder;
        }
    }
    return nil;
}

#pragma mark -- 常用系统方法封装
- (UIView *(^)(CGFloat x, CGFloat y, CGFloat width, CGFloat height))setFrame{
    return ^(CGFloat x, CGFloat y, CGFloat width, CGFloat height){
        self.frame = CGRectMake(x, y, width, height);
        return self;
    };
}

- (void)setSetFrame:(UIView *(^)(CGFloat, CGFloat, CGFloat, CGFloat))setFrame{
    
}

- (UIView *(^)(UIColor *))setBackgroundColor{
    return ^(UIColor *color){
        self.backgroundColor = color;
        return self;
    };
}

- (void)setSetBackgroundColor:(UIView *(^)(UIColor *))setBackgroundColor{
    
}

- (UIView *(^)(CGFloat, CGFloat))setByBezierCornerRadius{
    return ^(CGFloat width,CGFloat height){
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(width, height)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        //设置大小
        maskLayer.frame = self.bounds;
        //设置图形
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
        
        return self;
    };
}

- (void)setSetByBezierCornerRadius:(UIView *(^)(CGFloat, CGFloat))setByBezierCornerRadius{
    
}

- (UIView *(^)(CGFloat))setCornerRadius{
    return ^(CGFloat CornerRadius){
        self.layer.cornerRadius = CornerRadius;
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        return self;
    };
}

- (void)setSetCornerRadius:(UIView *(^)(CGFloat))setCornerRadius{
    
}

- (void (^)(UIView *view))addsubViews{
    return ^(UIView *view){
        [self addSubview:view];
    };
}

+ (instancetype(^)())init{
    return ^{
    return [[self alloc]init];
    };
}
@end
