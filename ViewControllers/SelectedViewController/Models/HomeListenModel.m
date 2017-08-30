//
//  HomeListenModel.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/6.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "HomeListenModel.h"
#import "SqlManager.h"
#import "HistorySql.h"
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
        if ([self.promotionType integerValue] == 1) {
            self.PRICE = dic[@"selfPrice"];
        }
        self.price = [NSString stringWithFormat:@"%.2f",[self.PRICE floatValue]];
        if ([self.promotionType integerValue] == 0) {
            self.timePrice = [NSString stringWithFormat:@"%@牛币%@",self.price,time];
        }else{
            self.timePrice = [NSString stringWithFormat:@"  %@牛币%@",self.price,time];
        }
        self.timePrice2 = [NSString stringWithFormat:@"%@牛币%@",self.price,time];
        
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
                model.relationId = self.listenId;
                model.relationType = self.catId;
                if ((!model.tagName || model.tagName.length == 0)&& self.tagModels.count >0) {
                    model.tagName = self.tagModels[0].tagName;
                }
                NSNumber * status = [[SqlManager manager] checkDownStatusWithAudioid:model.audioId];
                if ([status integerValue] != 1000) {
                    model.downStatus = status;
                }
                model.playLong = [[HistorySql sql] getPlayLongWithAudioID:model.audioId];
                [muarr addObject:model];
            }
            self.audio = muarr;
        }else if([audio isKindOfClass:[NSDictionary class]]){
            NSDictionary * dic = (NSDictionary *)audio;
            self.audioModel = [[HomeTopModel alloc]initWithDictionary:dic];
            self.audioModel.relationId = self.listenId;
            self.audioModel.relationType = self.catId;
            self.audioModel.tagModels = muarr;
            if ((!self.audioModel.tagName || self.audioModel.tagName.length == 0)&& self.tagModels.count >0) {
                self.audioModel.tagName = self.tagModels[0].tagName;
            }
        }
        
        self.isDownLoad = NO;
        self.isDelete = NO;
        if (self.audioModel) {
            NSNumber * downStatu = [[SqlManager manager] checkDownStatusWithAudioid:self.audioModel.audioId];
            if ([downStatu integerValue] == 2) {
                self.isDownLoad = YES;
            }
        }
        
    }
    return self;
}
- (void)checkForDownLoadList:(NSArray *)arr{

}
@end
