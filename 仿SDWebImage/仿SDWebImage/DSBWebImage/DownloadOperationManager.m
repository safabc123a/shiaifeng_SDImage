//
//  DownloadOperationManager.m
//  仿SDWebImage
//
//  Created by Feng on 2017/5/4.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "DownloadOperationManager.h"
#import "DownloadOperation.h"

@interface DownloadOperationManager ()

@property(nonatomic,strong) NSOperationQueue *queue;

@property(nonatomic,strong) NSMutableDictionary *opCache;

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
    }
    
    return self;
}

- (void)downloadWithUrlStr:(NSString *)urlStr andFinishedBlock:(void (^)(UIImage *))finishedBlock
{
    //使用随机地址下载图片
    DownloadOperation *op = [DownloadOperation downloadImageWithUrlStr:urlStr andFinishedBlock:^(UIImage *image) {
        
        if(finishedBlock != nil)
        {
            finishedBlock(image);
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

@end
