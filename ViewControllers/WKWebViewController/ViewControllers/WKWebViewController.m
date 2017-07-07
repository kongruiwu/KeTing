//
//  WKWebViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/12.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "WKWebViewController.h"
#import "ShareView.h"
@interface WKWebViewController ()<WKNavigationDelegate>

@property (nonatomic, strong) ShareView * shareView;

@end

@implementation WKWebViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavUnAlpha];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawBackButtonWithType:BackImgTypeBlack];
    [self setNavTitle:@"文稿" color:KTColor_MainBlack];
    [self creatUI];
    [self drawRightShareButton];
}
- (void)shareButtonClick{
    [self.shareView show];
}
- (void)creatUI{
    
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT - 64)];
    [self.webView loadHTMLString:[AudioPlayer instance].currentAudio.audioContent baseURL:nil];
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    
    self.shareView = [[ShareView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT - 64) hasNav:YES];
    [self.view addSubview:self.shareView];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    //修改字体大小 300%
    [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '250%'" completionHandler:nil];
    
    //修改字体颜色
    [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#666666'" completionHandler:nil];
    
}
@end
