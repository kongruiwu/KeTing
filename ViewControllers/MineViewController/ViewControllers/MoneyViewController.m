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

#define iap6    @"keting6"     //商品的标识
#define iap30   @"keting30"
#define iap68   @"keting68"
#define iap98   @"keting98"
#define iap198  @"keting198"
#define iap298  @"keting298"

#define SANDBOX_VERIFY_RECEIPT_URL  @"https://sandbox.itunes.apple.com/verifyReceipt"  //苹果沙盒验证URL
#define BUY_VIRIFY_RECEIPT_URL      @"https://buy.itunes.apple.com/verifyReceipt"      //AppStore验证URL

@interface MoneyViewController ()<UITableViewDelegate,UITableViewDataSource,RMIAPHelperDelegate,SendPriceDelegate>

//@property (nonatomic, strong) UITableView * tabview;

@property (nonatomic, strong) AcountModel * acountModel;

@property (nonatomic, assign) NSInteger numId;         //商品价格标号

@end

@implementation MoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavUnAlpha];
    [self drawBackButtonWithType:BackImgTypeBlack];
    [self setNavTitle:@"我的钱包" color:KTColor_MainBlack];
    self.numId = 1;
    [self creatUI];
    [self drawRightButton];
    [self getData];
}
- (void)creatUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tabview = [KTFactory creatTabviewWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT - 64) style:UITableViewStylePlain];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
    
    UIView * footer = [KTFactory creatViewWithColor:[UIColor clearColor]];
    footer.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(60 + 88));
    UIButton * buyBtn = [KTFactory creatButtonWithTitle:@"立即充值"
                                        backGroundColor:[UIColor clearColor]
                                              textColor:KTColor_MainOrange
                                               textSize:font750(32)];
    [buyBtn addTarget:self action:@selector(recharge) forControlEvents:UIControlEventTouchUpInside];
    buyBtn.layer.borderColor = KTColor_MainOrange.CGColor;
    buyBtn.layer.borderWidth = 1.0f;
    buyBtn.layer.cornerRadius = 3.0f;
    [footer addSubview:buyBtn];
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.bottom.equalTo(@0);
        make.height.equalTo(@(Anno750(88)));
        make.right.equalTo(@(-Anno750(24)));
    }];
    self.tabview.tableFooterView = footer;
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return Anno750(360);
    }else if(indexPath.row == 1){
        return Anno750(260);
    }else{
        return Anno750(160);
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
    }else{
        static NSString * cellid = @"MoneyDescCell";
        MoneyDescCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[MoneyDescCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        return cell;
    }
}
- (void)getData{
    NSDictionary * params = @{};
    [self showLoadingCantTouchAndClear];
    [[NetWorkManager manager] GETRequest:params pageUrl:Page_UserAccount complete:^(id result) {
        [self dismissLoadingView];
        NSDictionary * dic = result[@"list"];
        self.acountModel = [[AcountModel alloc]initWithDictionary:dic];
        [self.tabview reloadData];
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
             [storeShared buy:iap68];
             break;
         case 4:
             [storeShared buy:iap98];
             break;
         case 5:
             [storeShared buy:iap198];
             break;
         case 6:
             [storeShared buy:iap298];
             break;
         default:
             break;
     }
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
    [self dismissLoadingView];
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
     NSURL *url = [NSURL URLWithString:SANDBOX_VERIFY_RECEIPT_URL];
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
         [ToastView presentToastWithin:[UIApplication sharedApplication].keyWindow withIcon:APToastIconNone text:@"苹果验证失败" duration:1.5];
     } else {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
         NSNumber* status = [dict objectForKey:@"status"];
         NSInteger myStatus = [status integerValue];
         if (myStatus == 0) {
             //通知后台给用户加金币
             
             [ToastView presentToastWithin:[UIApplication sharedApplication].keyWindow withIcon:APToastIconNone text:@"苹果验证成功" duration:2];
             //验证成功通知合肥后台充值
             [self createPayOrders:transactionID time:paymentTime money:rechargeMoney];
         } else {
             [ToastView presentToastWithin:[UIApplication sharedApplication].keyWindow withIcon:APToastIconNone text:@"苹果验证失败" duration:1.5];
         }
     }
}
#pragma mark - 创建支付订单
- (void)createPayOrders:(NSString *)transactionID time:(NSString *)paymentTime money:(NSString *)rechargeMoney {
     NSLog(@"transactionID:%@   paymentTime:%@  rechargeMoney:%@",transactionID,paymentTime,rechargeMoney);
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
