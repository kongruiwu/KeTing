//
//  UserManager.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/28.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "UserManager.h"

@implementation UserManager

+ (instancetype)manager{
    static UserManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[UserManager alloc]init];
            manager.userid = @"";
            manager.isLogin = NO;
        }
    });
    return manager;
}

- (NSString *)userid{
    id userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
    if (userID) {
        NSString * idstr = (NSString *)userID;
        if (idstr.length > 0) {
            return (NSString *)userID;
        }
    }
    return @"";
}

- (void)userLoginWithInfoDic:(NSDictionary *)info{
    self.info = [[UserInfo alloc] initWithDictionary:info];
    self.userid = self.info.USERID;
    self.isLogin = !self.info.isPort;
}
- (void)userLogout{
    self.info = nil;
    self.userid = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"USERID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.balance = @0;
}

- (void)getUserInfo{
    id userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
    if (!userID) {
        [self getDeviceUserInfo];
        return;
    }
    NSDictionary * params =  @{
                               @"userid":self.userid
                               };
    [[NetWorkManager manager] GETRequest:params pageUrl:Page_UserInfo complete:^(id result) {
        [self userLoginWithInfoDic:result];
        if ([self.delegate respondsToSelector:@selector(getUserInfoSucess)]) {
            [self.delegate getUserInfoSucess];
        }
    } errorBlock:^(KTError *error) {

    }];
    
    if (![UserManager manager].isLogin) {
        return;
    }
    [[NetWorkManager manager] GETRequest:@{} pageUrl:Page_UserAccount complete:^(id result) {
        NSDictionary * dic = result[@"list"];
        if (dic[@"accountBalance"]) {
            self.balance = dic[@"accountBalance"];
        }
    } errorBlock:^(KTError *error) {
        
    }];
}

- (void)getDeviceUserInfo{
    [[NetWorkManager manager] GETRequest:@{} pageUrl:Page_Register2 complete:^(id result) {
        NSDictionary * dic = result;
        NSDictionary * user = dic[@"USER"];
        [UserManager manager].info = [[UserInfo alloc]initWithDictionary:user];
        [UserManager manager].userid = [NSString stringWithFormat:@"%@",[UserManager manager].info.USERID];
        [self getUserInfo];
    } errorBlock:^(KTError *error) {
        
        
    }];
    
}

- (void)getDataModel{
    //数据字典
    [[NetWorkManager manager] GETRequest:@{} pageUrl:Page_DataModel complete:^(id result) {
        self.dataModel = [[DataModel alloc]initWithDictionary:result];
    } errorBlock:^(KTError *error) {
        
    }];
    //用户协议
    [[NetWorkManager manager] GETRequest:@{} pageUrl:Page_About complete:^(id result) {
        NSDictionary * dic = (NSDictionary *)result;
        if ([dic isKindOfClass:[NSDictionary class]]) {
            if (dic[@"serviceWeChat"]) {
                self.serviceWeChat = dic[@"serviceWeChat"];
            }
            if (dic[@"serviceMail"]) {
                self.serviceMail = dic[@"serviceMail"];
            }
            if (dic[@"logo"]){
                self.logo = dic[@"logo"];
            }
        }
    } errorBlock:^(KTError *error) {
        
    }];
}
- (void)registerDelgate:(id)obj{
    self.delegate = obj;
}
@end
