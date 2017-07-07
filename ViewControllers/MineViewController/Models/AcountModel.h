//
//  AcountModel.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/6.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "BaseModel.h"

@interface AcountModel : BaseModel
/**自动编号*/
@property (nonatomic, strong) NSNumber * assetId;
/**用户Id*/
@property (nonatomic, strong) NSNumber * userId;
/**账户余额*/
@property (nonatomic, strong) NSNumber * accountBalance;
/**累计消费金额*/
@property (nonatomic, strong) NSNumber * allSpend;
/**累计充值金额*/
@property (nonatomic, strong) NSNumber * allRecharge;
/**首次消费时间*/
@property (nonatomic, strong) NSNumber * firstSpendTime;
/**最后消费时间*/
@property (nonatomic, strong) NSNumber * lastSpendTime;
/**首次充值时间*/
@property (nonatomic, strong) NSNumber * firstRechargeTime;
/**最后充值时间*/
@property (nonatomic, strong) NSNumber * lastRechargeTime;
/**账户开通时间*/
@property (nonatomic, strong) NSNumber * addTime;
/**更新时间*/
@property (nonatomic, strong) NSNumber * editTime;
@end
