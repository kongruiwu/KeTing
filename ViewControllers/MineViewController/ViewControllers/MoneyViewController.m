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
@interface MoneyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tabview;

@property (nonatomic, strong) AcountModel * acountModel;

@end

@implementation MoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavUnAlpha];
    [self drawBackButtonWithType:BackImgTypeBlack];
    [self setNavTitle:@"我的钱包" color:KTColor_MainBlack];
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
    [[NetWorkManager manager] GETRequest:params pageUrl:Page_UserAccount complete:^(id result) {
        NSDictionary * dic = result[@"list"];
        self.acountModel = [[AcountModel alloc]initWithDictionary:dic];
        [self.tabview reloadData];
    } errorBlock:^(KTError *error) {
        
    }];
}

@end
