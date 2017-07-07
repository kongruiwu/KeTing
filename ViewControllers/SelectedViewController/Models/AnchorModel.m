//
//  AnchorModel.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/14.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "AnchorModel.h"

@implementation AnchorModel

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super initWithDictionary:dic];
    if (self) {
        NSArray * listens = dic[@"listenVolice"];
        NSMutableArray * muarr = [NSMutableArray new];
        for (int i = 0; i<listens.count; i++) {
            HomeListenModel * model = [[HomeListenModel alloc]initWithDictionary:listens[i]];
            [muarr addObject:model];
        }
        self.listenVolice = [NSArray arrayWithArray:muarr];
    }
    return self;
}

@end
