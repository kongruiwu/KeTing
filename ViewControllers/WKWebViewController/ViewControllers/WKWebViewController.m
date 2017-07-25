//
//  WKWebViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/12.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "WKWebViewController.h"
#import "ShareView.h"
#import "CommonInfo.h"
#import "Commond.h"
#import "RootViewController.h"
@interface WKWebViewController ()<WKNavigationDelegate>

@property (nonatomic, strong) ShareView * shareView;
@property (nonatomic, strong) CommonInfo * common;
@end

@implementation WKWebViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self setNavUnAlpha];
    CGRect frame = self.webView.frame;
    if (self.isFromNav) {
        self.webView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height -([AudioPlayer instance].showFoot ? Anno750(100) : 0));
    }else{
        self.webView.frame = CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT- 64);
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawBackButtonWithType:BackImgTypeBlack];
    NSString * title;
    switch (self.webType) {
        case PROTOCOLTYPETEXT:
            title = [AudioPlayer instance].currentAudio.audioName;
            break;
        case PROTOCOLTYPEAGREE:
            title = @"服务协议";
            break;
        case PROTOCOLTYPEBALANCE:
            title = @"余额支付协议";
            break;
        case PROTOCOLTYPEPRIVACY:
            title = @"隐私协议";
            break;
        case PROTOCOLTYPEELSETEXT:
            title = self.model.audioName;
            break;
        default:
            break;
    }
    [self setNavTitle:title color:KTColor_MainBlack];
    [self creatUI];
    if (self.webType == 0) {
        [self drawRightShareButton];
    }
    [self getCommonInfo];
    
}
- (void)shareButtonClick{
    if (self.isFromNav) {
        RootViewController * tbc = (RootViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
        [tbc.shareView show];
    }else{
        [self.shareView show];
    }
    
}
- (void)creatUI{
    
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT - 64)];
    if (self.webType == 0) {
        [self.webView loadHTMLString:[Commond getStringFromHTML5String:[AudioPlayer instance].currentAudio.audioContent].string baseURL:nil];
    }else if(self.webType == PROTOCOLTYPEELSETEXT){
        [self.webView loadHTMLString:[Commond getStringFromHTML5String:self.model.audioContent].string baseURL:nil];
    }
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    if (!self.isFromNav) {
        self.shareView = [[ShareView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT - 64) hasNav:YES];
        [self.view addSubview:self.shareView];
    }
    
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    //修改字体大小 300%
    [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '250%'" completionHandler:nil];
    
    //修改字体颜色
    [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#666666'" completionHandler:nil];
    
}
- (void)getCommonInfo{
    //用户协议
    [[NetWorkManager manager] GETRequest:@{} pageUrl:Page_About complete:^(id result) {
       self.common = [[CommonInfo alloc]initWithDictionary:result];
        switch (self.webType) {
            case PROTOCOLTYPEAGREE:
                [self.webView loadHTMLString:[Commond getStringFromHTML5String:self.common.agreement].string baseURL:nil];
                break;
            case PROTOCOLTYPEBALANCE:
                [self.webView loadHTMLString:[Commond getStringFromHTML5String:self.common.balancePayAgreement].string baseURL:nil];
                break;
            case PROTOCOLTYPEPRIVACY:
                [self.webView loadHTMLString:[Commond getStringFromHTML5String:self.common.privacy].string baseURL:nil];
                break;
            default:
                break;
        }
    } errorBlock:^(KTError *error) {
        
    }];
}
@end
