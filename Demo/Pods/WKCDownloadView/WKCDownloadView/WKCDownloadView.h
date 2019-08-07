//
//  WKCDownloadView.h
//  ABC
//
//  Created by wkcloveYang on 2019/8/6.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKCCircleProgressView.h"

typedef NS_ENUM(NSInteger, WKCDownloadViewState) {
    WKCDownloadViewStateUndownload       = 0, // 未下载
    WKCDownloadViewStateDownloading      = 1, // 下载中
    WKCDownloadViewStateDownloadSuccess  = 2, // 下载成功
    WKCDownloadViewStateDownloadFailuer  = 3, // 下载失败
    WKCDownloadViewStateDownloaded       = 4 // 下载过
};

typedef void(^WKCDownloadViewBlock)(WKCDownloadViewState state, NSArray <NSData *>* datas, NSArray <NSString *>* paths);

@interface WKCDownloadView : UIView

@property (nonatomic, strong, readonly) UIImageView * placeholderImageView; //占位图
@property (nonatomic, strong, readonly) WKCCircleProgressView * progressView; //下载进度图
@property (nonatomic, strong, readonly) NSString * savePath; //下载完成后的保存地址

/**
 下载 (已经下载过的不会重复下载, 直接回调回结果)
 @param url 下载地址
 @param completionHandle 回调
 **/
- (void)downloadAtUrl:(NSString *)url
     completionHandle:(WKCDownloadViewBlock)completionHandle;

/**
 状态获取
 @param url 下载地址
 **/
- (WKCDownloadViewState)stateAtUrl:(NSString *)url;


// 取消当前下载任务
+ (void)cancelDownload;

// 取消所有下载任务
+ (void)cancelAllDownloads;

@end

