//
//  WKCDownloadView.m
//  ABC
//
//  Created by wkcloveYang on 2019/8/6.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import "WKCDownloadView.h"
#import "WKCFileManager.h"
#import "WKCUnzipManager.h"
#import "WKCDownloadManager.h"

@interface WKCDownloadView()

@property (nonatomic, strong) UIImageView * placeholderImageView;
@property (nonatomic, strong) WKCCircleProgressView * progressView;
@property (nonatomic, assign) WKCDownloadViewState downloadState;
@property (nonatomic, strong) NSString * savePath;

@property (nonatomic, strong) NSString * mainPath;

@end

@implementation WKCDownloadView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setupSubviews];
        [self createMainDirectory];
    }
    
    return self;
}

- (void)setupSubviews
{
    [self addSubview:self.placeholderImageView];
    [self addSubview:self.progressView];
    self.placeholderImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.progressView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint * placeholdTop = [NSLayoutConstraint constraintWithItem:self.placeholderImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    NSLayoutConstraint * placeholdBottom = [NSLayoutConstraint constraintWithItem:self.placeholderImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    NSLayoutConstraint * placeholdLeft = [NSLayoutConstraint constraintWithItem:self.placeholderImageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
    NSLayoutConstraint * placeholdRight = [NSLayoutConstraint constraintWithItem:self.placeholderImageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];
    
    NSLayoutConstraint * progressTop = [NSLayoutConstraint constraintWithItem:self.progressView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    NSLayoutConstraint * progressBottom = [NSLayoutConstraint constraintWithItem:self.progressView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    NSLayoutConstraint * progressLeft = [NSLayoutConstraint constraintWithItem:self.progressView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
    NSLayoutConstraint * progressRight = [NSLayoutConstraint constraintWithItem:self.progressView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];
    
    [self addConstraint:placeholdTop];
    [self addConstraint:placeholdBottom];
    [self addConstraint:placeholdLeft];
    [self addConstraint:placeholdRight];
    
    [self addConstraint:progressTop];
    [self addConstraint:progressBottom];
    [self addConstraint:progressLeft];
    [self addConstraint:progressRight];
    
}

- (void)createMainDirectory
{
    [WKCFileManager.sharedInstance createDirectoryAtPath:self.mainPath];
}
#pragma mark -property
- (UIImageView *)placeholderImageView
{
    if (!_placeholderImageView) {
        _placeholderImageView = [[UIImageView alloc] init];
        _placeholderImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    return _placeholderImageView;
}

- (WKCCircleProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[WKCCircleProgressView alloc] init];
        _progressView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
        _progressView.strokeWidth = 4;
        _progressView.startColor = UIColor.whiteColor;
        _progressView.endColor = UIColor.whiteColor;
        _progressView.radius = 18;
        _progressView.startAngle = -90;
        _progressView.reduceAngle = 0;
        _progressView.roundStyle = YES;
        _progressView.colorGradient = NO;
        _progressView.showProgressText = NO;
        _progressView.increaseFromLast = YES;
        _progressView.hidden = YES;
    }
    
    return _progressView;
}

- (NSString *)mainPath
{
    if (!_mainPath) {
        _mainPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:NSStringFromClass(self.class)];
    }
    
    return _mainPath;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.progressView.radius = MIN(self.bounds.size.width, self.bounds.size.height) / 3.0;
}

#pragma mark -Method
- (void)downloadAtUrl:(NSString *)url
     completionHandle:(WKCDownloadViewBlock)completionHandle
{
    [self downloadAtUrl:url
               savePath:[self urlToSavePath:url]
       completionHandle:completionHandle];
}


- (void)downloadAtUrl:(NSString *)url
             savePath:(NSString *)savePath
     completionHandle:(WKCDownloadViewBlock)completionHandle
{
    _savePath = savePath;
    
    // 是否是zip包
    BOOL isZip = [self isZipWithUrl:url];
    
    WKCDownloadViewState state = [self stateAtUrl:url];
    // 已经下载过
    if (state == WKCDownloadViewStateDownloaded) {
        if (isZip) {
            if (completionHandle) {
                completionHandle(WKCDownloadViewStateDownloaded, [self zipDataAtSavePath:savePath], [self zipPathsAtSavePath:savePath]);
            }
        } else {
            if (completionHandle) {
                completionHandle(WKCDownloadViewStateDownloaded, @[[self imageAtSavePath:savePath]], @[savePath]);
            }
        }

        _downloadState = WKCDownloadViewStateDownloaded;
        return;
    }
    
    // 正在下载, 停止
    if (_downloadState == WKCDownloadViewStateDownloading) {
        return;
    }
    
    _downloadState = WKCDownloadViewStateDownloading;
    _progressView.hidden = NO; //展示下载图

    [WKCDownloadManager.sharedInstance downloadFileWithURL:[NSURL URLWithString:url] saveFilePath:savePath progressHandle:^(CGFloat progress) {
        self.progressView.progress = progress;
    } completionHandle:^(BOOL isSuccess) {
        if (!isSuccess) {
            // 失败
            [self endDownload:NO];
        } else {
            if (!isZip) {
                // 不是zip包, 就处理完了
                [self endDownload:YES];
                self.downloadState = WKCDownloadViewStateDownloaded;
                if (completionHandle) {
                    completionHandle(WKCDownloadViewStateDownloaded, @[[self imageAtSavePath:savePath]], @[savePath]);
                }
            } else {
                // zip包,解压缩
                NSString * zipPath = savePath;
                NSString * destationPath = [zipPath stringByDeletingPathExtension]; //解包地址
                [WKCFileManager.sharedInstance createDirectoryAtPath:destationPath];
                [WKCUnzipManager unzipFileAtPath:zipPath saveAtPath:destationPath completion:^(BOOL succeeded) {
                    [self endDownload:succeeded];
                    if (succeeded) {
                        self.downloadState = WKCDownloadViewStateDownloaded;
                        if (completionHandle) {
                            completionHandle(WKCDownloadViewStateDownloaded, [self zipDataAtSavePath:savePath], [self zipPathsAtSavePath:savePath]);
                        }
                    }
                    // 删除zip包
                    [WKCFileManager.sharedInstance deleteFileAtPath:zipPath];
                }];
            }
        }
    }];
}



- (WKCDownloadViewState)stateAtUrl:(NSString *)url
{
    BOOL isZip = [self isZipWithUrl:url];
    if (isZip) {
        return ([self zipDataAtSavePath:[self urlToSavePath:url]] && [self zipDataAtSavePath:[self urlToSavePath:url]].count != 0) ? WKCDownloadViewStateDownloaded : WKCDownloadViewStateUndownload;
    } else {
        return [self imageAtSavePath:[self urlToSavePath:url]] ? WKCDownloadViewStateDownloaded : WKCDownloadViewStateUndownload;
    }
}







- (NSData *)imageAtSavePath:(NSString *)savePath
{
    return [NSData dataWithContentsOfFile:savePath];
}

- (NSArray <NSData *>*)zipDataAtSavePath:(NSString *)savePath
{
    NSMutableArray <NSData *>* array = [NSMutableArray array];
    for (NSString * sub in [self zipPathsAtSavePath:savePath]) {
        NSData * data = [NSData dataWithContentsOfFile:sub];
        [array addObject:data];
    }
    
    return array;
}

- (NSArray <NSString *>*)zipPathsAtSavePath:(NSString *)savePath
{
    NSString * directoryPath = [savePath stringByDeletingPathExtension];
    NSArray * subs = [WKCFileManager.sharedInstance subFilesAtPath:directoryPath];
    
    NSMutableArray <NSString *>* array = [NSMutableArray array];
    for (NSString * sub in subs) {
        if ([sub hasSuffix:@".DS_Store"]) continue;
        NSString * fullPath = [directoryPath stringByAppendingPathComponent:sub];
        [array addObject:fullPath];
    }
    
    return array;
}

- (NSString *)urlToSavePath:(NSString *)url
{
    NSString * compent = url.lastPathComponent;
    NSString * savePath = [self.mainPath stringByAppendingPathComponent:compent];
    return savePath;
}

- (BOOL)isZipWithUrl:(NSString *)url
{
    return [url hasSuffix:@".zip"];
}


- (void)endDownload:(BOOL)isSuccess
{
    self.progressView.progress = 0.0;
    self.progressView.hidden = YES;
    self.downloadState = isSuccess ? WKCDownloadViewStateDownloadSuccess : WKCDownloadViewStateDownloadFailuer;
}

+ (void)cancelDownload
{
    [WKCDownloadManager.sharedInstance cancelTask];
}

+ (void)cancelAllDownloads
{
    [WKCDownloadManager.sharedInstance cancelAllTasks];
}

@end
