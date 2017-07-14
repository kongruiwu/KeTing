//
//  AudioDownLoader.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/13.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "AudioDownLoader.h"

@implementation AudioDownLoader

+ (instancetype)loader{
    static AudioDownLoader * loader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!loader) {
            loader = [[AudioDownLoader alloc]init];
        }
    });
    return loader;
}

- (void)downLoadAudioWithHomeTopModel:(HomeTopModel *)model{
    NSURL * url = [NSURL URLWithString:model.audioSource];
    // 得到session对象
    NSURLSession* session = [NSURLSession sharedSession];
    // 创建任务
    NSURLSessionDownloadTask* downloadTask = [session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        //location 下载好的文件写入沙盒的地址
    }];
    // 开始任务
    [downloadTask resume];
}

@end
