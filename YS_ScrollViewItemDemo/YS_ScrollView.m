//
//  YS_ScrollView.m
//  YS_ScrollVIewDemo
//
//  Created by geys1991 on 2017/8/1.
//  Copyright © 2017年 geys1991. All rights reserved.
//

#import "YS_ScrollView.h"
#import "YS_LikeItem.h"

@interface YS_ScrollView ()

@property (nonatomic, strong) YS_LikeItem *moreItem;

@end


@implementation YS_ScrollView
{
    CGFloat padding;
    CGFloat itemWidth;
    CGFloat itemHeight;
    CGFloat moveDuration;
    CGFloat positionLeftMarging;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];
    if ( self ) {
        padding = 10;
        itemWidth = 35;
        itemHeight = self.frame.size.height;
        moveDuration = 0.3f;
        positionLeftMarging = itemWidth + 10;
        _timer = [NSTimer scheduledTimerWithTimeInterval: moveDuration * 10  target: self selector: @selector(autpInsertContent) userInfo: nil repeats: YES];
        _timerIsRunning = YES;
//        [_timer fire];
        [_timer setFireDate: [NSDate distantPast]];
    }
    return self;
}

-(void)initViews
{
    self.dataSource = [[NSMutableArray alloc] initWithArray: [_dataArray subarrayWithRange: NSMakeRange(0, MIN(6, [_dataArray count]))]];
    NSInteger showItemTotal = [self.dataSource count];
    CGFloat contentWitdh = padding * (showItemTotal - 1) + showItemTotal * itemWidth;
    CGFloat startPositionX = (self.frame.size.width - positionLeftMarging - contentWitdh) / 2.0f + positionLeftMarging;
    for (NSInteger index = 0; index < [_dataArray count];  index ++) {
        if ( index < 6 ) {
            YS_LikeItem *item = [[YS_LikeItem alloc] initWithFrame: CGRectMake(startPositionX + (itemWidth + padding) * index , 0, itemWidth, itemHeight) withIndex: index];
            [self addSubview: item];
            [self.showItemsArray addObject: item];
            NSLog(@"%@", NSStringFromCGRect(item.frame));
        }else{
            break;
        }
    }
    
    if ( [self.showItemsArray count] >= 6 ) {
        // 需要
        YS_LikeItem *targetItem = [self.showItemsArray objectAtIndex: 5];
        if ( self.moreItem == nil ) {
            self.moreItem = [[YS_LikeItem alloc] initWithFrame:targetItem.frame  withIndex: 10];
            [self addSubview: self.moreItem];
            [self.moreItem fillImageWithName: @"cartMore"];
            self.moreItem.alpha = 1;
        }
        targetItem.alpha = 0;
    }
}

-(void)autpInsertContent
{
    NSLog(@"timer is running ");
    [self insertItemAtIndex: 0 withInsertType: ScrollViewInsertItemTypeFadeIn];
}

// 重新计算 所有 item 的位置
-(void)refreshItemFinalFrame
{
    
    NSInteger showItemTotal = MIN([self.dataSource count], 6) ;
    CGFloat contentWitdh = padding * (showItemTotal - 1) + showItemTotal * itemWidth;
    CGFloat startPositionX = (self.frame.size.width - positionLeftMarging - contentWitdh) / 2.0f + positionLeftMarging ;
    
    for (NSInteger index = 0; index < [self.showItemsArray count];  index ++) {
        
        YS_LikeItem *item = [self.showItemsArray objectAtIndex: index];
        CGRect finalFrame;
        if ( item.itemAnimationType == ItemAnimationTypeLeft || item.itemAnimationType == ItemAnimationTypeRight || item.itemAnimationType == ItemAnimationTypeRightFadeIn) {
            NSInteger flag;
            if ( item.itemAnimationType == ItemAnimationTypeRight || item.itemAnimationType == ItemAnimationTypeRightFadeIn ) {
                flag = index;
            }else{
                flag = index - 1;
            }
//            NSInteger flag = item.itemAnimationType == ItemAnimationTypeRight | ItemAnimationTypeRightFadeIn ? index :  index - 1;
            finalFrame = CGRectMake(startPositionX + (itemWidth + padding) *  flag, 0, itemWidth, itemHeight);
        }else if (item.itemAnimationType == ItemAnimationTypeLeftFadeIn){
            finalFrame = CGRectMake(positionLeftMarging, 0, itemWidth, itemHeight);
        }else{
            finalFrame = item.frame;
        }

        item.finalFrame = finalFrame;
    }

}

