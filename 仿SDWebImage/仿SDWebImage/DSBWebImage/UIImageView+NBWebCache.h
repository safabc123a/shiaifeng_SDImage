//
//  UIImageView+NBWebCache.h
//  仿SDWebImage
//
//  Created by Feng on 2017/5/4.
//  Copyright © 2017年 feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (NBWebCache)

- (void)NB_setImageWithURLString:(NSString *)URLString;

/// 保存上次图片地址
@property (nonatomic,copy) NSString *lastURLString;

@end
