//
//  ListenDetailViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/13.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "ListenDetailViewController.h"
#import "VoiceDetailHeader.h"
#import "ShareView.h"
#import "VoiceSummaryCell.h"
#import "VoiceUpdateListCell.h"
#import "ListenAnchorCell.h"
#import "AnchorDetailViewController.h"
#import "ShopCarViewController.h"
#import "AudioPlayerViewController.h"
#import "SetAccoutViewController.h"
#import "LoginViewController.h"
@interface ListenDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

//@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) ShareView * shareView;
@property (nonatomic, strong) VoiceDetailHeader * header;
@property (nonatomic, strong) HomeListenModel * listenModel;

@property (nonatomic, strong) UIButton * likeBtn;
@property (nonatomic, strong) UIButton * shopBtn;
@property (nonatomic, strong) UIButton * buyBtn;

@end

@implementation ListenDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIView * clearView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, 20)];
    [self.view addSubview:clearView];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)creatUI{
    self.tabview = [KTFactory creatTabviewWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT  ) style:UITableViewStylePlain];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
    
    self.header  = [[VoiceDetailHeader alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, Anno750(485))];
    self.header.shopCar.hidden = NO;
    [self.header.backBtn addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    [self.header.shareBtn addTarget:self action:@selector(showShareView) forControlEvents:UIControlEventTouchUpInside];
    [self.header.shopCar addTarget:self action:@selector(goShopCar) forControlEvents:UIControlEventTouchUpInside];
    self.tabview.tableHeaderView = self.header;
    
    self.shareView = [[ShareView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT) hasNav:NO];
    [self.view addSubview:self.shareView];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView * headView = [KTFactory creatViewWithColor:[UIColor whiteColor]];
    headView.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(120));
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
        make.centerY.equalTo(@10);
        make.width.equalTo(@(Anno750(170)));
        make.height.equalTo(@(Anno750(68)));
    }];
    [shopCar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(likeBtn.mas_right).offset(Anno750(30));
        make.width.equalTo(@(Anno750(170)));
        make.height.equalTo(@(Anno750(68)));
        make.centerY.equalTo(@10);
    }];
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Anno750(24)));
        make.centerY.equalTo(@10);
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
    return Anno750(120);
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
    [self.shareView show];
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
    NSString * listenid ;
    if (self.listenModel) {
        listenid = self.listenModel.listenId;
    }else{
        listenid = self.listenID;
    }
    [[NetWorkManager manager] GETRequest:@{} pageUrl:[NSString stringWithFormat:@"%@/%@",Page_ListenDetail,listenid] complete:^(id result) {
        NSDictionary * dic = (NSDictionary *)result;
        self.listenModel = [[HomeListenModel alloc]initWithDictionary:dic];
        [self.header updateWithImage:self.listenModel.thumb title:self.listenModel.name];
        [self.tabview reloadData];
    } errorBlock:^(KTError *error) {
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:error.message duration:2.0f];
    }];
    
    [[NetWorkManager manager] GETRequest:@{} pageUrl:Page_ShopCarCount complete:^(id result) {
        NSString * count = [NSString stringWithFormat:@"%@",result];
        [self.header updateShopCarCount:count];
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
        [[NetWorkManager manager] POSTRequest:params pageUrl:pageUrl complete:^(id result) {
            
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
            
        }];
    }
}
#pragma mark - 详情购物车按钮点击
- (void)addThisBookShopCar:(UIButton *)btn{
    if (![UserManager manager].isLogin) {
        LoginViewController * vc = [LoginViewController new];
        UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nvc animated:YES completion:nil];
    }else{
        //已购买
        if (self.listenModel.Isbuy) {
            if (!self.listenModel.isDownLoad) {//下载该书籍
                
            }
        }else{
            if (!self.listenModel.iscart) {//添加至购物车
                NSDictionary * params = @{
                                          @"userId":[UserManager manager].userid,
                                          @"relationId":self.listenID,
                                          @"relationType":@2
                                          };
                [[NetWorkManager manager] POSTRequest:params pageUrl:Page_AddCar complete:^(id result) {
                    [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"添加成功" duration:1.0f];
                    [btn setImage:[UIImage imageNamed:@"Listen-Shoped"] forState:UIControlStateNormal];
                    int count = [self.header.countLabel.text intValue] + 1;
                    [self.header updateShopCarCount:[NSString stringWithFormat:@"%d",count]];
                } errorBlock:^(KTError *error) {
                    
                }];
            }
        }
    }
}
#pragma mark - 购买
- (void)buyThisBookRequest:(UIButton *)btn{
    if (![UserManager manager].isLogin) {
        LoginViewController * vc = [LoginViewController new];
        UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nvc animated:YES completion:nil];
    }else{
        if (btn.selected) {
            //进入播放器
            [AudioPlayer instance].currentAudio = self.listenModel.audioModel;
            [AudioPlayer instance].playList = [NSMutableArray arrayWithObject:self.listenModel.audioModel];
            AudioPlayerViewController * audioVC = [AudioPlayerViewController new];
            UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:audioVC];
            [self presentViewController:nav animated:YES completion:nil];
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


//设置头部拉伸效果
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //图片高度
    CGFloat imageHeight = self.header.frame.size.height;
    //图片宽度
    CGFloat imageWidth = UI_WIDTH;
    //图片上下偏移量
    CGFloat imageOffsetY = scrollView.contentOffset.y;
    //上移
    if (imageOffsetY < 0) {
        CGFloat totalOffset = imageHeight + ABS(imageOffsetY);
        CGFloat f = totalOffset / imageHeight;
        
        self.header.groundImg.frame = CGRectMake(-(imageWidth * f - imageWidth) * 0.5, imageOffsetY, imageWidth * f, totalOffset);
    }
    
}


@end
