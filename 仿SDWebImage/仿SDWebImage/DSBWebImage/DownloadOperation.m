//
//  DownloadOperation.m
//  仿SDWebImage
//
//  Created by Feng on 2017/5/4.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "DownloadOperation.h"
#import "NSString+path.h"

@interface DownloadOperation ()

@property(nonatomic,copy) NSString *urlStr;

@property(nonatomic,copy) void(^finishedBlock)(UIImage *image);

@end

@implementation DownloadOperation

//关于main方法
/*
 1.任何操作在执行时,首先会调用start方法,Start方法会更新操作的状态
 2.经Start方法过滤之后,只有正常课执行的操作,才会调用这个main方法
 3.重写操作的入口方法(main方法),就可以在这个方法里面指定操作执行的任务
 4.该方法默认就是在子线程执行的
 */

- (void)main
{
    NSLog(@"%s %@",__func__,[NSThread currentThread]);
    
    // 模拟网络延迟 : 没有实际意义
    [NSThread sleepForTimeInterval:1.0];
    
    /*
     下载网络图片
     1. 需要图片地址
     2. 需要把下载完的图片传递到展示的地方
     */
    
    NSURL *url = [NSURL URLWithString:self.urlStr];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    
    //实现沙盒缓存
    if(image != nil)
    {
        [data writeToFile:[self.urlStr appendCachePath] atomically:YES];
    }
    
    //取消判断
    if(self.cancelled == YES)
    {
        return;
    }
    
    if(self.finishedBlock)
    {
        //回到主线程把图片传递出去外界拿到之后,可以立即刷新UI
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.finishedBlock(image);
        }];
    }
}

+ (instancetype)downloadImageWithUrlStr:(NSString *)urlStr andFinishedBlock:(void (^)(UIImage *))finishedBlock
{
    DownloadOperation *op = [[DownloadOperation alloc] init];
    
    op.urlStr = urlStr;
    op.finishedBlock = finishedBlock;
    
    return op;
}

@end
