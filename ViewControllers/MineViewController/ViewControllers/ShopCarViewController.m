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
#import "ListenDetailViewController.h"
#import "SetAccoutViewController.h"
@interface ShopCarViewController ()<UITableViewDelegate,UITableViewDataSource,ShopCarDelegate>

@property (nonatomic, strong) ShopCarFooter * footer;
@property (nonatomic, strong) ShopCarHander * hander;
@property (nonatomic) BOOL isEditStaus;
@property (nonatomic, strong) UIBarButtonItem * barItem;

@end

@implementation ShopCarViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData];
    self.footer.frame = CGRectMake(0,UI_HEGIHT - 64 - Anno750(98) - ([AudioPlayer instance].showFoot ? Anno750(100) : 0),UI_WIDTH,Anno750(98));
    [self checkNetStatus];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavUnAlpha];
    [self drawBackButtonWithType:BackImgTypeBlack];
    [self setNavTitle:@"购物车" color:KTColor_MainBlack];
    [self creatUI];
    [self drawRightDeleteBtn];
}
- (void)creatUI{
    self.hander = [ShopCarHander hander];
    self.tabview = [KTFactory creatTabviewWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT - 64 - Anno750(98)) style:UITableViewStyleGrouped];
    self.tabview.backgroundColor = [UIColor whiteColor];
    self.tabview.delegate =self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
    self.footer = [[ShopCarFooter alloc]initWithFrame:CGRectMake(0,UI_HEGIHT - 64 - Anno750(98)  - ([AudioPlayer instance].showFoot ? Anno750(100) : 0),UI_WIDTH,Anno750(98))];
    [self.footer.selectBtn addTarget:self action:@selector(ShopCarSelectAll:) forControlEvents:UIControlEventTouchUpInside];
    [self.footer.buyBtn addTarget:self action:@selector(buyAllBooks) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.footer];
  
}
- (void)drawRightDeleteBtn{
    UIBarButtonItem * barItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(changeEditStatus:)];
    self.navigationItem.rightBarButtonItem = barItem;
    [self.navigationItem.rightBarButtonItem setTintColor:KTColor_darkGray];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:font750(28)],NSFontAttributeName, nil] forState:UIControlStateNormal];
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
    [cell updateWithHomeListenModel:self.hander.dataArray[indexPath.row] andEditStatus:self.isEditStaus];
    cell.delegate = self;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ListenDetailViewController * vc = [[ListenDetailViewController alloc]init];
    vc.listenID = self.hander.dataArray[indexPath.row].listenId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getData{
    [self showLoadingCantClear:YES];
    [self.hander.dataArray removeAllObjects];
    NSDictionary * params = @{
                              @"userId":[UserManager manager].userid
                              };
    [[NetWorkManager manager] GETRequest:params pageUrl:Page_ShopCar complete:^(id result) {
        [self dismissLoadingView];
        [self hiddenNullView];
        NSArray * arr = (NSArray *)result;
        for (int i = 0; i<arr.count; i++) {
            HomeListenModel * model = [[HomeListenModel alloc]initWithDictionary:arr[i]];
            model.isSelect = NO;
            [self.hander.dataArray addObject:model];
        }
        self.footer.selectBtn.selected = NO;
        [self ShopCarSelectAll:self.footer.selectBtn];
        if (arr.count == 0) {
            [self showNullViewWithNullViewType:NullTypeNoneShopCar];
        }
    } errorBlock:^(KTError *error) {
        [self dismissLoadingView];
    }];
}
- (void)changeEditStatus:(UIBarButtonItem *)baritem{
    
    self.isEditStaus = !self.isEditStaus;
    baritem.title = self.isEditStaus ? @"完成" : @"编辑";
    [self.tabview reloadData];
    if (self.isEditStaus) {
        [self.footer updateDeleteStatusWithShopCarHander:self.hander];
    }else{
        [self.footer updateWithShopCarHnader:self.hander];
    }
    
}

#pragma mark -购物车全选
- (void)ShopCarSelectAll:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (self.isEditStaus) {
        [self.hander selectAllToDelete:btn.selected];
        [self.footer updateDeleteStatusWithShopCarHander:self.hander];
    }else{
        [self.hander selectAllShopCarGoods:btn.selected];
        [self.footer updateWithShopCarHnader:self.hander];
    }
    [self.tabview reloadData];
}
#pragma mark -选择物品
- (void)selectBook:(UIButton *)btn{
    UITableViewCell * cell = (UITableViewCell *)[btn superview];
    NSIndexPath * indexPath = [self.tabview indexPathForCell:cell];
    if (self.isEditStaus) {
        [self.hander selectToDeleteAtIndex:indexPath.row];
        [self.footer updateDeleteStatusWithShopCarHander:self.hander];
    }else{
        [self.hander selectAtIndex:indexPath.row];
        [self.footer updateWithShopCarHnader:self.hander];
    }
    [self.tabview reloadData];
}
#pragma mark - 购买
- (void)buyAllBooks{
    if (self.isEditStaus) {
        UIAlertController * altert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cannnce = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSDictionary * params = @{
                                      @"idStr":[self.hander getDeleteIdStr]
                                      };
            [[NetWorkManager manager] POSTRequest:params pageUrl:Page_ShopCarDelete complete:^(id result) {
                [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"删除陈功" duration:1.0f];
                self.isEditStaus = NO;
                [self.tabview reloadData];
            } errorBlock:^(KTError *error) {
                [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:error.message duration:1.0f];
            }];
        }];
        [altert addAction:sure];
        [altert addAction:cannnce];
        [self presentViewController:altert animated:YES completion:nil];
        
    }else{
        SetAccoutViewController * vc = [[SetAccoutViewController alloc]init];
        vc.isBook = YES;
        vc.isCart = YES;
        vc.money = [NSNumber numberWithFloat:self.hander.money];
        NSMutableArray * muarr = [NSMutableArray new];
        for (int i = 0; i<self.hander.dataArray.count; i++) {
            HomeListenModel * model = self.hander.dataArray[i];
            if (model.isSelect) {
                [muarr addObject:model];
            }
        }
        vc.products = muarr;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
