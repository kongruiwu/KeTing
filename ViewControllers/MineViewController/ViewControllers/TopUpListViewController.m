//
//  TopUpListViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/30.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "TopUpListViewController.h"
#import "TopUpListCell.h"
#import "TopUpModel.h"
@interface TopUpListViewController ()<UITableViewDelegate,UITableViewDataSource>

//@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation TopUpListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:self.isTopUp ? @"充值记录":@"消费记录" color:KTColor_MainBlack];
    [self drawBackButtonWithType:BackImgTypeBlack];
    [self creatUI];
    [self getData];
    [self checkNetStatus];
}
- (void)creatUI{
    self.tabview = [KTFactory creatTabviewWithFrame:CGRectMake(0, 64, UI_WIDTH, UI_HEGIHT - 64) style:UITableViewStyleGrouped];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Anno750(110);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Anno750(30);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [KTFactory creatViewWithColor:KTColor_BackGround];
    view.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(30));
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellid = @"Topuplistcell";
    TopUpListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[TopUpListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    [cell updateWithModel:self.dataArray[indexPath.row] isTopUp:self.isTopUp];
    return cell;
}

- (void)getData{
    [self showLoadingCantClear:YES];
    self.dataArray = [NSMutableArray new];
    NSString * page = self.isTopUp ? Page_TopUp:Page_TakeUp;
    NSDictionary * params = @{
                              @"userId":[UserManager manager].userid
                              };
    [[NetWorkManager manager] GETRequest:params pageUrl:page complete:^(id result) {
        [self dismissLoadingView];
        NSArray * arr = result[@"list"];
        if (arr.count == 0) {
            [self showNullViewWithNullViewType:NullTypeNoneTopUp];
        }else{
            [self hiddenNullView];
            for (int i = 0; i<arr.count; i++) {
                TopUpModel * model = [[TopUpModel alloc]initWithDictionary:arr[i]];
                [self.dataArray addObject:model];
            }
            [self.tabview reloadData];
        }
        
    } errorBlock:^(KTError *error) {
        [self dismissLoadingView];
        [self showNullViewWithNullViewType:0];
    }];
}

@end
