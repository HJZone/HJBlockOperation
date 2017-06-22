# HJBlockOperation
耗时操作串行方案的简单实现
通过NSOperation的子类与NSOperationQueue的配合来控制耗时操作


//仿NSOperation的四种状态 写出自己可以控制的对应的状态属性（ready状态暂时用不到，就不写了，其实最主要的就一个：isFinished，只有这个状态变成YES，才证明这个操作完成了）
@property(nonatomic ,assign , getter = isFinished)BOOL hjFinished;
@property(nonatomic ,assign , getter = isExecuting)BOOL hjExecuting;
@property(nonatomic ,assign , getter = isConcurrent)BOOL hjConcurrent;

- (void)setHjFinished:(BOOL)hjFinished
{
[self willChangeValueForKey:@"isFinished"];
_hjFinished = hjFinished;
[self didChangeValueForKey:@"isFinished"];
}

- (void)setHjExecuting:(BOOL)hjExecuting
{
[self willChangeValueForKey:@"isExecuting"];
_hjExecuting = hjExecuting;
[self didChangeValueForKey:@"isExecuting"];
}

- (void)setHjConcurrent:(BOOL)hjConcurrent
{
_hjConcurrent = hjConcurrent;
}


调用代码：
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


}
}];
[operaArray addObject:operation];

[queue addOperations:operaArray waitUntilFinished:NO];
