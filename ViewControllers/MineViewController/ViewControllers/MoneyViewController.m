//
//  MoneyViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/29.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "MoneyViewController.h"
#import "MoneyHeaderCell.h"
#import "MoneyCountCell.h"
#import "MoneyDescCell.h"
#import "TopUpListViewController.h"
#import "AcountModel.h"
#import "RMIAPHelper.h"
#import "OrderModel.h"
#import "RootViewController.h"

#define iap6    @"keting006"     //商品的标识
#define iap30   @"keting0030"
#define iap108  @"keting00108"
#define iap208  @"keting00208"
#define iap298  @"keting00298"
#define iap518  @"keting00518"


@interface MoneyViewController ()<UITableViewDelegate,UITableViewDataSource,RMIAPHelperDelegate,SendPriceDelegate>

@property (nonatomic, strong) AcountModel * acountModel;

@property (nonatomic, assign) NSInteger numId;         //商品价格标号

@end

@implementation MoneyViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData];
    [self setNavUnAlpha];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawBackButtonWithType:BackImgTypeBlack];
    [self setNavTitle:@"我的钱包" color:KTColor_MainBlack];
    self.numId = 1;
    [self creatUI];
    [self drawRightButton];
}
- (void)creatUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tabview = [KTFactory creatTabviewWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT - 64) style:UITableViewStylePlain];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
    
}

- (void)drawRightButton{
    UIBarButtonItem * rightBaritem = [[UIBarButtonItem alloc]initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(checkList)];
    self.navigationItem.rightBarButtonItem = rightBaritem;
    [self.navigationItem.rightBarButtonItem setTintColor:KTColor_darkGray];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:font750(28)],NSFontAttributeName, nil] forState:UIControlStateNormal];
}
- (void)checkList{
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * topUp = [UIAlertAction actionWithTitle:@"充值记录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TopUpListViewController * vc = [TopUpListViewController new];
        vc.isTopUp = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    UIAlertAction * takeup = [UIAlertAction actionWithTitle:@"消费记录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TopUpListViewController * vc = [TopUpListViewController new];
        vc.isTopUp = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    UIAlertAction * cannce = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:topUp];
    [alert addAction:takeup];
    [alert addAction:cannce];
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return section == 0 ? Anno750(148) : 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footer = [KTFactory creatViewWithColor:[UIColor clearColor]];
    footer.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(148));
    
    UIButton * payButton = [KTFactory creatButtonWithTitle:@"确认支付"
                                           backGroundColor:[UIColor clearColor]
                                                 textColor:KTColor_MainOrange
                                                  textSize:font750(32)];
    payButton.layer.borderColor = KTColor_MainOrange.CGColor;
    payButton.layer.borderWidth = 1.0f;
    payButton.layer.cornerRadius = Anno750(8);
    [payButton addTarget:self action:@selector(recharge) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:payButton];
    [payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(Anno750(88)));
        make.bottom.equalTo(@(-Anno750(20)));
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(Anno750(-24)));
    }];
    
    return footer;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? 2: 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return indexPath.row == 0 ? Anno750(360): Anno750(300);
    }
    return Anno750(200);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            static NSString * cellid = @"moneyHeader";
            MoneyHeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[MoneyHeaderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }
            [cell updateWithMoneyNumber:[NSString stringWithFormat:@"%.2f",[self.acountModel.accountBalance floatValue]]];
            return cell;
        }else if(indexPath.row == 1){
            static NSString * cellid = @"MoneyCountCell";
            MoneyCountCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[MoneyCountCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }
            cell.delegate = self;
            [cell updateWithAmouts:[UserManager manager].dataModel.amount];
            return cell;
        }
    }else{
        static NSString * cellid = @"MoneyDescCell";
        MoneyDescCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[MoneyDescCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        return cell;
    }
    return nil;
}
- (void)getData{
    NSDictionary * params = @{};
    if (!self.progressView) {
        [self showLoadingCantTouchAndClear];
    }
    [[NetWorkManager manager] GETRequest:params pageUrl:Page_UserAccount complete:^(id result) {
        [self dismissLoadingView];
        NSDictionary * dic = result[@"list"];
        self.acountModel = [[AcountModel alloc]initWithDictionary:dic];
        [self.tabview reloadData];
        if (self.isBuy) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } errorBlock:^(KTError *error) {
        [self dismissLoadingView];
    }];
}

#pragma mark - SendPriceDelegate   --传商品值过来
- (void)sendPrice:(NSInteger)price {
    self.numId = price;
}


#pragma makr- 立即充值    按钮点击事件
- (void)recharge{
    RootViewController * root = (RootViewController *)self.tabBarController;
    __weak MoneyViewController * weakself = self;
    root.deviceclick = ^{
        [weakself userTopUpMoney];
    };
    if ([UserManager manager].isLogin) {
        [self userTopUpMoney];
    }else{
        [root.loginView show];
    }
}
- (void)userTopUpMoney{
    [self showLoadingCantTouchAndClear];
    RMIAPHelper *storeShared = [RMIAPHelper sharedInstance];
    storeShared.delegate = self;
    [storeShared setup];  //开始交易监听
    
    switch (self.numId) {
        case 1:
            [storeShared buy:iap6];
            break;
        case 2:
            [storeShared buy:iap30];
            break;
        case 3:
            [storeShared buy:iap108];
            break;
        case 4:
            [storeShared buy:iap208];
            break;
        case 5:
            [storeShared buy:iap298];
            break;
        case 6:
            [storeShared buy:iap518];
            break;
        default:
            break;
    }
}

