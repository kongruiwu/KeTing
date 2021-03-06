//
//  ShopCarHander.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/6.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "ShopCarHander.h"

@implementation ShopCarHander

+ (instancetype)hander{
    static ShopCarHander * hander;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (hander == nil) {
            hander = [[ShopCarHander alloc]init];
            hander.dataArray = [NSMutableArray new];
            hander.money = 0;
            hander.count = 0;
        }
    });
    return hander;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        self.dataArray = [NSMutableArray new];
        self.money = 0;
        self.count = 0;
    }
    return self;
}

- (void)updateData{
    float money = 0;
    int count = 0;
    for (int i = 0; i<self.dataArray.count; i++) {
        if (self.dataArray[i].isSelect) {
            money += [self.dataArray[i].PRICE floatValue];
            count += 1;
        }
    }
    self.money = money;
    self.count = count;
    self.isAllSelect = count == (int)self.dataArray.count;
}
- (void)updateDeleteData{
    int count = 0;
    for (int i = 0; i<self.dataArray.count; i++) {
        if (self.dataArray[i].isDelete) {
            count += 1;
        }
    }
    self.deletCount = count;
    self.isAllDelete = count == (int)self.dataArray.count;
}
- (void)selectAtIndex:(NSInteger)index{
    self.dataArray[index].isSelect = !self.dataArray[index].isSelect;
    [self updateData];
}
- (void)selectToDeleteAtIndex:(NSInteger)index{
    self.dataArray[index].isDelete = !self.dataArray[index].isDelete;
    [self updateDeleteData];
}
- (void)selectAllShopCarGoods:(BOOL)rec{
    float money = 0;
    int count = 0;
    for (int i = 0; i<self.dataArray.count; i++) {
        self.dataArray[i].isSelect = rec;
        if (rec) {
            money += [self.dataArray[i].PRICE floatValue];
            count += 1;
        }
    }
    self.money = money;
    self.count = count;
    self.isAllSelect = rec;
}
- (void)selectAllToDelete:(BOOL)rec{
    int count = 0;
    for (int i = 0; i< self.dataArray.count; i++) {
        self.dataArray[i].isDelete =  rec;
        count += 1;
    }
    self.deletCount = count;
    self.isAllDelete = rec;
}
- (NSMutableString *)getDeleteIdStr{
    NSMutableString * str = [[NSMutableString alloc]init];
    for (int i = 0; i<self.dataArray.count; i++) {
        if (self.dataArray[i].isDelete) {
            if (i == 0) {
                [str appendFormat:@"%@",self.dataArray[i].id];
            }else{
                [str appendFormat:@",%@",self.dataArray[i].id];
            }
        }
    }
    return str;
}

@end
