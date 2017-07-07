//
//  AnchorModel.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/14.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "BaseModel.h"
#import "HomeListenModel.h"
@interface AnchorModel : BaseModel
/**简介*/
@property (nonatomic, strong) NSString * summary;
/**排序*/
@property (nonatomic, strong) NSString * sortNum;
/**禁用时间*/
@property (nonatomic, strong) NSNumber * hiddenTime;
/**主播的数据列表*/
@property (nonatomic, strong) NSArray * listenVolice;
/**修改时间*/
@property (nonatomic, strong) NSNumber * editTime;
/**用户头像*/
@property (nonatomic, strong) NSString * face;
/**主播id*/
@property (nonatomic, strong) NSString * anchorId;
/**0正常 1禁用*/
@property (nonatomic, strong) NSNumber * anchorStatus;
/**0 男 1 女*/
@property (nonatomic, strong) NSNumber * sex;
/**主播名称*/
@property (nonatomic, strong) NSString * name;
/**添加时间*/
@property (nonatomic, strong) NSNumber * addTime;
/**是否订阅*/
@property (nonatomic, assign) BOOL isbuy;
/**是否加入购物车*/
@property (nonatomic, assign) BOOL iscart;
/**优惠后价格*/
@property (nonatomic, strong) NSNumber * selfPrice;
/**优惠类型*/
@property (nonatomic, strong) NSString * selfStatus;
@end
