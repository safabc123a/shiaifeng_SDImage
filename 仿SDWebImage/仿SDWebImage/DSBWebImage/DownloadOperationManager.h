//
//  DownloadOperationManager.h
//  仿SDWebImage
//
//  Created by Feng on 2017/5/4.
//  Copyright © 2017年 feng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DownloadOperationManager : NSObject

+ (instancetype)sharedManager;

- (void)downloadWithUrlStr:(NSString *)urlStr andFinishedBlock:(void(^)(UIImage *image))finishedBlock;

- (void)cancelWithLastUrlStr:(NSString *)lastUrlStr;

@end
