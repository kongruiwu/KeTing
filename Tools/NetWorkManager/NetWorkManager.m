//
//  NetWorkManager.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/6.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "NetWorkManager.h"
#import "ADTracking.h"
#import "OpenUDID.h"
#import "iPhoneModel.h"
@implementation NetWorkManager

+ (instancetype)manager{
    static NetWorkManager * manger;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manger = [[NetWorkManager alloc]init];
    });
    return manger;
}

- (void)POSTRequest:(NSDictionary *)params pageUrl:(NSString *)pageUrl complete:(CompleteBlock)complete errorBlock:(ErrorBlock)errorBlock{
    [self sendRequestType:RequestTypePOST params:params pageUrl:pageUrl complete:complete errorBlock:errorBlock];
}
- (void)GETRequest:(NSDictionary *)params pageUrl:(NSString *)pageUrl complete:(CompleteBlock)complete errorBlock:(ErrorBlock)errorBlock{
    [self sendRequestType:RequestTypeGET params:params pageUrl:pageUrl complete:complete errorBlock:errorBlock];
}

- (void)sendRequestType:(RequestType)type params:(NSDictionary *)params pageUrl:(NSString *)pageUrl complete:(CompleteBlock)complete errorBlock:(ErrorBlock)errorBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString * url = pageUrl;
    if (!([pageUrl hasPrefix:@"http"] || [pageUrl hasPrefix:@"https"])) {
        url = [NSString stringWithFormat:@"%@%@",Base_Url,pageUrl];
    }
    DLog(@"=================================\n%@\n=================================",params);
    DLog(@"=================================\n%@\n=================================",url);
    
    [self setReqeustHeader:manager];
    
    if (type ==RequestTypeGET) {
        [manager.requestSerializer setHTTPShouldHandleCookies:NO];
        [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            DLog(@"=================================\n%@\n=================================",responseObject);
            NSDictionary * dic = (NSDictionary *)responseObject;
            if ([dic[@"code"] intValue]  != 100 ) {
                KTError * err = [[KTError alloc]init];
                err.code = [NSString stringWithFormat:@"%@",dic[@"code"]];
                err.message = dic[@"msg"];
                errorBlock(err);
#ifdef DEBUG
//                [ToastView presentToastWithin:[UIApplication sharedApplication].keyWindow withIcon:APToastIconNone text:[NSString stringWithFormat:@"错误码：%@  \n 错误信息 %@",err.code,err.message] duration:2.0f];
#endif
            }else{
                complete(dic[@"data"]);
                DLog(@"%@",dic[@"msg"]);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [error localizedDescription];
            KTError * err = [[KTError alloc]init];
            err.code = [NSString stringWithFormat:@"%ld",(long)error.code];
            err.message = @"网络似乎有点问题！";
            errorBlock(err);
#ifdef DEBUG
//            [ToastView presentToastWithin:[UIApplication sharedApplication].keyWindow withIcon:APToastIconNone text:[NSString stringWithFormat:@"错误码：%@  \n 错误信息 %@",err.code,err.message] duration:2.0f];
#endif
        }];
    }else{
        [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            DLog(@"=================================\n%@\n=================================",responseObject);
            NSDictionary * dic = (NSDictionary *)responseObject;
            if ([dic[@"code"] intValue]  != 100 ) {
                KTError * err = [[KTError alloc]init];
                err.code = [NSString stringWithFormat:@"%@",dic[@"code"]];
                err.message = dic[@"msg"];
                errorBlock(err);
#ifdef DEBUG
//                [ToastView presentToastWithin:[UIApplication sharedApplication].keyWindow withIcon:APToastIconNone text:[NSString stringWithFormat:@"错误码：%@  \n 错误信息 %@",err.code,err.message] duration:2.0f];
#endif
            }else{
                complete(dic[@"data"]);
                DLog(@"%@",dic[@"msg"]);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [error localizedDescription];
            KTError * err = [[KTError alloc]init];
            err.code = [NSString stringWithFormat:@"%ld",(long)error.code];
            err.message = @"网络似乎有点问题！";
            errorBlock(err);
#ifdef DEBUG
//            [ToastView presentToastWithin:[UIApplication sharedApplication].keyWindow withIcon:APToastIconNone text:[NSString stringWithFormat:@"错误码：%@  \n 错误信息 %@",err.code,err.message] duration:2.0f];
#endif
        }];
    }
}

//请求头设置
- (void)setReqeustHeader:(AFHTTPSessionManager *)manager{
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html",@"application/javascript",@"application/json", nil];
    manager.requestSerializer.timeoutInterval = 30;
    //NXS
    long long curtime = time(NULL);
    long long nonce = 123456;
    char szOpenKey[256] = {0};
    sprintf(szOpenKey, "%s%lld%lld%s","iOS-1491448896", nonce, curtime, "4ce2bd1102d324a9982837b53766f68da2ba512b");
    NSString *MD5 = [Commond md5String:szOpenKey];
    
    [manager.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"CLIENT"];
    [manager.requestSerializer setValue:@"iOS-1491448896" forHTTPHeaderField:@"APPID"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%lld", nonce] forHTTPHeaderField:@"NONCE"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%lld", curtime] forHTTPHeaderField:@"CURTIME"];
    [manager.requestSerializer setValue:MD5 forHTTPHeaderField:@"OPENKEY"];
    NSString * userid = @"0";
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]) {
        userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
        if (userid.length ==0) {
            userid = @"0";
        }
    }
    [manager.requestSerializer setValue:userid forHTTPHeaderField:@"USERID"];
    [manager.requestSerializer setValue:INCASE_EMPTY([[ADTracking instance] idfaString], [OpenUDID value]) forHTTPHeaderField:@"DEVICECODE"];
    [manager.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"DEVICENAME"];
    NSString * sysVersion = [NSString stringWithFormat:@"IOS %@", [[UIDevice currentDevice] systemVersion]];
    [manager.requestSerializer setValue:sysVersion forHTTPHeaderField:@"SYSTEMVERSION"];
    [manager.requestSerializer setValue:[iPhoneModel iphoneType] forHTTPHeaderField:@"PHONETYPE"];
}

@end
