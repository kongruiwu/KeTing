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
- (void)selectAtIndex:(NSInteger)index{
    self.dataArray[index].isSelect = !self.dataArray[index].isSelect;
    [self updateData];
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

@end
