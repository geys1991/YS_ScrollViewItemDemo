//
//  YS_ScrollView.h
//  YS_ScrollVIewDemo
//
//  Created by geys1991 on 2017/8/1.
//  Copyright © 2017年 geys1991. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ScrollViewInsertItemType) {
    ScrollViewInsertItemTypeShow = 0,
    ScrollViewInsertItemTypeFadeIn,
};

@interface YS_ScrollView : UIScrollView

@property (nonatomic, assign) NSInteger operationndex;

@property (nonatomic, strong) NSMutableArray    *dataSource;                // 用于 保存 数据的 数组， 内容为 头像View, 主要用于显示 使用.区别于保存所有 数据的数据

@property (nonatomic, strong) NSMutableArray   *dataArray;

@property (nonatomic, strong) NSMutableArray   *showItemsArray;

@property (nonatomic, strong) NSTimer           *timer;

@property (nonatomic, assign) BOOL              timerIsRunning;

@property (nonatomic, assign) BOOL              hasOperation;

-(void)initViews;

-(void)insertItemAtIndex:(NSInteger)index withInsertType:(ScrollViewInsertItemType)scrollViewInsertItemType;

-(void)deleteItemAtIndex:(NSInteger)index;

@end
