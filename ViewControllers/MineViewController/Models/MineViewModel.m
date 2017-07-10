//
//  MineViewModel.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/6.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "MineViewModel.h"

@implementation MineViewModel

- (instancetype)init{
    self = [super init];
    if (self) {
        [self reloadData];
    }
    return self;
}
- (void)reloadData{
    self.msgStr = @"";
    self.FirstSection = [self getArrayWithTitles:@[@"我的钱包",@"已购",@"购物车"] Images:@[@"my_wallet",@"my_ buy",@"my_shopcar"]];
    self.SeconSection = [self getArrayWithTitles:@[@"收听历史",@"我赞过的",@"已下载音频"] Images:@[@"my_history",@"my_like",@"my_ music"]];
    self.ThirdSection = [self getArrayWithTitles:@[@"我的消息",@"设置"] Images:@[@"my_news",@"my_set"]];
    self.dataArray = @[self.FirstSection,self.SeconSection,self.ThirdSection];
}
- (NSArray<MineListModel *> *)getArrayWithTitles:(NSArray *)titles Images:(NSArray *)imgNames{
    NSMutableArray<MineListModel *> * muarr = [NSMutableArray new];
    for (int i = 0; i<titles.count; i++) {
        MineListModel * model = [[MineListModel alloc]init];
        model.imgName = imgNames[i];
        model.titleString = titles[i];
        model.desc = @"";
        [muarr addObject:model];
    }
    return muarr;
}
@end
