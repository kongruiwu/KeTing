//
//  DownLoadSubViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/3.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "DownLoadSubViewController.h"
#import "DownLoadListCell.h"
#import "HomeTopModel.h"
#import "SqlManager.h"
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
- (void)getData{
    NSMutableArray * muarr = [[SqlManager manager] getAllDownLoaderStatus];
    self.dataArray = [NSMutableArray arrayWithArray:muarr];
    [self.tabview reloadData];
    if (self.dataArray.count == 0) {
        [self showNullViewWithNullViewType:NullTypeNoneDown];
    }else{
        [self hiddenNullView];
    }
}
- (void)creatUI{
    self.tabview = [KTFactory creatTabviewWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT  - 64) style:UITableViewStyleGrouped];
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
    return Anno750(110);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * header = [KTFactory creatViewWithColor:[UIColor whiteColor]];
    header.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(110));
    UIView * view = [KTFactory creatViewWithColor:KTColor_BackGround];
    view.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(30));
    [header addSubview:view];
    
    UILabel * label = [KTFactory creatLabelWithText:[NSString stringWithFormat:@"共%ld条",self.dataArray.count]
                                          fontValue:font750(26)
                                          textColor:KTColor_MainBlack
                                      textAlignment:NSTextAlignmentLeft];
    UIButton * selectButton = [KTFactory creatButtonWithTitle:@"批量管理"
                                              backGroundColor:[UIColor clearColor]
                                                    textColor:KTColor_darkGray
                                                     textSize:font750(26)];
    UIView * line = [KTFactory creatLineView];
    [header addSubview:label];
    [header addSubview:selectButton];
    [header addSubview:line];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.centerY.equalTo(@(Anno750(15)));
    }];
    [selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Anno750(24)));
        make.centerY.equalTo(label.mas_centerY);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(-Anno750(24)));
        make.height.equalTo(@0.5);
        make.bottom.equalTo(@0);
    }];
    
    return header;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellid = @"DownLoadListCell";
    DownLoadListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[DownLoadListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    [cell updateWithHistoryModel:self.dataArray[indexPath.row] pausStatus:NO];
    return cell;
}
@end
