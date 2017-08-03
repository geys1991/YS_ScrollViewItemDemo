//
//  YS_LikeItem.m
//  YS_ScrollVIewDemo
//
//  Created by geys1991 on 2017/8/1.
//  Copyright © 2017年 geys1991. All rights reserved.
//

#import "YS_LikeItem.h"
@interface YS_LikeItem ()



@property (nonatomic, copy)     NSString        *contentText;

@property (nonatomic, assign)   CGRect          initialFrame;

@property (nonatomic, strong)   UIImageView         *avatar;
//@property (nonatomic, strong) UILabel           *label;

@end


@implementation YS_LikeItem

-(instancetype)initWithFrame:(CGRect)frame withIndex:(NSInteger)index
{
    self = [super initWithFrame: frame];
    if ( self ) {
        
        _initialFrame = frame;
        
        _avatar = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        _avatar.backgroundColor = [UIColor whiteColor];
        
        _avatar.image = [UIImage imageNamed: @"kangna.jpg"];
        
        [self addSubview: _avatar];
        
//        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
//        
//        _label.backgroundColor = [UIColor whiteColor];
//        
//        _label.textColor = [UIColor lightGrayColor];
//        
//        _label.text = @"一";
//        
//        [self addSubview: _label];
        
        self.backgroundColor = [UIColor lightGrayColor];
        
//        
//        UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, frame.size.height)];
//        
////        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        
//        label.textColor = [UIColor whiteColor];
//        label.text = @"A";
//        
//        [self addSubview: label];
        
        self.layer.cornerRadius = CGRectGetHeight(self.frame) / 2.0f;
        self.layer.masksToBounds = YES;
    }
    return self;
}

-(void)fillImageWithName:(NSString *)imageName
{
    self.avatar.image = [UIImage imageNamed: imageName];
}


@end
