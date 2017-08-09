//
//  MyShopedViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/30.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "MyShopedViewController.h"
#import "MyShopedCollectionCell.h"
#import "HomeListenModel.h"
#import "ListenDetailViewController.h"
@interface MyShopedViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView * collectView;
@property (nonatomic, assign) int page;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic) BOOL hasReduce;

@end

@implementation MyShopedViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([AudioPlayer instance].showFoot && _hasReduce) {
        _hasReduce = YES;
        CGRect frame = self.collectView.frame;
        self.collectView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height -([AudioPlayer instance].showFoot ? Anno750(100) : 0));
    }
    [self checkNetStatus];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavUnAlpha];
    [self drawBackButtonWithType:BackImgTypeBlack];
    [self setNavTitle:@"已购" color:KTColor_MainBlack];
    [self creatUI];
    self.page = 1;
    [self getData];
}
- (void)creatUI{
    self.dataArray = [NSMutableArray new];
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(Anno750(185), Anno750(300));
    layout.sectionInset = UIEdgeInsetsMake(Anno750(30), Anno750(30), Anno750(30), Anno750(30));
    layout.minimumLineSpacing = Anno750(50);
    layout.minimumInteritemSpacing = Anno750(30);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT - 64 ) collectionViewLayout:layout];
    [self.collectView registerClass:[MyShopedCollectionCell class] forCellWithReuseIdentifier:@"MyShopedCollectionCell"];
    self.collectView.delegate = self;
    self.collectView.dataSource = self;
    self.collectView.showsHorizontalScrollIndicator = NO;
    self.collectView.showsVerticalScrollIndicator = NO;
    self.collectView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectView];
    
    self.refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
    self.collectView.mj_header = self.refreshHeader;
    self.collectView.mj_footer = self.refreshFooter;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MyShopedCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyShopedCollectionCell" forIndexPath:indexPath];
    [cell updateWithHomeListenModel:self.dataArray[indexPath.row]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ListenDetailViewController * vc = [[ListenDetailViewController alloc]init];
    HomeListenModel * model = self.dataArray[indexPath.row];
    vc.listenID = model.listenId;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)refreshData{
    self.page = 1;
    [self.dataArray removeAllObjects];
    [self getData];
}
- (void)getMoreData{
    self.page += 1;
    [self getData];
}

- (void)getData{
    [self showLoadingCantTouchAndClear];
    NSDictionary * params = @{
                              @"page":@(self.page),
                              @"pagesize":@"9"
                              };
    
    [[NetWorkManager manager] GETRequest:params pageUrl:Page_Buys complete:^(id result) {
        [self dismissLoadingView];
        NSArray * datas = (NSArray *)result;
        if (self.dataArray.count != 0 && datas.count< 9) {
            if (datas.count == 0) {
                self.page -= 1;
            }
            [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"没有更多了" duration:1.0f];
        }
        for (int i = 0; i<datas.count; i++) {
            HomeListenModel * model = [[HomeListenModel alloc]initWithDictionary:datas[i]];
            [self.dataArray addObject:model];
        }
        
        [self.collectView reloadData];
        [self.refreshHeader endRefreshing];
        if (datas.count<9) {
            [self.refreshFooter endRefreshingWithNoMoreData];
        }else{
            [self.refreshFooter endRefreshing];
        }
        if (self.dataArray.count == 0 && datas.count == 0) {
            [self showNullViewWithNullViewType:NullTypeNoneAudio];
        }
    } errorBlock:^(KTError *error) {
        [self dismissLoadingView];
        if (self.page > 1) {
            self.page -= 1;
        }
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:error.message duration:1.0f];
    }];
    
}

@end
