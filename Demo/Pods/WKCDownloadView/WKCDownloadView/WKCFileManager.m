//
//  WKCFileManager.m
//  ABC
//
//  Created by wkcloveYang on 2019/8/6.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import "WKCFileManager.h"

@implementation WKCFileManager

+ (WKCFileManager *)sharedInstance
{
    static WKCFileManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WKCFileManager alloc] init];
    });
    
    return instance;
}

- (BOOL)createDirectoryAtPath:(NSString *)path
{
    BOOL isDirectoryExist = [self fileExistAtPath:path];
    
    // 文件夹已经存在
    if (isDirectoryExist) return YES;
    
    return [NSFileManager.defaultManager createDirectoryAtPath:path
                                   withIntermediateDirectories:YES
                                                    attributes:nil
                                                         error:nil];
}


- (BOOL)fileExistAtPath:(NSString *)path
{
    return [NSFileManager.defaultManager fileExistsAtPath:path];
}

- (BOOL)deleteFileAtPath:(NSString *)path
{
   return [NSFileManager.defaultManager removeItemAtPath:path
                                                   error:nil];
}

- (NSArray <NSString *>*)subFilesAtPath:(NSString *)path
{
    NSArray <NSString *>* subs = [NSFileManager.defaultManager subpathsAtPath:path];
    for (NSInteger index = 0; index < subs.count; index ++) {
        NSString * sub = subs[index];
        sub = [path stringByAppendingPathComponent:sub];
    }
    
    return subs;
}

@end