#pragma mark - 充值请求失败
- (void)paymentRequestFaild{
    [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"交易请求失败" duration:1.0f];
    [self dismissLoadingView];
}


#pragma mark - RMIAPHelperdelegate
-(void)requestProduct:(RMIAPHelper*)sender start:(SKProductsRequest*)request{
    
    //    NSLog(@"start---------1发送交易请求------------");
    //    [SVProgressHUD showWithStatus:@"发送交易请求,获取产品信息" maskType:SVProgressHUDMaskTypeBlack];
    
}
-(void)requestProduct:(RMIAPHelper*)sender received:(SKProductsRequest*)request{
    //    NSLog(@"received----------2收到响应-------------");
}

- (void)paymentRequest:(RMIAPHelper*)sender start:(SKPayment*)payment{
    //    NSLog(@"startpayment----------3发送支付请求--------");
    //    [SVProgressHUD dismiss];
    
}

- (void)paymentRequest:(RMIAPHelper*)sender purchased:(SKPaymentTransaction*)transaction money:(NSString *)rechargeMoney {
    
    NSString * transactionID     = transaction.transactionIdentifier;
    NSString * paymentTime       = [self stringFromDate:transaction.transactionDate];
    
    if (rechargeMoney != nil) {
        [self verifyPruchase:transactionID time:paymentTime money:rechargeMoney];
    }
    [[RMIAPHelper sharedInstance] finishWithWithTransation:transaction];
}

- (void)paymentRequest:(RMIAPHelper*)sender restored:(SKPaymentTransaction*)transaction {
    [[RMIAPHelper sharedInstance] restore];
}

- (void)paymentRequest:(RMIAPHelper*)sender failed:(SKPaymentTransaction*)transaction {
    [[RMIAPHelper sharedInstance] finishWithWithTransation:transaction];
    [self dismissLoadingView];
}

//恢复
-(BOOL)restoredArray:(RMIAPHelper*)sender withArray:(NSArray*)productsIdArray{
    return YES;
}
//不支持内购
-(void)iapNotSupported:(RMIAPHelper*)sender{
    
}


#pragma mark 验证购买凭据
- (void)verifyPruchase:(NSString *)transactionID time:(NSString *)paymentTime money:(NSString *)rechargeMoney {
    // 验证凭据，获取到苹果返回的交易凭据
    // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
    NSURL *receiptURL   = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    NSURL *url = [NSURL URLWithString:BUY_VIRIFY_RECEIPT_URL];
    // 国内访问苹果服务器比较慢，timeoutInterval需要长一点
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0f];
    request.HTTPMethod = @"POST";
    
    // 在网络中传输数据，大多情况下是传输的字符串而不是二进制数据
    // 传输的是BASE64编码的字符串
    /**
     BASE64 常用的编码方案，通常用于数据传输，以及加密算法的基础算法，传输过程中能够保证数据传输的稳定性
     BASE64是可以编码和解码的
     */
    NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    NSString *payload = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", encodeStr];
    NSData *payloadData = [payload dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody = payloadData;
    
    // 提交验证请求，并获得官方的验证JSON结果
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    // 官方验证结果为空
    if (result == nil) {
        [self dismissLoadingView];
        [ToastView presentToastWithin:[UIApplication sharedApplication].keyWindow withIcon:APToastIconNone text:@"苹果验证失败" duration:1.5];
    } else {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        NSNumber* status = [dict objectForKey:@"status"];
        NSInteger myStatus = [status integerValue];
        if (myStatus == 0) {
            //验证成功通知合肥后台充值
            [self createPayOrders:transactionID time:paymentTime money:rechargeMoney];
        } else {
            [self dismissLoadingView];
            [ToastView presentToastWithin:[UIApplication sharedApplication].keyWindow withIcon:APToastIconNone text:@"苹果验证失败" duration:1.5];
        }
    }
}
#pragma mark - 创建支付订单
- (void)createPayOrders:(NSString *)transactionID time:(NSString *)paymentTime money:(NSString *)rechargeMoney {
    NSDictionary * params = @{@"userId":[UserManager manager].userid,
                              @"nickName":[UserManager manager].info.NICKNAME,
                              @"phone":[UserManager manager].isLogin ? [UserManager manager].info.MOBILE : @"13000000000",
                              @"orderType":@0,
                              @"payAmount":rechargeMoney,
                              @"payMethod":@1,
                              @"goodList":@"",
                              @"actFrom":@0
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
                [ToastView presentToastWithin:self.view.window withIcon:APToastIconNone text:@"充值成功" duration:1.0f];
                [self getData];
            }else{
                [self dismissLoadingView];
                [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"支付失败" duration:1.0f];
            }
            
        } errorBlock:^(KTError *error) {
            [self dismissLoadingView];
            [ToastView presentToastWithin:self.view.window withIcon:APToastIconNone text:error.message duration:1.0f];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } errorBlock:^(KTError *error) {
        [self dismissLoadingView];
        [ToastView presentToastWithin:self.view.window withIcon:APToastIconNone text:error.message duration:1.0f];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    
}


#pragma mark - 处理交易时间
- (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}

@end
