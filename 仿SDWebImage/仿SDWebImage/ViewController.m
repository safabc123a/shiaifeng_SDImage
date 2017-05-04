//
//  ViewController.m
//  仿SDWebImage
//
//  Created by Feng on 2017/5/4.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "ViewController.h"
#import "DownloadOperation.h"
#import "APPModel.h"
#import "YYModel.h"
#import "AFNetworking.h"

@interface ViewController ()

//全局队列
@property(nonatomic,strong) NSOperationQueue *queue;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property(nonatomic,strong) NSArray *appList;

@property(nonatomic,strong) NSMutableDictionary *opCache;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载数据
    [self loadData];
    
    //实例化队列
    _queue = [NSOperationQueue new];
    
    //实例化操作缓存池
    self.opCache = [NSMutableDictionary new];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //获取随机数
    int random = arc4random_uniform((u_int32_t)self.appList.count);
    
    //获取模型
    APPModel *model = self.appList[random];
    
    //创建操作
    DownloadOperation *op = [DownloadOperation downloadImageWithUrlStr:model.icon andFinishedBlock:^(UIImage *image) {
        
        [NSThread sleepForTimeInterval:0.5];
        
        self.iconImageView.image = image;
    }];
    
    //将操作添加到队列
    [self.queue addOperation:op];
}

- (void)loadData
{
    NSString *urlStr = @"https://raw.githubusercontent.com/safabc123a/shiaifeng_Exercise01/master/apps.json";
    
    [[AFHTTPSessionManager manager] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //字典转模型
        self.appList = [NSArray yy_modelArrayWithClass:[APPModel class] json:responseObject];
        
        NSLog(@"appList %@",self.appList);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"错误信息 = %@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
