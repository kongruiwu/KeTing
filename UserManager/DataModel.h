//
//  DataModel.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/5.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "BaseModel.h"

@interface DataModel : BaseModel

/**内购价格 数据模型*/
@property (nonatomic, strong) NSArray * amount;
@property (nonatomic, strong) NSArray * sex;
/**投资方向 数据模型*/
@property (nonatomic, strong) NSDictionary * typ_id;
/**付款方式 数据模型*/
@property (nonatomic, strong) NSDictionary * order_cycle;
/**学历 数据模型*/
@property (nonatomic, strong) NSDictionary * edu_id;
/**学历数据*/
@property (nonatomic, strong) NSArray * eduNames;
@property (nonatomic, strong) NSArray * eduIds;
/**投资数据*/
@property (nonatomic, strong) NSArray * typNames;
@property (nonatomic, strong) NSArray * typIds;
/**购买价格单位*/
@property (nonatomic, strong) NSArray * orderNames;
@property (nonatomic, strong) NSArray * orderIDs;
@end
