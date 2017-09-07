//
//  ListenDetailViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/13.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "ListenDetailViewController.h"
#import "VoiceDetailHeader.h"
#import "VoiceSummaryCell.h"
#import "VoiceUpdateListCell.h"
#import "ListenAnchorCell.h"
#import "AnchorDetailViewController.h"
#import "ShopCarViewController.h"
//#import "AudioPlayerViewController.h"
#import "SetAccoutViewController.h"
#import "LoginViewController.h"
#import "AudioDownLoader.h"
#import "RootViewController.h"
#import <MLTransition.h>
#import "ListenDetailHeader.h"
@interface ListenDetailViewController ()<UITableViewDelegate,UITableViewDataSource,AudioDownLoadDelegate>

@property (nonatomic, strong) ListenDetailHeader * header;
@property (nonatomic, strong) HomeListenModel * listenModel;

@property (nonatomic, strong) UIButton * likeBtn;
@property (nonatomic, strong) UIButton * shopBtn;
@property (nonatomic, strong) UIButton * buyBtn;
@property (nonatomic, strong) UILabel * countLabel;

@end

@implementation ListenDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [AudioDownLoader loader].delegate = self;
    [self getData];
    [self checkNetStatus];
    [self setNavUnAlpha];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [AudioDownLoader loader].delegate = nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavUnAlpha];
    [self drawBackButtonWithType:BackImgTypeBlack];
    [self drawRightShopCar];
    [self creatUI];
}
- (void)drawRightShopCar{
    UIButton * button = [KTFactory creatButtonWithNormalImage:@"listenshopping cart" selectImage:nil];
    button.frame = CGRectMake(0, 0, Anno750(64), Anno750(64));
    self.countLabel = [KTFactory creatLabelWithText:@"0"
                                          fontValue:font750(20)
                                          textColor:[UIColor whiteColor]
                                      textAlignment:NSTextAlignmentCenter];
    self.countLabel.backgroundColor = KTColor_IconOrange;
    self.countLabel.layer.masksToBounds = YES;
    self.countLabel.layer.cornerRadius = Anno750(15);
    self.countLabel.hidden = YES;
    [button addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(button.mas_centerX).offset(Anno750(5));
        make.bottom.equalTo(button.mas_centerY).offset(Anno750(-5));
        make.height.equalTo(@(Anno750(30)));
        make.width.equalTo(@(Anno750(30)));
    }];
    [button addTarget:self action:@selector(goShopCar) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UIImage * image = [[UIImage imageNamed:@"Webshare"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem * barItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(showShareView)];
    self.navigationItem.rightBarButtonItems = @[barItem,rightItem];
}
- (void)creatUI{
    self.tabview = [KTFactory creatTabviewWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT - 64) style:UITableViewStylePlain];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
    
    self.header  = [[ListenDetailHeader alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, Anno750(410))];
    self.tabview.tableHeaderView = self.header;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView * headView = [KTFactory creatViewWithColor:[UIColor whiteColor]];
    headView.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(100));
    UIButton * likeBtn = [KTFactory creatButtonWithTitle:[NSString stringWithFormat:@"  %@",self.listenModel.praseNum ? self.listenModel.praseNum : @0]
                                         backGroundColor:[UIColor clearColor]
                                               textColor:KTColor_MainOrange
                                                textSize:font750(30)];
    [likeBtn setImage:[UIImage imageNamed:@"listen_like"] forState:UIControlStateNormal];
    [likeBtn setImage:[UIImage imageNamed:@"listen_liked"] forState:UIControlStateSelected];
    likeBtn.selected = self.listenModel.isprase;
    [likeBtn addTarget:self action:@selector(likeThisBookClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * shopCar = [KTFactory creatButtonWithTitle:@"  购物车"
                                         backGroundColor:[UIColor clearColor]
                                               textColor:KTColor_MainOrange
                                                textSize:font750(30)];
    if (self.listenModel.Isbuy || self.listenModel.isFree || [self.listenModel.promotionType integerValue] == 2) {
        [shopCar setTitle:@"  下载" forState:UIControlStateNormal];
        if (self.listenModel.isDownLoad) {
            [shopCar setImage:[UIImage imageNamed:@"listen_downed"] forState:UIControlStateNormal];
        }else{
            //分为下载中与未下载
            [shopCar setImage:[UIImage imageNamed:@"voice_download"] forState:UIControlStateNormal];
        }
    }else{
        [shopCar setTitle:@"  购物车" forState:UIControlStateNormal];
        if (self.listenModel.iscart) {
            [shopCar setImage:[UIImage imageNamed:@"Listen-Shoped"] forState:UIControlStateNormal];
        }else{
            [shopCar setImage:[UIImage imageNamed:@"shopcar"] forState:UIControlStateNormal];
        }
    }
    self.shopBtn = shopCar;
    shopCar.selected = self.listenModel.Isbuy;
    [shopCar addTarget:self action:@selector(addThisBookShopCar:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * buyBtn = [KTFactory creatButtonWithTitle:[NSString stringWithFormat:@"购买：%@",self.listenModel.timePrice ? self.listenModel.timePrice :@0.00]
                                        backGroundColor:KTColor_MainOrange
                                              textColor:[UIColor whiteColor]
                                               textSize:font750(30)];
    [buyBtn setTitle:@"  开始听" forState:UIControlStateSelected];
    [buyBtn setImage:[UIImage imageNamed:@"listen"] forState:UIControlStateSelected];
    buyBtn.selected = self.listenModel.Isbuy || self.listenModel.isFree || [self.listenModel.promotionType integerValue] == 2;
    [buyBtn addTarget:self action:@selector(buyThisBookRequest:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:likeBtn];
    [headView addSubview:shopCar];
    [headView addSubview:buyBtn];
    [likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.centerY.equalTo(@0);
        make.width.equalTo(@(Anno750(170)));
        make.height.equalTo(@(Anno750(68)));
    }];
    [shopCar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(likeBtn.mas_right).offset(Anno750(30));
        make.width.equalTo(@(Anno750(170)));
        make.height.equalTo(@(Anno750(68)));
        make.centerY.equalTo(@0);
    }];
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Anno750(24)));
        make.centerY.equalTo(@0);
        make.left.equalTo(shopCar.mas_right).offset(Anno750(30));
        make.height.equalTo(@(Anno750(68)));
    }];
    likeBtn.layer.borderColor = KTColor_MainOrange.CGColor;
    likeBtn.layer.borderWidth = 1.0f;
    likeBtn.layer.cornerRadius= 2.0f;
    shopCar.layer.borderColor = KTColor_MainOrange.CGColor;
    shopCar.layer.borderWidth = 1.0f;
    shopCar.layer.cornerRadius= 2.0f;
    buyBtn.layer.cornerRadius = 2.0f;
    
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Anno750(100);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return Anno750(128);
    }
    CGSize size = [KTFactory getSize:[KTFactory changeHtmlString:self.listenModel.descString withFont:font750(28)] maxSize:CGSizeMake(font750(702), 99999)];
    return Anno750(80)+ size.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        static NSString * cellid = @"ListenAnchorCell";
        ListenAnchorCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[ListenAnchorCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        [cell updateWithIcon:self.listenModel.anchorFace name:self.listenModel.anchorName];
        return cell;
    }
    
    static NSString * cellid = @"summaryCell";
    VoiceSummaryCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[VoiceSummaryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    [cell updateWithDescString:self.listenModel.descString time:self.listenModel.audioModel.audioLong];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        AnchorDetailViewController * vc = [AnchorDetailViewController new];
        vc.anchorID = self.listenModel.anchorId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - 分享
- (void)showShareView{
    if (!self.listenModel) {
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"无网络，暂时无法分享" duration:1.0f];
        return;
    }
    
    ShareModel * model = [[ShareModel alloc]init];
    model.shareTitle = self.listenModel.name;
    model.shareDesc = self.listenModel.summary;
    UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.listenModel.thumb]]];
    model.image = image;
    model.targeturl = [NSString stringWithFormat:@"%@%@%@",Base_Url,Page_ShareListen,self.listenModel.listenId];
    RootViewController * tbc = (RootViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    [tbc.shareView updateWithShareModel:model];
    [tbc.shareView show];
}