-(void)insertItemAtIndex:(NSInteger)index withInsertType:(ScrollViewInsertItemType)scrollViewInsertItemType
{
    // 首先 数据插入数组
    YS_LikeItem *item;
    
    [self.dataArray insertObject: [NSString stringWithFormat: @"%ld", index] atIndex: index];
    [self.dataSource insertObject: [NSString stringWithFormat: @"%ld", index] atIndex: index];
    
    NSInteger showItemTotal = MIN([self.dataSource count], 6);
    CGFloat contentWitdh = padding * (showItemTotal - 1) + showItemTotal * itemWidth;
    CGFloat startPositionX = (self.frame.size.width - positionLeftMarging - contentWitdh) / 2.0f + positionLeftMarging;
    
    if ( scrollViewInsertItemType == ScrollViewInsertItemTypeFadeIn ) {
        // 显示区域 已经满了
        item = [[YS_LikeItem alloc] initWithFrame: CGRectMake( 0, 0, itemWidth, itemHeight) withIndex: index];
        item.alpha = 0;

    }else{
        item = [[YS_LikeItem alloc] initWithFrame: CGRectMake(startPositionX + itemWidth  / 2.0f - 0.5, itemHeight / 2.0f - 0.5f, 1, 1) withIndex: index];
    }

    [self.showItemsArray insertObject: item atIndex: index];
    
    // 插入 原则 , 插入位置之前的 item 不动, 之后的 item 顺序向后移一位
    for (NSInteger refreshIndex = 0; refreshIndex < [self.showItemsArray count]; refreshIndex ++   ) {
        YS_LikeItem *item = [self.showItemsArray objectAtIndex: refreshIndex];
        if ( refreshIndex > index ) {
            if ( refreshIndex == 5 ) {
                item.itemAnimationType = ItemAnimationTypeRightFadeIn;
            }else{
                item.itemAnimationType = ItemAnimationTypeRight;
            }
        }else if(refreshIndex == index){
            item.itemAnimationType = scrollViewInsertItemType == ScrollViewInsertItemTypeFadeIn ? ItemAnimationTypeLeftFadeIn : ItemAnimationTypeShow;
        }
    }
    
    [self addSubview: item];

    // 判断是否需要 新建 更多 按钮
    if ( [self.showItemsArray count] >= 6 ) {
        // 需要
        YS_LikeItem *targetItem = [self.showItemsArray objectAtIndex: 5];
        if ( self.moreItem == nil ) {
            self.moreItem = [[YS_LikeItem alloc] initWithFrame:targetItem.frame  withIndex: 10];
            [self addSubview: self.moreItem];
            [self.moreItem fillImageWithName: @"cartMore"];
            self.moreItem.alpha = 0;
        }
    }
    
    // 获取 最终位置
    [self refreshItemFinalFrame];

    
    // 更多 的最终位置
    if ( [self.showItemsArray count] >= 6 ) {
        YS_LikeItem *targetItem = [self.showItemsArray objectAtIndex: 5];
        CGRect moreItemFinalFrame = targetItem.finalFrame;
        self.moreItem.finalFrame = moreItemFinalFrame;
    }
    
    
    
    CGFloat delayTime = 5.0f / (10.0f + itemWidth) * moveDuration ;

    dispatch_group_t group = dispatch_group_create();
    for ( NSInteger itemIndex = 0; itemIndex < [self.showItemsArray count]; itemIndex ++) {
        if ( itemIndex == 3 ) {
            NSLog(@"");
        }
        dispatch_group_enter(group);
        YS_LikeItem *item = [self.showItemsArray objectAtIndex: itemIndex];
        
        
        switch (item.itemAnimationType) {
            case ItemAnimationTypeLeftFadeIn:
            case ItemAnimationTypeRightFadeIn:
            {
                CGFloat finalAlphaValue = item.itemAnimationType == ItemAnimationTypeLeftFadeIn ? 1 : 0;
                
                [UIView animateWithDuration: moveDuration delay:  delayTime * (itemIndex - 1)  options: UIViewAnimationOptionLayoutSubviews animations:^{
                    item.alpha = finalAlphaValue;
                    item.frame = item.finalFrame;
                    if ( itemIndex ==  [self.showItemsArray count] - 1) {
                        self.moreItem.frame = self.moreItem.finalFrame;
                        self.moreItem.alpha = 1;
                    }
                    [self bringSubviewToFront: item];
                } completion:^(BOOL finished) {
                    dispatch_group_leave(group);
                }];
            }
                break;
            default:
            {
                if ( itemIndex > index ) {
                    // 向右 移动
                    [UIView animateWithDuration: moveDuration delay: delayTime * (itemIndex - 1) options: UIViewAnimationOptionLayoutSubviews animations:^{
                        item.frame = item.finalFrame;
                    } completion:^(BOOL finished) {
                        dispatch_group_leave(group);
                    }];
                    
                }else if(itemIndex == index){
                    // 放大展示
                    item.layer.anchorPoint = CGPointMake(0.5, 0.5);
                    [UIView animateWithDuration: moveDuration + ( MIN([self.showItemsArray count], 6) - 1 ) * delayTime delay:  moveDuration / 3.0f  options: UIViewAnimationOptionLayoutSubviews animations:^{
                        CGAffineTransform transform  = CGAffineTransformMakeScale(itemWidth, itemHeight);
                        item.transform = transform;
                    } completion:^(BOOL finished) {
                        dispatch_group_leave(group);
                    }];
                }
            }
                break;
        }
        
        
        
        
        
//        if ( item.itemAnimationType == ItemAnimationTypeLeftFadeIn || item.itemAnimationType == ItemAnimationTypeRightFadeIn) {
//
//            CGFloat finalAlphaValue = item.itemAnimationType == ItemAnimationTypeLeftFadeIn ? 1 : 0;
//            
//            [UIView animateWithDuration: moveDuration delay:  moveDuration / 3.0f  options: UIViewAnimationOptionLayoutSubviews animations:^{
//                item.alpha = finalAlphaValue;
//                item.frame = item.finalFrame;
//                if ( itemIndex ==  [self.showItemsArray count] - 1) {
//                    self.moreItem.frame = self.moreItem.finalFrame;
//                    self.moreItem.alpha = 1;
//                }
//                [self bringSubviewToFront: item];
//            } completion:^(BOOL finished) {
//                dispatch_group_leave(group);
//            }];
//        }else{
//            if ( itemIndex > index ) {
//                // 向右 移动
//                [UIView animateWithDuration: moveDuration delay: delayTime * (itemIndex - 1) options: UIViewAnimationOptionLayoutSubviews animations:^{
//                    item.frame = item.finalFrame;
//                } completion:^(BOOL finished) {
//                    dispatch_group_leave(group);
//                }];
//                
//            }else if(itemIndex == index){
//                // 放大展示
//                item.layer.anchorPoint = CGPointMake(0.5, 0.5);
//                [UIView animateWithDuration: moveDuration + ( MIN([self.showItemsArray count], 6) - 1 ) * delayTime delay:  moveDuration / 3.0f  options: UIViewAnimationOptionLayoutSubviews animations:^{
//                    CGAffineTransform transform  = CGAffineTransformMakeScale(itemWidth, itemHeight);
//                    item.transform = transform;
//                } completion:^(BOOL finished) {
//                    dispatch_group_leave(group);
//                }];
//            }
//        }
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 超出最大数量, 删除
        if ( _hasOperation  ) {
            if ( _timerIsRunning ) {
                // 停掉 timer
                _timerIsRunning = NO;
                [_timer setFireDate: [NSDate distantFuture]];
                
                _hasOperation = NO;
                [self insertItemAtIndex: 0 withInsertType: ScrollViewInsertItemTypeFadeIn];
            }
        }
        
        if ( [self.showItemsArray count] > 6 ) {
            YS_LikeItem *lastItem = [self.showItemsArray lastObject];
            [lastItem removeFromSuperview];
            lastItem = nil;
            [self.showItemsArray removeLastObject];
            [self.dataSource removeLastObject];
        }
        
        
        
    });
}

