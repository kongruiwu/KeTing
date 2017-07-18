//
//  CommonInfo.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/18.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "BaseModel.h"

@interface CommonInfo : BaseModel

@property (nonatomic, strong) NSString * logo;
//微信客服账号
@property (nonatomic, strong) NSString * serviceWeChat;
//客服邮箱
@property (nonatomic, strong) NSString * serviceMail;
//服务协议
@property (nonatomic, strong) NSString * agreement;
//隐私协议
@property (nonatomic, strong) NSString * privacy;
//余额支付协议
@property (nonatomic, strong) NSString * balancePayAgreement;
//微信支付协议
@property (nonatomic, strong) NSString * webchatPayAgreement;
@end
