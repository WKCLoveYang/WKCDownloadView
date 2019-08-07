//
//  UIImageView+SDAlphaLoad.m
//  PhotoFace
//
//  Created by wkcloveYang on 2019/7/24.
//  Copyright © 2019 PhotoFace. All rights reserved.
//

#import "UIImageView+SDAlphaLoad.h"
#import <SDImageCache.h>
#import <SDWebImage.h>

@implementation UIImageView (SDAlphaLoad)

- (void)sd_alphaSetImageWithUrl:(NSString *)url
{
    [self sd_alphaSetImageWithUrl:url placeholderImage:nil];
}

- (void)sd_alphaSetImageWithUrl:(NSString *)url placeholderImage:(UIImage *)image
{
    UIImage * cacheImage = [SDImageCache.sharedImageCache imageFromCacheForKey:url];
    if (cacheImage) {
        self.image = cacheImage;
    } else {
        self.layer.opacity = 0.0;
        [self sd_setImageWithURL:[NSURL URLWithString:url]
                placeholderImage:image
                       completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                           [UIView transitionWithView:self duration:1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                               self.layer.opacity = 1.0;
                           }completion:nil];
        
                       }];
    }
}

@end
