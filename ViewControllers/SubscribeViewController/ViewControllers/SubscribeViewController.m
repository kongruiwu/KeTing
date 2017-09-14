//
//  SubscribeViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/13.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "SubscribeViewController.h"
#import "NoneSubscribeCell.h"
#import "SubscribeListCell.h"
#import "RecommendListCell.h"
#import "SubscribeSectionHeader.h"
#import "HomeListenModel.h"
#import "ListenDetailViewController.h"
#import "VoiceDetailViewController.h"
#import "SubscriListViewController.h"
#import "SubscriListViewController.h"
#import "SelectSectionHeader.h"

@interface SubscribeViewController ()<UITableViewDelegate,UITableViewDataSource,RecommendListDelegate>

//@property (nonatomic, strong)UITableView * tabview;
//推荐数组
@property (nonatomic, strong) NSMutableArray * recomendArray;
//订阅数组
@property (nonatomic, strong) NSMutableArray * listArray;
//没有订阅 显示文字
@property (nonatomic, strong) NSString * NullString;

@end

@implementation SubscribeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self getSubscribeData];
}

- (void)creatUI{
    self.recomendArray = [NSMutableArray new];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"recoendArray"]) {
        NSData * newsData = [[NSUserDefaults standardUserDefaults] objectForKey:@"recoendArray"];
        NSArray * news = [NSJSONSerialization JSONObjectWithData:newsData
                                                         options:NSJSONReadingAllowFragments
                                                           error:nil];
        for (int i = 0; i<news.count; i++) {
            HomeListenModel * model = [[HomeListenModel alloc]initWithDictionary:news[i]];
            [self.recomendArray addObject:model];
        }
    }
    
    self.NullString = @"尚未订阅，看看我们为你推荐的吧";
    self.listArray = [NSMutableArray new];
    self.tabview = [KTFactory creatTabviewWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT - 64) style:UITableViewStyleGrouped];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
    
    UIView * grayView = [KTFactory creatViewWithColor:KTColor_BackGround];
    grayView.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(30));
    self.tabview.tableHeaderView = grayView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.listArray.count == 0 ? 1 : (self.listArray.count<= 3 ? self.listArray.count : 3);
    }
    return self.recomendArray.count%2 == 1?self.recomendArray.count/2+1 : self.recomendArray.count/2;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return self.listArray.count ==0 ? Anno750(336) : Anno750(170);
    }
    return Anno750(520);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 1 ? Anno750(80) : 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return Anno750(100);
        
    }
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        SubscribeSectionHeader * header = [[SubscribeSectionHeader alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, Anno750(80))];
        [header.changeBtn addTarget:self action:@selector(getSubscribeData) forControlEvents:UIControlEventTouchUpInside];
        return header;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView * view = [KTFactory creatViewWithColor:KTColor_BackGround];
        view.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(100));
        UIButton * button = [KTFactory creatButtonWithTitle:@"查看全部"
                                            backGroundColor:[UIColor whiteColor]
                                                  textColor:KTColor_lightGray
                                                   textSize:font750(28)];
        button.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(80));
        [button addTarget:self action:@selector(checkAllSubscri) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        return view;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (self.listArray.count == 0) {
            static NSString * cellid = @"nonSubcell";
            NoneSubscribeCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[NoneSubscribeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }
            cell.descLabel.text = self.NullString;
            return cell;
        }else{
            static NSString * cellid = @"SubscribeListCell";
            SubscribeListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[SubscribeListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }
            [cell updateWithModel:self.listArray[indexPath.row]];
            return cell;
        }
        
    }else if(indexPath.section == 1){
        static NSString * cellid = @"recomendListCell";
        RecommendListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[RecommendListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        if (self.recomendArray[indexPath.row * 2 + 1] != nil) {
            [cell updateWithFristModel:self.recomendArray[indexPath.row * 2] secondModel:self.recomendArray[indexPath.row * 2 +1]];
        }else{
            [cell updateWithFristModel:self.recomendArray[indexPath.row * 2] secondModel:nil];
        }
        cell.delegate = self;
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.listArray.count >0  && indexPath.section == 0 ) {
        HomeListenModel * model = self.listArray[indexPath.row];
        if ([model.catId integerValue] == 2) {
            ListenDetailViewController * vc = [ListenDetailViewController new];
            vc.listenID = model.listenId;
            [self.navigationController pushViewController:vc animated:YES];
        }else if([model.catId integerValue] == 3){
            VoiceDetailViewController * vc = [VoiceDetailViewController new];
            vc.voiceID = model.listenId;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)checkAudioDetail:(UIButton *)btn{
    NSInteger tag = btn.tag;
    UITableViewCell * cell = (UITableViewCell *)[[btn superview] superview];
    NSIndexPath * indexPath = [self.tabview indexPathForCell:cell];
    HomeListenModel * model = self.recomendArray[indexPath.row * 2 + tag - 1];
    if ([model.catId integerValue] == 2) {
        ListenDetailViewController * vc = [ListenDetailViewController new];
        vc.listenID = model.listenId;
        [self.navigationController pushViewController:vc animated:YES];
    }else if([model.catId integerValue] == 3){
        VoiceDetailViewController * vc = [VoiceDetailViewController new];
        vc.voiceID = model.listenId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
- (void)checkAllSubscri{
    SubscriListViewController * vc = [SubscriListViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getSubscribeData{
    
    [[NetWorkManager manager] GETRequest:@{} pageUrl:Page_SubscribeRec complete:^(id result) {
        [self.recomendArray removeAllObjects];
        NSArray * datas = (NSArray *)result;
        if (datas.count>0) {
            NSData * data = [NSJSONSerialization dataWithJSONObject:datas options:NSJSONWritingPrettyPrinted error:nil];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"recoendArray"];
        }
        for (int i = 0; i<datas.count; i++) {
            HomeListenModel * model = [[HomeListenModel alloc]initWithDictionary:datas[i]];
            [self.recomendArray addObject:model];
        }
        [self.tabview reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    } errorBlock:^(KTError *error) {
        
    }];
}
- (void)getData{
    [self showLoadingCantClear:YES];
    [self.listArray removeAllObjects];
    NSDictionary * params = @{
                              @"pagesize":@"3",
                              };
    [[NetWorkManager manager] GETRequest:params pageUrl:Page_Subscribed complete:^(id result) {
        [self dismissLoadingView];
        if (result[@"list"] && [result[@"list"] isKindOfClass:[NSArray class]]) {
            NSArray * array = result[@"list"];
            for (int i = 0; i< array.count; i++) {
                HomeListenModel * model = [[HomeListenModel alloc]initWithDictionary:array[i]];
                id obj = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@",model.listenId]];
                if (!obj) {
                    [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:[NSString stringWithFormat:@"%@",model.listenId]];
                }
                
                [self.listArray addObject:model];
            }
            [self.tabview reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }
        
        if (self.listArray.count == 0 && result[@"nobuy"]) {
            self.NullString = result[@"nobuy"];
            [self.tabview reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }
        [self hiddenNullView];
    } errorBlock:^(KTError *error) {
        [self dismissLoadingView];
    }];
}


@end
