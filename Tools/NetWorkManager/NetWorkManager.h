//
//  NetWorkManager.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/6.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTError.h"
#import <AFNetworking.h>
#import "API.h"
#import "ConfigHeader.h"
#import "Commond.h"
#import "UserManager.h"
typedef NS_ENUM(NSInteger,RequestType){
    RequestTypePOST = 0,
    RequestTypeGET
};
typedef void(^CompleteBlock)(id result);
typedef void(^ErrorBlock)(KTError * error);

@interface NetWorkManager : NSObject

+ (instancetype)manager;
/**请求头设置*/
- (void)setReqeustHeader:(AFHTTPSessionManager *)manager;

//- (void)uploadImage:(UIImage *)image;

- (void)POSTRequest:(NSDictionary *)params pageUrl:(NSString *)pageUrl complete:(CompleteBlock)complete errorBlock:(ErrorBlock)errorBlock;

- (void)GETRequest:(NSDictionary *)params pageUrl:(NSString *)pageUrl complete:(CompleteBlock)complete errorBlock:(ErrorBlock)errorBlock;

- (void)sendRequestType:(RequestType)type params:(NSDictionary *)params pageUrl:(NSString *)pageUrl complete:(CompleteBlock)complete errorBlock:(ErrorBlock)errorBlock;
@end
