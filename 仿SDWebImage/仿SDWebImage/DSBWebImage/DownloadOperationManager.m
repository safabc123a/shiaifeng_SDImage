//
//  DownloadOperationManager.m
//  仿SDWebImage
//
//  Created by Feng on 2017/5/4.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "DownloadOperationManager.h"
#import "DownloadOperation.h"
#import "NSString+path.h"

@interface DownloadOperationManager ()

@property(nonatomic,strong) NSOperationQueue *queue;

@property(nonatomic,strong) NSMutableDictionary *opCache;

@property(nonatomic,strong) NSMutableDictionary *imageCache;

@end

@implementation DownloadOperationManager

+ (instancetype)sharedManager
{
    static id instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    
    return instance;
}

- (instancetype)init
{
    if(self = [super init])
    {
        self.queue = [NSOperationQueue new];
        
        self.opCache = [NSMutableDictionary new];
        
        self.imageCache = [NSMutableDictionary new];
    }
    
    return self;
}

- (void)downloadWithUrlStr:(NSString *)urlStr andFinishedBlock:(void (^)(UIImage *))finishedBlock
{
    //判断有没有缓存
    if([self checkCacheWithURLString:urlStr] == YES)
    {
        //直接从内存中取出,回调给VC
        if(finishedBlock)
        {
            finishedBlock([self.imageCache objectForKey:urlStr]);
        }
        return;
    }
    
    //判断操作是否重复
    if([self.opCache objectForKey:urlStr] != nil)
    {
        return;
    }
    
    //使用随机地址下载图片
    DownloadOperation *op = [DownloadOperation downloadImageWithUrlStr:urlStr andFinishedBlock:^(UIImage *image) {
        
        if(finishedBlock != nil)
        {
            finishedBlock(image);
        }
        
        //实现内存缓存
        if(image != nil)
        {
            [self.imageCache setObject:image forKey:urlStr];
        }
        
        //从操作缓存池中移除
        [self.opCache removeObjectForKey:urlStr];
    }];
    
    [self.opCache setObject:op forKey:urlStr];
    
    [self.queue addOperation:op];
}

//取消操作方法实现
- (void)cancelWithLastUrlStr:(NSString *)lastUrlStr
{
    //获取上次下载操作
    DownloadOperation *lastOP = [self.opCache objectForKey:lastUrlStr];
    
    if(lastUrlStr != nil)
    {
        [lastOP cancel];
        
        [self.opCache removeObjectForKey:lastUrlStr];
    }
}

// 检查是否有缓存 (内存和沙盒)
- (BOOL)checkCacheWithURLString:(NSString *)URLString
{
    // 判断内存缓存
    if ([_imageCache objectForKey:URLString] != nil) {
        NSLog(@"从内存中加载...");
        return YES;
    }
    
    // 判断沙盒缓存
    UIImage *cacheImage = [UIImage imageWithContentsOfFile:[URLString appendCachePath]];
    if (cacheImage != nil) {
        NSLog(@"从沙盒中加载...");
        // 在内存缓存中保存一份
        [_imageCache setObject:cacheImage forKey:URLString];
        return YES;
    }
    
    return NO;
}

@end
