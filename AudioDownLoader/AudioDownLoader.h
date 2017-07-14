//
//  AudioDownLoader.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/13.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeTopModel.h"

@interface AudioDownLoader : NSObject<NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSMutableArray * downLoadingArray;
@property (nonatomic, strong) NSMutableArray * waitDownArray;
@property (nonatomic, strong) HomeTopModel * currentModel;

+ (instancetype)loader;
/**开始下载*/
- (void)downLoadAudioWithHomeTopModel:(HomeTopModel *)model;
/**暂停下载*/
- (void)cancelDownLoading;
/**恢复下载*/
- (void)resumeDownLoading;
@end
