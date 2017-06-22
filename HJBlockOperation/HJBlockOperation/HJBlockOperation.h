//
//  HJBlockOperation.h
//  HJBlockOperation
//
//  Created by 浩杰 on 2017/6/19.
//  Copyright © 2017年 chang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HJBlockOperation;

typedef void (^continueBlock)(HJBlockOperation *con);

@interface HJBlockOperation : NSOperation

//仿NSOperation的四种状态 写出自己可以控制的对应的状态属性（ready状态暂时用不到，就不写了，其实最主要的就一个：isFinished，只有这个状态变成YES，才证明这个操作完成了）
@property(nonatomic ,assign , getter = isFinished)BOOL hjFinished;
@property(nonatomic ,assign , getter = isExecuting)BOOL hjExecuting;
@property(nonatomic ,assign , getter = isConcurrent)BOOL hjConcurrent;

@property(nonatomic, copy) continueBlock myBlock;


- (void)continueWithBlock:(continueBlock)blk;

@end
