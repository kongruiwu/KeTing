//
//  DownLoadSubViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/3.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "DownLoadSubViewController.h"
#import "DownLoadListCell.h"
#import "HistoryModel.h"
@interface DownLoadSubViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) NSMutableArray * dataArray;
@end

@implementation DownLoadSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self getData];
}
- (void)creatUI{
    self.dataArray = [NSMutableArray new];
    self.tabview = [KTFactory creatTabviewWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT - Anno750(90) - 64) style:UITableViewStyleGrouped];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Anno750(120);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Anno750(2);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [KTFactory creatViewWithColor:KTColor_BackGround];
    view.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(2));
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellid = @"DownLoadListCell";
    DownLoadListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[DownLoadListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    return cell;
}
- (void)getData{
    
    NSDictionary * params = @{
                              @"userId":[UserManager manager].userid,
                              @"downStatus":@(self.isDownLoading)
                              };
    [[NetWorkManager manager] GETRequest:params pageUrl:Page_DownLoad complete:^(id result) {
        NSArray * arr = (NSArray *)result;
        for (int i = 0; i<arr.count; i++) {
            HistoryModel * model = [[HistoryModel alloc]initWithDictionary:arr[i]];
            [self.dataArray addObject:model];
        }
        [self.tabview reloadData];
    } errorBlock:^(KTError *error) {
        
    }];
    
}
@end
