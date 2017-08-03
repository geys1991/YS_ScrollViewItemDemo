//
//  ViewController.m
//  YS_ScrollViewItemDemo
//
//  Created by geys1991 on 2017/8/2.
//  Copyright © 2017年 geys1991. All rights reserved.
//

#import "ViewController.h"
#import "YS_ScrollView.h"

@interface ViewController ()

@property (nonatomic,strong) YS_ScrollView *scrollView;

@property (nonatomic,strong) UITextField *num;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithTitle: @"delete" style:UIBarButtonItemStylePlain target: self action: @selector(deleteItem)];
//    
//    self.navigationItem.leftBarButtonItem = leftBar;
//    
//    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle: @"insert" style:UIBarButtonItemStylePlain target: self action: @selector(insertItem)];
//    
//    self.navigationItem.rightBarButtonItem = rightBar;
    
    
    // 初始化
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGFloat itemWidth = 35;
    CGFloat itemsContentWidth = itemWidth * 7 + 6 * 10;
    _scrollView = [[YS_ScrollView alloc] initWithFrame: CGRectMake(0, 200, itemsContentWidth, itemWidth)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    NSInteger maxIndex = 20;
    NSMutableArray *tmp = [NSMutableArray array];
    for (NSInteger index = 0; index < maxIndex; index ++) {
        [tmp addObject: [NSString stringWithFormat: @"%ld", index]];
    }
    _scrollView.dataArray = tmp;
    [_scrollView initViews];

    
    [self.view addSubview: _scrollView];
    

 
}
- (IBAction)clickLikeAction:(id)sender {
    _scrollView.hasOperation = YES;
    [_scrollView.timer  setFireDate: [NSDate distantFuture]];
    [_scrollView insertItemAtIndex: 0 withInsertType: ScrollViewInsertItemTypeShow];
    
}
- (IBAction)operationTimerAction:(id)sender {
    _scrollView.timerIsRunning = !_scrollView.timerIsRunning;
    [_scrollView.timer setFireDate: _scrollView.timerIsRunning ? [NSDate distantPast] : [NSDate distantFuture] ];
}

- (IBAction)deleteLikeAction:(id)sender {
    _scrollView.hasOperation = YES;
    [_scrollView.timer  setFireDate: [NSDate distantFuture]];
    [_scrollView deleteItemAtIndex: [self.num.text integerValue] ? : 0];
}

- (IBAction)clickLikeShowAction:(id)sender {
    
    _scrollView.hasOperation = YES;
    [_scrollView.timer  setFireDate: [NSDate distantFuture]];
    [_scrollView insertItemAtIndex: 0 withInsertType: ScrollViewInsertItemTypeFadeIn];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
