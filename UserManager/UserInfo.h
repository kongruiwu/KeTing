//
//  UserInfo.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/28.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "BaseModel.h"

@interface UserInfo : BaseModel
/**用户id*/
@property (nonatomic, strong) NSString * USERID;
/**用户名称*/
@property (nonatomic, strong) NSString * UNAME;
/**用户昵称*/
@property (nonatomic, strong) NSString * NICKNAME;
/**用户头像*/
@property (nonatomic, strong) NSString * ICON;
/**1男0女*/
@property (nonatomic, assign) BOOL Sex;
/**票据*/
@property (nonatomic, strong) NSString * TICKET;
/**邮箱*/
@property (nonatomic, strong) NSString * EMAIL;
/**手机号*/
@property (nonatomic, strong) NSString * MOBILE;
/**QQ号*/
@property (nonatomic, strong) NSString * QQ;
/**真实姓名*/
@property (nonatomic, strong) NSString * REALNAME;
/**创建时间*/
@property (nonatomic, strong) NSNumber * CREATEDATE;
/**身份证号码*/
@property (nonatomic, strong) NSString * CARDNUM;
/**手机认证状态*/
@property (nonatomic, strong) NSString * MOBILE_STATE;
/**邮箱认证状态*/
@property (nonatomic, strong) NSString * EMAIL_STATE;
/**实名认证状态*/
@property (nonatomic, strong) NSString * IDCARD_STATE;
/**新浪认证状态*/
@property (nonatomic, strong) NSString * SINA_STATE;
/**大v认证状态*/
@property (nonatomic, strong) NSString * V_STATE;
/**qq认证状态*/
@property (nonatomic, strong) NSString * QQ_STATE;
/**经验id*/
@property (nonatomic, strong) NSString * EXP_ID;
/**经验名称*/
@property (nonatomic, strong) NSString * EXP_NAME;
/**投资风格*/
@property (nonatomic, strong) NSString * STY_ID;
/**投资风格*/
@property (nonatomic, strong) NSString * STY_NAME;
/**投资品种ID*/
@property (nonatomic, strong) NSString * TYP_ID;
/**投资品种名称*/
@property (nonatomic, strong) NSString * TYP_NAME;
/**省ID*/
@property (nonatomic, strong) NSString * PROV_ID;
/**省名称*/
@property (nonatomic, strong) NSString * PROV_NAME;
/**市ID*/
@property (nonatomic, strong) NSString * CITY_ID;
/**市名称*/
@property (nonatomic, strong) NSString * CITY_NAME;
/**上次登录时间*/
@property (nonatomic, strong) NSNumber * PREVIOUS_LOGIN_TIME;
/**登录次数*/
@property (nonatomic, strong) NSNumber * LOGINNUM;
/**公开邮箱*/
@property (nonatomic, strong) NSString * OPENEMAIL;
/**个性签名*/
@property (nonatomic, strong) NSString * SIGN;
/**上次登录时间*/
@property (nonatomic, strong) NSNumber * PREVIOUS_LOGIN_TIM;
/**listenCount:收听书籍数量
 listenLong:收听时间*/
@property (nonatomic, strong) NSDictionary * listenCount;
/**连续登录天数*/
@property (nonatomic, strong) NSString * loginday;
/**学历*/
@property (nonatomic, strong) NSString * EDU_NAME;
/**学历编号*/
@property (nonatomic, strong) NSNumber * EDU_ID;
@property (nonatomic, strong) NSString * Twon;
/**生日*/
@property (nonatomic, strong) NSString * Birthday;
/**生日  时间戳形式*/
@property (nonatomic, strong) NSString * BIRTHDAY;
@property (nonatomic, strong) NSString * Pword;
@property (nonatomic, strong) NSString * IND_ID;

/**是否为游客模式*/
@property (nonatomic, assign) BOOL isPort;
@end
