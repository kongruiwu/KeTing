//
//  BaseViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/5.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@property (nonatomic, assign) BOOL hasReduce;


@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CGRect fram = self.tabview.frame;
    if (!_hasReduce && [AudioPlayer instance].showFoot && self.tabview) {
        _hasReduce = YES;
        self.tabview.frame = CGRectMake(fram.origin.x, fram.origin.y, fram.size.width, fram.size.height -([AudioPlayer instance].showFoot ? Anno750(100) : 0));
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KTColor_BackGround;
    [self creatNullView];
    
}

- (void)checkNetStatus{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.netManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        [self showNullViewWithNullViewType:NullTypeNetError];
    }
}
- (void)creatLoadingViewWithColor:(UIColor *)color canTouch:(BOOL)rec{
    self.progressView = [[LoadingView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH ,UI_HEGIHT)];
    self.progressView.backgroundColor = color;
    self.progressView.userInteractionEnabled = rec;
    [self.view addSubview:self.progressView];
}
- (void)showLoadingCantTouchAndClear{
    [self creatLoadingViewWithColor:[UIColor clearColor] canTouch:YES];
}
- (void)showLoadingCantClear:(BOOL)rec{
    [self creatLoadingViewWithColor:[UIColor clearColor] canTouch:!rec];
}
- (void)showLoadingCantTouchAndGround{
    [self creatLoadingViewWithColor:[UIColor clearColor] canTouch:YES];
}

- (void)dismissLoadingView{
    if (self.progressView) {
        [self.progressView removeFromSuperview];
        self.progressView = nil;
    }
}

- (void)creatNullView{
    self.nullView = [[NullView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT) andNullType:0];
    [self.view addSubview:self.nullView];
    self.nullView.hidden = YES;
}
- (void)showNullViewWithNullViewType:(NullType)type{
    self.nullView.nullType = type;
    self.nullView.hidden = NO;
    [self.view bringSubviewToFront:self.nullView];
}
- (void)hiddenNullView{
    self.nullView.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)doBack{
    switch (self.backType) {
        case SelectorBackTypeDismiss:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case SelectorBackTypePopBack:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case SelectorBackTypePoptoRoot:
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
        default:
            break;
    }
}

- (void)setNavAlpha{
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.translucent = YES;
    UIView * clearView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, 20)];
    [self.view addSubview:clearView];
    //    导航栏变为透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:0];
    //    让黑线消失的方法
    self.navigationController.navigationBar.shadowImage=[UIImage new];
}
- (void)setNavAlphaWithWiteColor{
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = YES;
    UIView * clearView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, 20)];
    clearView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:clearView];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:0];
    self.navigationController.navigationBar.shadowImage=[UIImage new];
}
- (void)setNavUnAlpha{
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    self.navigationController.navigationBar.shadowImage = nil;
}
- (void)RefreshSetting{
    [self.refreshHeader setTitle:@"继续下拉" forState:MJRefreshStateIdle];
    [self.refreshHeader setTitle:@"松开就刷新" forState:MJRefreshStatePulling];
    [self.refreshHeader setTitle:@"刷新中 ..." forState:MJRefreshStateRefreshing];
    self.refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    
    [self.refreshFooter setTitle:@"" forState:MJRefreshStateIdle];
    [self.refreshFooter setTitle:@"就是要加载" forState:MJRefreshStateWillRefresh];
    [self.refreshFooter setTitle:@"加载中 ..." forState:MJRefreshStateRefreshing];
    [self.refreshFooter setTitle:@"已经全部加载完毕" forState:MJRefreshStateNoMoreData];
}
- (void)setNavTitle:(NSString *)title color:(UIColor *)color{
    UILabel * titleLabel = [KTFactory creatLabelWithText:title
                                               fontValue:font750(34)
                                               textColor:color
                                           textAlignment:NSTextAlignmentCenter];
    titleLabel.frame = CGRectMake(0, 0, 100, 40);
    self.navigationItem.titleView = titleLabel;
    
}
- (void)drawBackButton{
    [self drawBackButtonWithType:0];
}

- (void)drawBackButtonWithType:(BackImgType)type{
    NSString * imgName ;
    switch (type) {
        case BackImgTypeNomal:
            imgName = @"nav_back";
            break;
        case BackImgTypeWhite:
            imgName = @"back_white";
            break;
        case BackImgTypeBlack:
            imgName = @"back_black";
            break;
        default:
            break;
    }
    UIImage * image = [[UIImage imageNamed:imgName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(doBack)];
    self.navigationItem.leftBarButtonItem = leftItem;
}
/**正常模式下的分享*/
-(void)drawRightShareButton{
    UIImage * image = [[UIImage imageNamed:@"share"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
}
/**灰底的分享按钮*/
- (void)drawRightShareButtonBlackGround{
    UIImage * image = [[UIImage imageNamed:@"nav_share"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)shareButtonClick{
    
}


- (void)creatBackGroundImg{
    UIImageView * imgView = [KTFactory creatImageViewWithImage:@"register_background"];
    imgView.frame = CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT);
    [self.view addSubview:imgView];
}
@end
