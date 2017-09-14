//
//  CateListViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/9.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "CateListViewController.h"
#import "CateListTableViewCell.h"
#import "TopTagModel.h"
#import "CateDetailViewController.h"
@interface CateListViewController ()<UITableViewDelegate, UITableViewDataSource>

//@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) NSMutableArray * dataArray;
@end

@implementation CateListViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawBackButtonWithType:BackImgTypeBlack];
    [self setNavTitle:@"财经头条" color:KTColor_MainBlack];
    [self creatUI];
    [self getData];
    [self checkNetStatus];
}
- (void)creatUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataArray = [NSMutableArray new];
    
    self.tabview = [KTFactory creatTabviewWithFrame:CGRectMake(0, 64, UI_WIDTH, UI_HEGIHT - 64) style:UITableViewStyleGrouped];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
    
    UILabel * headLabel = [KTFactory creatLabelWithText:@"分类"
                                              fontValue:font750(30)
                                              textColor:KTColor_MainBlack
                                          textAlignment:NSTextAlignmentCenter];
    headLabel.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(88));
    headLabel.backgroundColor = KTColor_BackGround;
    self.tabview.tableHeaderView = headLabel;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Anno750(70);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Anno750(76);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headView = [KTFactory creatViewWithColor:[UIColor whiteColor]];
    headView.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(76));
    UILabel * label = [KTFactory creatLabelWithText:@"全部"
                                          fontValue:font750(28)
                                          textColor:KTColor_MainBlack
                                      textAlignment:NSTextAlignmentLeft];
    [headView addSubview:label];
    UIView * bottomLine = [KTFactory creatLineView];
    [headView addSubview:bottomLine];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.centerY.equalTo(@0);
    }];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(-Anno750(24)));
        make.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    return headView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellid = @"cateList";
    CateListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell ) {
        cell = [[CateListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    [cell updateWithModel:self.dataArray[indexPath.row]];
    return cell;
}
- (void)getData{
    [self showLoadingCantTouchAndClear];
    [[NetWorkManager manager] GETRequest:@{} pageUrl:Page_TopTags complete:^(id result) {
        [self dismissLoadingView];
        NSArray * datas = (NSArray *)result;
        for (int i = 0; i<datas.count; i++) {
            TopTagModel * model = [[TopTagModel alloc]initWithDictionary:datas[i]];
            model.hasSelect = NO;
            [self.dataArray addObject:model];
        }
        [self hiddenNullView];
        [self.tabview reloadData];
    } errorBlock:^(KTError *error) {
        [self dismissLoadingView];
        [self showNullViewWithNullViewType:NullTypeNetError];
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    for (int i= 0; i<self.dataArray.count; i++) {
        TopTagModel * model = self.dataArray[i];
        if (i == indexPath.row) {
            model.hasSelect = YES;
        }else{
            model.hasSelect = NO;
        }
    }
    TopTagModel * model = self.dataArray[indexPath.row];
    CateDetailViewController * vc = [[CateDetailViewController alloc]initWithTagid:model.tagId tagName:[NSString stringWithFormat:@"#%@  (%@)",model.tagName,model.useCount]];
    [self.navigationController pushViewController:vc animated:YES];
    [self.tabview reloadData];;
}


@end
