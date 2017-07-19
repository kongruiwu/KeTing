//
//  WaitDownLoadViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/19.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "WaitDownLoadViewController.h"
#import "TopHeaderView.h"
#import "DownLoadListCell.h"
#import "SqlManager.h"
@interface WaitDownLoadViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) TopHeaderView * header;
@property (nonatomic, strong) NSMutableArray * dataArray;
@end

@implementation WaitDownLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self getData];
}
- (void)getData{
    NSMutableArray * muarr = [[SqlManager manager] getWaitDownLoadingAudios];
    self.dataArray = [NSMutableArray arrayWithArray:muarr];
    NSMutableArray * current = [[SqlManager manager] getDownLoadingAudio];
    if (current.count >0) {
        [self.dataArray addObject:current[0]];
    }
    [self.tabview reloadData];
    if (self.dataArray.count == 0) {
        [self showNullViewWithNullViewType:NullTypeNoneDown];
    }else{
        [self hiddenNullView];
    }
    
}
- (void)creatUI{
    self.header = [[TopHeaderView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, Anno750(90))];
    [self.header updateWithImages:@[@"my_ stop",@"my_ delete"] titles:@[@"    全部暂停",@"    全部清空"]];
    [self.view addSubview:self.header];
    
    self.tabview = [KTFactory creatTabviewWithFrame:CGRectMake(0, Anno750(90), UI_WIDTH, UI_HEGIHT - Anno750(90) - 64 ) style:UITableViewStyleGrouped];
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
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Anno750(30);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellid = @"DownLoadListCell";
    DownLoadListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[DownLoadListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    [cell updateWithHistoryModel:self.dataArray[indexPath.row] pausStatus:YES];
    return cell;
}


@end
