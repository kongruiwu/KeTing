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
/**是否删除状态下全选*/
@property (nonatomic, assign) BOOL isAllDelete;
/**合计价钱*/
@property (nonatomic, assign) float money;
/**选择总数*/
@property (nonatomic, assign) int count;

/**编辑状态*/
@property (nonatomic, assign) BOOL isEditStatus;

/**删除选择总数*/
@property (nonatomic) int deletCount;
+ (instancetype)hander;
/**item选择*/
- (void)selectAtIndex:(NSInteger)index;
/**编辑状态下 选择*/
- (void)selectToDeleteAtIndex:(NSInteger)index;
/**全选*/
- (void)selectAllShopCarGoods:(BOOL)rec;
/**删除状态下全选*/
- (void)selectAllToDelete:(BOOL)rec;

- (NSMutableString *)getDeleteIdStr;

- (void)updateData;

- (void)updateDeleteData;
@end
