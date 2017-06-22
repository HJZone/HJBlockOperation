//
//  ViewController.m
//  HJBlockOperation
//
//  Created by 浩杰 on 2017/6/19.
//  Copyright © 2017年 dunyun. All rights reserved.
//

#import "ViewController.h"
#import "HJBlockOperation.h"

@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 200, 300, 200)];
        [self.view addSubview:_imageView];
    }
    
}

- (IBAction)action:(id)sender {
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 1;
    
    NSMutableArray *operaArray = [NSMutableArray array];
    for (int index = 0; index < 1; index ++) {
        
        HJBlockOperation *blo = [[HJBlockOperation alloc] init];
        
        [blo continueWithBlock:^(HJBlockOperation *con) {
            
            NSLog(@"第%d条任务开始",index + 1);
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                NSLog(@"第%d条任务结束",index + 1);
                
                //等任务结束后调用这句代码，就标明此操作已结束
                blo.hjFinished = YES;
            });
            
        }];
        
        [operaArray addObject:blo];
    }
    
    
    HJBlockOperation *operation = [[HJBlockOperation alloc] init];
    
    [operation continueWithBlock:^(HJBlockOperation *con) {
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://ppt.downhot.com/d/file/p/2014/08/16/0b999aee4d45bc266637043b7cf04654.jpg"]];
        NSLog(@"开始下载图片");
        if (data) {
            operation.hjFinished = YES;
            
            NSLog(@"下载完了");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _imageView.image = [UIImage imageWithData:data];
                
            });
        }
    }];
    [operaArray addObject:operation];
    
    [queue addOperations:operaArray waitUntilFinished:NO];
    
    

    
}




@end
