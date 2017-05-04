//
//  NSString+path.m
//  异步加载网络图片
//
//  Created by Feng on 2017/4/28.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "NSString+path.h"

@implementation NSString (path)

- (NSString *)appendCachePath
{
    //获取cache文件目录
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    
    //获取文件名
    NSString *name = [self lastPathComponent];
    
    //拼接路径
    NSString *filePath = [path stringByAppendingString:name];
    
    return filePath;
}

@end
