//
//  WKWebViewController.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/12.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>

typedef NS_ENUM(NSInteger, PROTOCOLTYPE){
    PROTOCOLTYPETEXT    = 0 ,//文稿
    PROTOCOLTYPEAGREE   = 1 ,//服务协议
    PROTOCOLTYPEPRIVACY     ,//隐私协议
    PROTOCOLTYPEBALANCE     ,//余额支付协议
    PROTOCOLTYPEELSETEXT    ,//其余文稿
};


@interface WKWebViewController : BaseViewController

@property (nonatomic, strong) WKWebView * webView;
@property (nonatomic, assign) PROTOCOLTYPE webType;
@property (nonatomic, strong) HomeTopModel * model;

@end
