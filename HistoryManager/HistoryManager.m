//
//  HistoryManager.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/10.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "HistoryManager.h"
#import "NetWorkManager.h"
@implementation HistoryManager

+ (instancetype)manager{
    static HistoryManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[HistoryManager alloc]init];
            manager.downLoadList = [NSMutableArray new];
            manager.playStatusList = [NSMutableArray new];
        }
    });
    return manager;
}

- (void)getHistoryList{
    NSDictionary * params = @{
                              @"userId":[UserManager manager].userid,
                              @"downStatus":@0
                              };
    [[NetWorkManager manager] GETRequest:params pageUrl:Page_DownLoad complete:^(id result) {
        NSArray * arr = (NSArray *)result;
        NSMutableArray * muarr = [NSMutableArray new];
        for (int i = 0; i<arr.count; i++) {
            HomeTopModel * model = [[HomeTopModel alloc]initWithDictionary:arr[i]];
            [muarr addObject:model];
        }
        self.downLoadList = [NSMutableArray arrayWithArray:muarr];
    } errorBlock:^(KTError *error) {
        
    }];
}
@end
