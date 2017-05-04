//
//  DownloadOperation.m
//  仿SDWebImage
//
//  Created by Feng on 2017/5/4.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "DownloadOperation.h"

@interface DownloadOperation ()



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
    
    /*
     下载网络图片
     1. 需要图片地址
     2. 需要把下载完的图片传递到展示的地方
     */
    
    NSURL *url = [NSURL URLWithString:self.urlStr];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
}

@end
