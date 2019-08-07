//
//  WKCUnzipManager.m
//  ABC
//
//  Created by wkcloveYang on 2019/8/6.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import "WKCUnzipManager.h"
#import <SSZipArchive.h>

@implementation WKCUnzipManager

+ (void)unzipFileAtPath:(NSString *)path
             saveAtPath:(NSString *)savePath
             completion:(void(^)(BOOL succeeded))completion
{
    [SSZipArchive unzipFileAtPath:path toDestination:savePath progressHandler:nil completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
        if (completion) {
            completion(succeeded);
        }
    }];
}

@end
