//
//  UIImageView+NBWebCache.m
//  仿SDWebImage
//
//  Created by Feng on 2017/5/4.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "UIImageView+NBWebCache.h"
#import "DownloadOperationManager.h"
#import <objc/runtime.h>

@implementation UIImageView (NBWebCache)

- (void)setLastURLString:(NSString *)lastURLString
{
    objc_setAssociatedObject(self, "key", lastURLString, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)lastURLString
{
    return objc_getAssociatedObject(self, "key");
}

- (void)NB_setImageWithURLString:(NSString *)URLString
{
    // 判断本次地址和上次地址是否一样,如果不一样就取消上次的下载操作
    if (![URLString isEqualToString:self.lastURLString] && self.lastURLString != nil) {
        
        // 单例取消上次下载操作
        [[DownloadOperationManager sharedManager] cancelWithLastUrlStr:self.lastURLString];
    }
    
    // 保存本次图片地址 : 当再次点击屏幕时,本次保存的就变成上次的了
    self.lastURLString = URLString;
    
    // 单例接管下载
    [[DownloadOperationManager sharedManager] downloadWithUrlStr:URLString andFinishedBlock:^(UIImage *image)  {
        
        // 赋值
        self.image = image;
    }];
}

@end
