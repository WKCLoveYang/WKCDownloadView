//
//  WKCUnzipManager.h
//  ABC
//
//  Created by wkcloveYang on 2019/8/6.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKCUnzipManager : NSObject

/**
  压缩zip包
  @param path zip包地址
  @param savePath 压缩完的保存地址
  @param completion 结果回调
 **/
+ (void)unzipFileAtPath:(NSString *)path
             saveAtPath:(NSString *)savePath
             completion:(void(^)(BOOL succeeded))completion;

@end
