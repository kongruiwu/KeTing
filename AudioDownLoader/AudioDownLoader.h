//
//  AudioDownLoader.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/13.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeTopModel.h"

@interface AudioDownLoader : NSObject

@property (nonatomic, strong) NSMutableArray * downLoadingArray;
@property (nonatomic, strong) NSMutableArray * waitDownArray;


+ (instancetype)loader;




@end
