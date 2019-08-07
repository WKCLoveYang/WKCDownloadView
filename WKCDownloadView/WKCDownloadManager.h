//
//  WKCDownloadManager.h
//  ABC
//
//  Created by wkcloveYang on 2019/8/6.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface WKCDownloadManager : NSObject


+ (WKCDownloadManager *)sharedInstance;

/**
 下载
 
 @param url url
 @param sfPath 保存地址
 @param progress 进度回调
 @param handle 结果回调
 */
- (void)downloadFileWithURL:(NSURL *)url
               saveFilePath:(NSString *)sfPath
             progressHandle:(void(^)(CGFloat progress))progress
           completionHandle:(void(^)(BOOL isSuccess))handle;

/**
  取消当前任务
 */
- (void)cancelTask;

/**
 取消所有任务
 */
- (void)cancelAllTasks;

@end

