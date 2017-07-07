//
//  ShopCarHander.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/6.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeListenModel.h"
@interface ShopCarHander : NSObject
/**数据*/
@property (nonatomic, strong) NSMutableArray<HomeListenModel *> * dataArray;
/**是否全选*/
@property (nonatomic, assign) BOOL isAllSelect;
/**合计价钱*/
@property (nonatomic, assign) float money;
/**选择总数*/
@property (nonatomic, assign) int count;
+ (instancetype)hander;
/**item选择*/
- (void)selectAtIndex:(NSInteger)index;
/**全选*/
- (void)selectAllShopCarGoods:(BOOL)rec;
@end
