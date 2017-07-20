//
//  SetAccoutViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/18.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "SetAccoutViewController.h"
#import "SetAccountHeadCell.h"
#import "TopUpCell.h"
#import "PayMomentCell.h"
#import "WKWebViewController.h"
#import "SubscriListViewController.h"
#import "HomeListenModel.h"
#import "OrderModel.h"
#import "MyShopedViewController.h"
@interface SetAccoutViewController ()<UITableViewDelegate,UITableViewDataSource>

//@property (nonatomic, strong) UITableView * tabview;

@end

@implementation SetAccoutViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavUnAlpha];
    [self setNavTitle:@"结算台" color:KTColor_MainBlack];
    [self drawBackButtonWithType:BackImgTypeBlack];
    [self creatUI];
    
}

- (void)creatUI{
    self.isBook = NO;
    self.isCart = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabview = [KTFactory creatTabviewWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT - 64) style:UITableViewStyleGrouped];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
    
    UIView * footer = [KTFactory creatViewWithColor:[UIColor whiteColor]];
    footer.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(200));
    
    UIButton * protobtn = [KTFactory creatButtonWithTitle:@"已阅读并同意一下内容《付费阅读服务协议》"
                                          backGroundColor:[UIColor clearColor]
                                                textColor:KTColor_darkGray
                                                 textSize:font750(24)];
    NSMutableAttributedString * attstr = [[NSMutableAttributedString alloc]initWithString:@"已阅读并同意以下内容《付费阅读服务协议》"];
    [attstr addAttribute:NSForegroundColorAttributeName value:KTColor_MainOrange range:NSMakeRange(10, attstr.length - 10)];
    [protobtn setAttributedTitle:attstr forState:UIControlStateNormal];
    [protobtn addTarget:self action:@selector(pushTpprotoViewController) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton * sureBuy = [KTFactory creatButtonWithTitle:@"确认购买"
                                         backGroundColor:[UIColor clearColor]
                                               textColor:KTColor_MainOrange
                                                textSize:font750(30)];
    sureBuy.layer.borderColor = KTColor_MainOrange.CGColor;
    sureBuy.layer.borderWidth = 1.0f;
    sureBuy.layer.cornerRadius = 3.0f;
    [footer addSubview:protobtn];
    [footer addSubview:sureBuy];
    
    [sureBuy addTarget:self action:@selector(sureBuyClick) forControlEvents:UIControlEventTouchUpInside];
    
    [protobtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(Anno750(35)));
        make.centerX.equalTo(@0);
    }];
    [sureBuy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.left.equalTo(@(Anno750(95)));
        make.right.equalTo(@(-Anno750(95)));
        make.height.equalTo(@(Anno750(80)));
    }];
    self.tabview.tableFooterView = footer;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    BOOL rec = [[UserManager manager].balance floatValue] >= self.money.floatValue;
    return section == 0 ? 1:(rec ? 1:2) ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section == 0 ? Anno750(250) : Anno750(110);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? Anno750(35): Anno750(90);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headView = [KTFactory creatViewWithColor:KTColor_BackGround];
    headView.frame = CGRectMake(0, 0, UI_WIDTH, section == 0 ? Anno750(35): Anno750(90));
    if (section != 0) {
        UILabel * label = [KTFactory creatLabelWithText:@"选择支付方式"
                                              fontValue:font750(30)
                                              textColor:KTColor_darkGray
                                          textAlignment:NSTextAlignmentLeft];
        [headView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(Anno750(24)));
            make.centerY.equalTo(@0);
        }];
    }
    return headView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString * cellid = @"SetAccountHeadCell";
        SetAccountHeadCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[SetAccountHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        [cell updateMoneyLabel:[NSString stringWithFormat:@"%.2f",[self.money floatValue]]];
        return cell;
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            static NSString * cellid = @"PayMomentCell";
            PayMomentCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[PayMomentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }
            [cell updateUserBlance];
            return cell;
            
        }else if(indexPath.row == 1){
            static NSString * cellid = @"TopUpCell";
            TopUpCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[TopUpCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }
            return cell;
        }
    }
    return nil;
}
#pragma mark 支付
- (void)sureBuyClick{
    if ([[UserManager manager].balance floatValue] < self.money.floatValue) {
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"账户余额不足，请先充值" duration:1.5f];
        return;
    }
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    for (int i = 0; i<self.products.count; i++) {
        HomeListenModel * model = self.products[i];
        //关联1.头条、2.听书、3.声度、0.音频(音频不是栏目所以为0)
        NSDictionary * dic = @{
                               @"relationType":self.isBook ? @2 : @3,
                               @"relationId" : model.listenId,
                               };
        [arr addObject:dic];
    }
    NSData *data=[NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSDictionary * params = @{@"userId":[UserManager manager].userid,
                              @"nickName":[UserManager manager].info.NICKNAME,
                              @"phone":[UserManager manager].info.MOBILE,
                              @"orderType":@1,
                              @"payAmount":@0,
                              @"payMethod":@2,
                              @"goodList":jsonStr,
                              @"actFrom":self.isCart ? @0 : @1
                              };
    [[NetWorkManager manager] POSTRequest:params pageUrl:Page_Order complete:^(id result) {
        OrderModel * model = [[OrderModel alloc]initWithDictionary:result];
        NSDictionary * orderParams = @{
                                       @"userId":[UserManager manager].userid,
                                       @"orderId":model.orderId,
                                       @"orderNo":model.orderNo,
                                       @"payStatus":@1
                                       };
        [[NetWorkManager manager] POSTRequest:orderParams pageUrl:Page_PayStatus complete:^(id result) {
            NSDictionary * dic = (NSDictionary *)result;
            if ([dic[@"payStatus"] integerValue] == 1) {
                if (self.isBook) {
                    MyShopedViewController * vc = [[MyShopedViewController alloc]init];
                    vc.backType = SelectorBackTypePoptoRoot;
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    SubscriListViewController * vc = [[SubscriListViewController alloc]init];
                    vc.backType = SelectorBackTypePoptoRoot;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }else{
                [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"支付失败" duration:1.0f];
            }
            
        } errorBlock:^(KTError *error) {
            
        }];
    } errorBlock:^(KTError *error) {
    }];
    
    
    
}
- (void)pushTpprotoViewController{
    WKWebViewController * vc = [WKWebViewController new];
    vc.webType = PROTOCOLTYPEBALANCE;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
