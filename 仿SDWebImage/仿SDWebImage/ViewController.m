//
//  ViewController.m
//  仿SDWebImage
//
//  Created by Feng on 2017/5/4.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "ViewController.h"
#import "DownloadOperation.h"

@interface ViewController ()

//全局队列
@property(nonatomic,strong) NSOperationQueue *queue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //实例化队列
    _queue = [NSOperationQueue new];
    
    //创建操作
    DownloadOperation *op = [[DownloadOperation alloc] init];
    
    //向自定义操作传入图片
    op.urlStr = @"http://paper.taizhou.com.cn/tzwb/res/1/2/2015-01/20/12/res03_attpic_brief.jpg";
    
    //向自定义操作传入代码块
    op.finishedBlock = ^(UIImage *image) {
        NSLog(@"%@ %@",image,[NSThread currentThread]);
    };
    
    //将操作添加到队列
    [self.queue addOperation:op];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
