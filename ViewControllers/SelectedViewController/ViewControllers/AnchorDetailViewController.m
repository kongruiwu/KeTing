//
//  AnchorDetailViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/13.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "AnchorDetailViewController.h"
#import "ListenListCell.h"
#import "AnchorHeader.h"
#import "AnchorModel.h"
#import "ShareView.h"
@interface AnchorDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView * tabview;
@property (nonatomic, strong) AnchorHeader * anchorHeader;
@property (nonatomic, strong) AnchorModel * anchor;
@property (nonatomic, strong) ShareView * shareView;
@property (nonatomic) int page;
@end

@implementation AnchorDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self getData];
    
}
- (void)creatUI{
    self.page = 1;
    self.tabview = [KTFactory creatTabviewWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT ) style:UITableViewStylePlain];
    self.tabview.delegate =self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
    
    self.shareView = [[ShareView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT) hasNav:NO];
    [self.view addSubview:self.shareView];
    
    self.anchorHeader = [[AnchorHeader alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, Anno750(440))];
    [self.anchorHeader.backBtn addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    [self.anchorHeader.shareBtn addTarget:self action:@selector(showShareView) forControlEvents:UIControlEventTouchUpInside];
    
    self.tabview.tableHeaderView = self.anchorHeader;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.anchor.listenVolice.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Anno750(250);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Anno750(75);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [KTFactory creatViewWithColor:KTColor_BackGround];
    view.frame = CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT);
    UILabel * label = [KTFactory creatLabelWithText:[NSString stringWithFormat:@"%@的音频(%ld)",self.anchor.name,self.anchor.listenVolice.count]
                                          fontValue:font750(30)
                                          textColor:KTColor_lightGray
                                      textAlignment:NSTextAlignmentLeft];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.centerY.equalTo(@0);
    }];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellid = @"ListenListCell";
    ListenListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell ) {
        cell = [[ListenListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    [cell updateWithListenModel:self.anchor.listenVolice[indexPath.row]];
    return cell;
}
- (void)getData{
//    NSDictionary * params = @{
//                              @"page":@(self.page),
//                              @"pagesize":@3
//                              };
    ///page/1/pagesize/3
    [[NetWorkManager manager] GETRequest:@{} pageUrl:[NSString stringWithFormat:@"%@/%@",Page_AnchorDetail,self.anchorID] complete:^(id result) {
        NSDictionary * dic = (NSDictionary *)result;
        self.anchor = [[AnchorModel alloc]initWithDictionary:dic];
        [self.anchorHeader updateWithAnchorModel:self.anchor];
        [self.tabview reloadData];
    } errorBlock:^(KTError *error) {
        
    }];
}
- (void)showShareView{
    [self.shareView show];
}
@end
