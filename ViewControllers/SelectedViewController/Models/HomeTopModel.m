//
//  HomeTopModel.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/6.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "HomeTopModel.h"


@implementation HomeTopModel
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super initWithDictionary:dic];
    if (self) {
        NSArray * tags = dic[@"tags"];
        NSMutableArray<TagsModel *> * muarr = [NSMutableArray new];
        for (int i = 0; i<tags.count; i++) {
            TagsModel * model = [[TagsModel alloc]initWithDictionary:tags[i]];
            [muarr addObject:model];
        }
        self.tagModels = muarr;
        self.showTools = NO;
        self.isSelectDown = NO;
    }
    return self;
}
@end
