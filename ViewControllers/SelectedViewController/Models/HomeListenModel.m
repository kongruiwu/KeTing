//
//  HomeListenModel.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/6.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "HomeListenModel.h"

@implementation HomeListenModel

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super initWithDictionary:dic];
    if (self) {
        self.isDownLoad = NO;
        self.isDownLoading = NO;

        self.descString = dic[@"description"];
        NSString * time;
        switch ([self.orderTime intValue]) {
            case 0:
                time = @"";
                break;
            case 1:
                time = @"/月";
                break;
            case 2:
                time = @"/季度";
                break;
            case 3:
                time = @"/半年";
                break;
            case 4:
                time = @"/年";
                break;
            default:
                break;
        }

        NSArray * orderNames = [[NSUserDefaults standardUserDefaults] objectForKey:@"ORDERNAMES"];
        NSArray * orderIDs =[[NSUserDefaults standardUserDefaults] objectForKey:@"ORDERIDS"];
        if ([orderIDs containsObject:[NSString stringWithFormat:@"%@",self.orderTime]]) {
            NSInteger index = [orderIDs indexOfObject:[NSString stringWithFormat:@"%@",self.orderTime]];
            time = orderNames[index];
        }
        if (time.length>0) {
            time = [NSString stringWithFormat:@"/%@",time];
        }
        self.PRICE = dic[@"price"];
        self.price = [NSString stringWithFormat:@"¥%@",dic[@"price"]];
        self.timePrice = [NSString stringWithFormat:@"¥%.2f%@",[dic[@"price"] floatValue],time];
        
        NSArray * tags = dic[@"tags"];
        NSMutableArray<TagsModel *> * muarr = [NSMutableArray new];
        for (int i = 0; i<tags.count; i++) {
            TagsModel * model = [[TagsModel alloc]initWithDictionary:tags[i]];
            [muarr addObject:model];
        }
        self.tagModels = muarr;
        
        id audio = dic[@"audio"];
        if ([audio isKindOfClass:[NSArray class]]) {
            NSArray * arr = (NSArray *)audio;
            NSMutableArray<HomeTopModel *> * muarr = [NSMutableArray new];
            for (int i = 0; i<arr.count; i++) {
                HomeTopModel * model = [[HomeTopModel alloc]initWithDictionary:arr[i]];
                [muarr addObject:model];
            }
            self.audio = muarr;
        }else if([audio isKindOfClass:[NSDictionary class]]){
            NSDictionary * dic = (NSDictionary *)audio;
            self.audioModel = [[HomeTopModel alloc]initWithDictionary:dic];
            self.audioModel.tagModels = muarr;
        }
    }
    return self;
}
- (void)checkForDownLoadList:(NSArray *)arr{

}
@end
