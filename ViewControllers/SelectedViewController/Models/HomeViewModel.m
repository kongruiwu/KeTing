//
//  HomeViewModel.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/6.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "HomeViewModel.h"

@implementation HomeViewModel

- (instancetype)init{
    self = [super init];
    if (self) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"homeData"]) {
            NSData * focusData = [[NSUserDefaults standardUserDefaults] objectForKey:@"homeData"];
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:focusData
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:nil];
            [self loadDataWithDic:dic];
        }
        
    }
    return self;
}


- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super initWithDictionary:dic];
    if (self) {
        [self loadDataWithDic:dic];
    }
    return self;
}
- (void)loadDataWithDic:(NSDictionary *)dic{
    self.titleArray = @[@"财经头条",@"声度",@"听书",@""];
    
    NSMutableArray * muarr = [NSMutableArray new];
    NSArray * tops = dic[@"tops"];
    int num = tops.count <= 5 ? (int)tops.count : 5;
    for (int i = 0; i< num; i++) {
        if ([tops[i] isKindOfClass:[NSNull class]]) {
            break;
        }
        HomeTopModel * model = [[HomeTopModel alloc]initWithDictionary:tops[i]];
        [muarr addObject:model];
    }
    self.tops = [NSArray arrayWithArray:muarr];
    
    [muarr removeAllObjects];
    NSArray * voices = dic[@"voice"];
    for (int i = 0; i<voices.count; i++) {
        HomeListenModel * model = [[HomeListenModel alloc]initWithDictionary:voices[i]];
        [muarr addObject:model];
    }
    self.voice = [NSArray arrayWithArray:muarr];

    
    [muarr removeAllObjects];
    NSArray * listens = dic[@"listen"];
    for (int i = 0; i<listens.count; i++) {
        HomeListenModel * model = [[HomeListenModel alloc]initWithDictionary:listens[i]];
        [muarr addObject:model];
    }
    self.listen = [NSArray arrayWithArray:muarr];

    
    HomeListenModel * model = [[HomeListenModel alloc]initWithDictionary:dic[@"voiceStockSecret"]];
    self.voiceStockSecret = model;
    
}

@end

