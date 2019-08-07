//
//  UIImageView+SDAlphaLoad.h
//  PhotoFace
//
//  Created by wkcloveYang on 2019/7/24.
//  Copyright © 2019 PhotoFace. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImageView (SDAlphaLoad)

- (void)sd_alphaSetImageWithUrl:(NSString *)url;

- (void)sd_alphaSetImageWithUrl:(NSString *)url placeholderImage:(UIImage *)image;

@end

