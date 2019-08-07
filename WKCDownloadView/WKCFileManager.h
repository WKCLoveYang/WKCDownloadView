//
//  WKCFileManager.h
//  ABC
//
//  Created by wkcloveYang on 2019/8/6.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKCFileManager : NSObject

+ (WKCFileManager *)sharedInstance;

/**
  创建一个处理的文件 (如果有, 不覆盖原内容)
  @param path 路径
 **/
- (BOOL)createDirectoryAtPath:(NSString *)path;

/**
  某文件是否存在
  @param path 路径
 **/
- (BOOL)fileExistAtPath:(NSString *)path;

/**
 删除某文件
 @param path 路径
 **/
- (BOOL)deleteFileAtPath:(NSString *)path;

/**
 某文件夹下子内容
 @param path 路径
 **/
- (NSArray <NSString *>*)subFilesAtPath:(NSString *)path;

@end

