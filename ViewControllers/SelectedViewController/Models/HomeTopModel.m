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
        if (dic[@"tags"]) {
            NSArray * tags = dic[@"tags"];
            NSMutableArray<TagsModel *> * muarr = [NSMutableArray new];
            for (int i = 0; i<tags.count; i++) {
                TagsModel * model = [[TagsModel alloc]initWithDictionary:tags[i]];
                [muarr addObject:model];
            }
            self.tagModels = muarr;
        }
        NSMutableString * tagString = [NSMutableString new];
        
        if (self.tagModels.count>0) {
            for (int i = 0; i<self.tagModels.count; i++) {
                if (i == 0) {
                    [tagString appendString:[NSString stringWithFormat:@"%@",self.tagModels[i].tagName]];
                }else{
                    [tagString appendString:[NSString stringWithFormat:@"  %@",self.tagModels[i].tagName]];
                }
            }
        }else if(self.tagName){
            [tagString appendString:[NSString stringWithFormat:@"%@",self.tagName]];
        }else{
            [tagString appendFormat:@""];
        }
        self.tagString = tagString;
        self.localAddress = @"";
        self.showTools = NO;
        self.isSelectDown = NO;
        self.downStatus = @0;
    }
    return self;
}
@end