#pragma mark - 查看购物车
- (void)goShopCar{
    if (![UserManager manager].isLogin) {
        LoginViewController * vc = [LoginViewController new];
        UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nvc animated:YES completion:nil];
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        ShopCarViewController * vc = [ShopCarViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - 重写返回方式
- (void)doBack{
    [super doBack];
    if (!self.isFromAnchor) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}
- (void)getData{
    NSNumber * listenid ;
    if (self.listenModel) {
        listenid = self.listenModel.listenId;
    }else{
        listenid = self.listenID;
    }
    [self showLoadingCantTouchAndGround];
    [[NetWorkManager manager] GETRequest:@{} pageUrl:[NSString stringWithFormat:@"%@/%@",Page_ListenDetail,listenid] complete:^(id result) {
        [self dismissLoadingView];
        NSDictionary * dic = (NSDictionary *)result;
        self.listenModel = [[HomeListenModel alloc]initWithDictionary:dic];
        [self.header updateWithImage:self.listenModel.thumb];
        [self.tabview reloadData];
        [self hiddenNullView];
    } errorBlock:^(KTError *error) {
        [self dismissLoadingView];
        [self showNullViewWithNullViewType:NullTypeNetError];
    }];
    
    [[NetWorkManager manager] GETRequest:@{} pageUrl:Page_ShopCarCount complete:^(id result) {
        NSString * count = [NSString stringWithFormat:@"%@",result];
        self.countLabel.text = count;
        self.countLabel.hidden = [self.countLabel.text intValue] > 0 ? NO : YES;
    } errorBlock:^(KTError *error) {
        
    }];
    
}
#pragma mark - 点赞
- (void)likeThisBookClick:(UIButton *)btn{
    if (![UserManager manager].isLogin) {
        LoginViewController * vc = [LoginViewController new];
        UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nvc animated:YES completion:nil];
    }else{
        //真尼玛傻逼啊  点赞还用两个接口
        NSDictionary * params = @{
                                  //关联1.头条、2.听书、3.声度、0.音频(音频不是栏目所以为0)
                                  @"relationType":@2,
                                  @"relationId":self.listenID,
                                  @"nickName":[UserManager manager].info.NICKNAME
                                  };
        NSString * pageUrl = Page_AddLike;
        if (btn.selected) {
            pageUrl = Page_DelLike;
        }
        [self showLoadingCantClear:YES];
        [[NetWorkManager manager] POSTRequest:params pageUrl:pageUrl complete:^(id result) {
            [self dismissLoadingView];
            int num = [self.listenModel.praseNum intValue];
            if (btn.selected) {
                num -= 1;
            }else{
                num += 1;
            }
            self.listenModel.praseNum = @(num);
            [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:btn.selected ? @"取消成功":@"点赞成功" duration:1.0f];
            [btn setTitle:[NSString stringWithFormat:@"  %@",self.listenModel.praseNum] forState:UIControlStateNormal];
            btn.selected = !btn.selected;
        } errorBlock:^(KTError *error) {
            [self dismissLoadingView];
        }];
    }
}
#pragma mark - 详情购物车按钮点击
- (void)addThisBookShopCar:(UIButton *)btn{
    //已购买
    if ([btn.titleLabel.text containsString:@"下载"]) {
        if (!self.listenModel.isDownLoad) {//下载该书籍
#warning 这里需要判断网络状态
            [[AudioDownLoader loader] downLoadAudioWithHomeTopModel:@[self.listenModel.audioModel]];
            
        }else{
            [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"本地音频，无需下载" duration:1.0f];
        }
    }else if ([btn.titleLabel.text containsString:@"购物车"]) {//添加至购物车
        if (![UserManager manager].isLogin) {
            LoginViewController * vc = [LoginViewController new];
            UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:vc];
            [self presentViewController:nvc animated:YES completion:nil];
        }else{
            if (!self.listenModel.iscart) {
                NSDictionary * params = @{
                                          @"userId":[UserManager manager].userid,
                                          @"relationId":self.listenID,
                                          @"relationType":@2
                                          };
                [[NetWorkManager manager] POSTRequest:params pageUrl:Page_AddCar complete:^(id result) {
                    [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"添加成功" duration:1.0f];
                    [btn setImage:[UIImage imageNamed:@"Listen-Shoped"] forState:UIControlStateNormal];
                    int count = [self.countLabel.text intValue] + 1;
                    self.listenModel.iscart = YES;
                    self.countLabel.text = [NSString stringWithFormat:@"%d",count];
                    self.countLabel.hidden = [self.countLabel.text intValue] > 0 ? NO : YES;
                } errorBlock:^(KTError *error) {
                    
                }];
            }else{
                [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"商品已加入购物车" duration:1.0f];
            }
        }
    }
}
#pragma mark - 购买
- (void)buyThisBookRequest:(UIButton *)btn{
    if (btn.selected) {
        //进入播放器
        [[AVQueenManager Manager] playAudios:@[self.listenModel.audioModel]];
        [self reloadTabviewFrame];
    }else{
        if (![UserManager manager].isLogin) {
            LoginViewController * vc = [LoginViewController new];
            UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:vc];
            [self presentViewController:nvc animated:YES completion:nil];
        }else{
            //购买
            SetAccoutViewController * vc = [[SetAccoutViewController alloc]init];
            vc.isBook = YES;
            vc.money = self.listenModel.PRICE;
            vc.products = @[self.listenModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
#pragma mark - 下载完成
- (void)audioDownLoadOver{
    [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"音频下载完成" duration:1.0f];
    self.listenModel.isDownLoad = YES;
    [self.shopBtn setImage:[UIImage imageNamed:@"listen_downed"] forState:UIControlStateNormal];
    [self.shopBtn setTitle:@"下载" forState:UIControlStateNormal];
}
#pragma mark - 下载进度
- (void)showProgress:(NSString *)progress{
    [self.shopBtn setTitle:[NSString stringWithFormat:@"  %@",progress] forState:UIControlStateNormal];
}



@end
