//
//  OrderModel.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/18.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "BaseModel.h"

@interface OrderModel : BaseModel
@property (nonatomic, strong) NSNumber * addTime;
@property (nonatomic, strong) NSNumber * endTime;
@property (nonatomic, strong) NSString * goodName;
/**订单号*/
@property (nonatomic, strong) NSNumber * goodType;
@property (nonatomic, strong) NSString * nickName;
/**订单id*/
@property (nonatomic, strong) NSString * orderId;
/**订单号*/
@property (nonatomic, strong) NSString * orderNo;
@property (nonatomic, strong) NSNumber * orderPrice;
/**订单类型：0是充值 1是消费*/
@property (nonatomic, strong) NSNumber * orderType;
@property (nonatomic, strong) NSNumber * payAmount;
/**实际付款金额*/
@property (nonatomic, strong) NSNumber * payMethod;
/**1是支付成功 2是支付失败*/
@property (nonatomic, strong) NSNumber * payStatus;
@property (nonatomic, strong) NSNumber * payTime;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * userId;
@end
