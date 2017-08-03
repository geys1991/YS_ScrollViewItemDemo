//
//  YS_LikeItem.h
//  YS_ScrollVIewDemo
//
//  Created by geys1991 on 2017/8/1.
//  Copyright © 2017年 geys1991. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ItemAnimationType) {
    ItemAnimationTypeNone = 0,              // 没有动画, 静止
    ItemAnimationTypeLeft,                  // 左移
    ItemAnimationTypeRight,                 // 右移
    ItemAnimationTypeShow,                  // 展示(新建时)
    ItemAnimationTypeDisappear,             // 消失
    ItemAnimationTypeLeftFadeIn,            // 从左侧渐进 展示
    ItemAnimationTypeRightFadeIn,           // 向右侧渐进 消失
};

@interface YS_LikeItem : UIView

@property (nonatomic, assign) CGFloat  padding;

@property (nonatomic, assign)   CGRect          finalFrame;

@property (nonatomic, assign) ItemAnimationType itemAnimationType;

-(void)fillImageWithName:(NSString *)imageName;

-(instancetype)initWithFrame:(CGRect)frame withIndex:(NSInteger)index;


@end
