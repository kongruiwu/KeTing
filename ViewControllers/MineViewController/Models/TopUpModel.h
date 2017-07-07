//
//  TopUpModel.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/6.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "BaseModel.h"

@interface TopUpModel : BaseModel

@property (nonatomic, strong) NSString * goodName;
@property (nonatomic, strong) NSNumber * goodType;
@property (nonatomic, strong) NSNumber * orderId;
@property (nonatomic, strong) NSNumber * orderNo;
@property (nonatomic, strong) NSString * orderPrice;
@property (nonatomic, strong) NSNumber * orderType;
@property (nonatomic, strong) NSString * payAmount;
@property (nonatomic, strong) NSNumber * payMethod;
@property (nonatomic, strong) NSNumber * payStatus;
@property (nonatomic, strong) NSNumber * payTime;

@end
