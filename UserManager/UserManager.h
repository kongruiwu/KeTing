//
//  UserManager.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/28.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
#import "NetWorkManager.h"
#import "DataModel.h"

@protocol UserManagerDelegate <NSObject>

- (void)getUserInfoSucess;

@end

@interface UserManager : NSObject
/**用户信息*/
@property (nonatomic, strong) UserInfo * info;
/**是否是在登陆状态*/
@property (nonatomic, assign) BOOL isLogin;
/**用户id*/
@property (nonatomic, strong) NSString * userid;
/**用户余额*/
@property (nonatomic, strong) NSNumber * balance;
/**数据词典*/
@property (nonatomic, strong) DataModel * dataModel;
/**微信客服账号*/
@property (nonatomic, strong) NSString * serviceWeChat;
/**客服邮箱*/
@property (nonatomic, strong) NSString * serviceMail;
@property (nonatomic, strong) NSString * logo;
@property (nonatomic, assign) id<UserManagerDelegate> delegate;

+ (instancetype)manager;
/**用户登陆*/
- (void)userLoginWithInfoDic:(NSDictionary *)info;
/**获取用户信息*/
- (void)getUserInfo;
/**用户登出*/
- (void)userLogout;
/**获取字典模型*/
- (void)getDataModel;
- (void)registerDelgate:(id)obj;
@end