-(void)deleteItemAtIndex:(NSInteger)index
{
    [self.dataArray removeObjectAtIndex: index];
    [self.dataSource removeObjectAtIndex: index];
    
    
    if ( [self.dataArray count] < 6 ) {
        
    }
    
    // 移动 原则
    for (NSInteger refreshIndex = 0; refreshIndex < [self.showItemsArray count]; refreshIndex ++   ) {
        
        YS_LikeItem *item = [self.showItemsArray objectAtIndex: refreshIndex];
        if ( refreshIndex > index ) {
            // 当前 位置 之后
            item.itemAnimationType = ItemAnimationTypeLeft;
        }else if(refreshIndex == index){
            // 当前位置
            item.itemAnimationType = ItemAnimationTypeDisappear;
        }else{
            // 当前位置之前
            item.itemAnimationType = ItemAnimationTypeRight;
            
        }
    }
    
    if ( [self.dataSource count] < [self.dataArray count] ) {
        
        NSString *makeUpPositionItem = [self.dataArray lastObject];
        
        YS_LikeItem *item = [[YS_LikeItem alloc] initWithFrame: CGRectMake(0, 0, itemWidth, itemHeight) withIndex: 0];
        item.alpha = 0;
        item.itemAnimationType = ItemAnimationTypeLeftFadeIn;
        [self.showItemsArray insertObject: item atIndex: 0];
        [self.dataSource insertObject: makeUpPositionItem atIndex: 0];
        
        [self addSubview: item];
    }
    
    // 获取 最终位置
    [self refreshItemFinalFrame];
    
    // 判断是否需要 more Item 消失
    if ( [self.dataArray count] <= 5 ) {
        YS_LikeItem *targetItem = [self.showItemsArray lastObject];
        self.moreItem.finalFrame = targetItem.finalFrame;
    }
    
    
    dispatch_group_t group = dispatch_group_create();

    CGFloat delayTime = 10.0f / (10.0f + itemWidth) * moveDuration ;
    for ( NSInteger itemIndex = 0; itemIndex < [self.showItemsArray count]; itemIndex ++) {
        dispatch_group_enter(group);
        YS_LikeItem *item = [self.showItemsArray objectAtIndex: itemIndex];
        
        switch (item.itemAnimationType) {
            case ItemAnimationTypeDisappear:
            {
                // 缩小展示
                item.layer.anchorPoint = CGPointMake(0.5, 0.5);
                [UIView animateWithDuration: moveDuration + ( MIN([self.showItemsArray count], 6) - 1 ) * delayTime delay: 0 options: UIViewAnimationOptionLayoutSubviews animations:^{
                    CGAffineTransform transform  = CGAffineTransformMakeScale( 1.0f / itemWidth, 1.0f / itemHeight);
                    item.transform = transform;
                } completion:^(BOOL finished) {
                    // 移除
                    [item removeFromSuperview];
                    [self.showItemsArray removeObject: item];
                    dispatch_group_leave(group);
                }];
            }
                break;
            case ItemAnimationTypeLeftFadeIn:
            {
                [UIView animateWithDuration: moveDuration delay: moveDuration / 3.0f + delayTime * itemIndex options: UIViewAnimationOptionLayoutSubviews animations:^{
                    item.alpha = 1;
                    item.frame = item.finalFrame;
                } completion:^(BOOL finished) {
                    dispatch_group_leave(group);
                }];
            }
                break;
            default:
            {
                [UIView animateWithDuration: moveDuration delay: moveDuration / 3.0f + delayTime * itemIndex options: UIViewAnimationOptionLayoutSubviews animations:^{
                    item.alpha = 1;
                    item.frame = item.finalFrame;
                    
                    if ( itemIndex ==  [self.showItemsArray count] - 1 && [self.dataSource count] < 6 ) {
                        self.moreItem.frame = self.moreItem.finalFrame;
                        self.moreItem.alpha = 0;
                    }
                    [self bringSubviewToFront: self.moreItem];
                } completion:^(BOOL finished) {
                    
                    
                    dispatch_group_leave(group);
                }];
            }
                break;
        }
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if ( self.moreItem.alpha == 0 ) {
            [self.moreItem removeFromSuperview];
            self.moreItem = nil;
        }
        
    });
    
}

-(NSMutableArray *)showItemsArray
{
    if ( !_showItemsArray ) {
        _showItemsArray = [[NSMutableArray alloc] init];
    }
    return _showItemsArray;
}


@end
