//
//  WKCDownloadManager.m
//  ABC
//
//  Created by wkcloveYang on 2019/8/6.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import "WKCDownloadManager.h"
#import <AFNetworking.h>

@interface WKCDownloadManager()

@property (nonatomic, strong) NSMutableArray <NSURLSessionDownloadTask *>* tasks;
@property (nonatomic, strong) NSURLSessionDownloadTask * downloadTask;

@end

@implementation WKCDownloadManager

+ (WKCDownloadManager *)sharedInstance
{
    static WKCDownloadManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WKCDownloadManager alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        _tasks = [NSMutableArray array];
    }
    
    return self;
}

- (void)downloadFileWithURL:(NSURL *)url
               saveFilePath:(NSString *)sfPath
             progressHandle:(void(^)(CGFloat progress))progress
           completionHandle:(void(^)(BOOL isSuccess))handle
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url
                                                                cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                            timeoutInterval:10];
    AFHTTPSessionManager *manager = AFHTTPSessionManager.manager;
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {//进度
        CGFloat compeleted = downloadProgress.completedUnitCount;
        CGFloat total = downloadProgress.totalUnitCount;
        if (progress) {
            progress(compeleted / total);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *filePathUrl = [NSURL fileURLWithPath:sfPath];
        return filePathUrl;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nonnull error) {
        if (error) {
            if (handle) handle(NO);
        }else {
            if (handle) handle(YES);
        }
        // 结束之后, 不管成功或失败, 都把任务从任务表内移除
        [self.tasks removeObject:self.downloadTask];
    }];
    //3.启动任务
    [downloadTask resume];
    _downloadTask = downloadTask;
    [_tasks addObject:downloadTask];
}

- (void)cancelTask
{
    [_downloadTask cancel];
}

- (void)cancelAllTasks
{
    if (_tasks.count == 0) return;
    
    for (NSInteger index = 0; index < _tasks.count; index ++) {
        NSURLSessionDownloadTask * task = _tasks[index];
        [task cancel];
    }
}

@end
