//
//  ViewController.m
//  Demo
//
//  Created by wkcloveYang on 2019/8/7.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import "ViewController.h"
#import <WKCDownloadView.h>
#import <Masonry.h>
#import "UIImageView+SDAlphaLoad.h"

@interface ViewController ()

@property (nonatomic, strong) WKCDownloadView * downloadView;
@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.downloadView];
    
    [self.downloadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(48, 64));
    }];
}

#pragma mark -Property
- (WKCDownloadView *)downloadView
{
    if (!_downloadView) {
        _downloadView = [[WKCDownloadView alloc] init];
        _downloadView.backgroundColor = [UIColor.yellowColor colorWithAlphaComponent:0.5];
        [_downloadView.placeholderImageView sd_alphaSetImageWithUrl:@"https://d12bwn6qhsttvz.cloudfront.net/res/img/6/category/background/preview/1-popular/popular_0/popular_0_2.jpg"];

    }
    
    return _downloadView;
}

- (IBAction)downloadImage:(id)sender
{
    [_downloadView downloadAtUrl:@"https://d12bwn6qhsttvz.cloudfront.net/res/img/6/category/stickers/5-mosaic/material/4.png" completionHandle:^(WKCDownloadViewState state, NSArray<NSData *> *datas, NSArray<NSString *> *paths) {
        self.previewImageView.image = [UIImage imageWithData:datas.lastObject];
    }];
}

- (IBAction)downloadZip:(id)sender
{
    [_downloadView downloadAtUrl:@"https://d12bwn6qhsttvz.cloudfront.net/res/img/6/category/background/material/6-life/life_4.zip" completionHandle:^(WKCDownloadViewState state, NSArray<NSData *> *datas, NSArray<NSString *> *paths) {
        self.previewImageView.image = [UIImage imageWithData:datas.lastObject];
    }];
}


@end
