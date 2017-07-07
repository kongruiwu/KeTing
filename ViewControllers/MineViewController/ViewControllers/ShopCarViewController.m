//
//  ShopCarViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/30.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "ShopCarViewController.h"
#import "ShopCarListCell.h"
#import "ShopCarFooter.h"
#import "HomeListenModel.h"
#import "ShopCarHander.h"
@interface ShopCarViewController ()<UITableViewDelegate,UITableViewDataSource,ShopCarDelegate>

@property (nonatomic, strong)UITableView *tabview;
@property (nonatomic, strong) ShopCarFooter * footer;
@property (nonatomic, strong) ShopCarHander * hander;

@end

@implementation ShopCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavUnAlpha];
    [self drawBackButtonWithType:BackImgTypeBlack];
    [self setNavTitle:@"购物车" color:KTColor_MainBlack];
    [self creatUI];
    [self getData];
}
- (void)creatUI{
    self.hander = [ShopCarHander hander];
    self.tabview = [KTFactory creatTabviewWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT - 64 - Anno750(98)) style:UITableViewStyleGrouped];
    self.tabview.backgroundColor = [UIColor whiteColor];
    self.tabview.delegate =self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
    self.footer = [[ShopCarFooter alloc]initWithFrame:CGRectMake(0,0,0,0)];
    [self.footer.selectBtn addTarget:self action:@selector(ShopCarSelectAll:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.footer];
    [self.footer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.height.equalTo(@(Anno750(98)));
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.hander.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Anno750(190);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Anno750(30);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [KTFactory creatViewWithColor:KTColor_BackGround];
    view.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(30));
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellid = @"ShopCarListCell";
    ShopCarListCell * cell = [[ShopCarListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    if (!cell) {
        cell = [[ShopCarListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    [cell updateWithHomeListenModel:self.hander.dataArray[indexPath.row]];
    cell.delegate = self;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)getData{
    [self.hander.dataArray removeAllObjects];
    NSDictionary * params = @{
                              @"userId":[UserManager manager].userid
                              };
    [[NetWorkManager manager] GETRequest:params pageUrl:Page_ShopCar complete:^(id result) {
        [self hiddenNullView];
        NSArray * arr = (NSArray *)result;
        for (int i = 0; i<arr.count; i++) {
            HomeListenModel * model = [[HomeListenModel alloc]initWithDictionary:arr[i]];
            model.isSelect = NO;
            [self.hander.dataArray addObject:model];
        }
        [self.tabview reloadData];
        if (arr.count == 0) {
            [self showNullViewWithNullViewType:NullTypeNoneShopCar];
        }
    } errorBlock:^(KTError *error) {
        
    }];
}

#pragma mark -购物车全选
- (void)ShopCarSelectAll:(UIButton *)btn{
    btn.selected = !btn.selected;
    [self.hander selectAllShopCarGoods:btn.selected];
    [self.footer updateWithShopCarHnader:self.hander];
    [self.tabview reloadData];
}
#pragma mark -选择物品
- (void)selectBook:(UIButton *)btn{
    UITableViewCell * cell = (UITableViewCell *)[btn superview];
    NSIndexPath * indexPath = [self.tabview indexPathForCell:cell];
    [self.hander selectAtIndex:indexPath.row];
    [self.footer updateWithShopCarHnader:self.hander];
    [self.tabview reloadData];
}
@end
