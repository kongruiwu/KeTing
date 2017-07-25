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
    [self getListData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self getSubscribeData];
}

- (void)creatUI{
    self.NullString = @"尚未订阅，看看我们为你推荐的吧";
    self.recomendArray = [NSMutableArray new];
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
    return Anno750(80);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return Anno750(20);
    }
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        SelectSectionHeader * header = [[SelectSectionHeader alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, Anno750(80))];
        [header updateWithTitle:@"我的订阅" andSection:1];
        [header.checkButton addTarget:self action:@selector(checkAllSubscri) forControlEvents:UIControlEventTouchUpInside];
        return header;
    }else if (section == 1) {
        SubscribeSectionHeader * header = [[SubscribeSectionHeader alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, Anno750(80))];
        [header.changeBtn addTarget:self action:@selector(getSubscribeData) forControlEvents:UIControlEventTouchUpInside];
        return header;
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
    [self.recomendArray removeAllObjects];
    [[NetWorkManager manager] GETRequest:@{} pageUrl:Page_SubscribeRec complete:^(id result) {
        NSArray * datas = (NSArray *)result;
        for (int i = 0; i<datas.count; i++) {
            HomeListenModel * model = [[HomeListenModel alloc]initWithDictionary:datas[i]];
            [self.recomendArray addObject:model];
        }
        [self.tabview reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    } errorBlock:^(KTError *error) {
        
    }];
}
- (void)getListData{
    [self showLoadingCantClear:YES];
    [self.listArray removeAllObjects];
    [[NetWorkManager manager] GETRequest:@{} pageUrl:Page_Subscribed complete:^(id result) {
        [self dismissLoadingView];
        if (result[@"list"] && [result[@"list"] isKindOfClass:[NSArray class]]) {
            NSArray * array = result[@"list"];
            for (int i = 0; i< array.count; i++) {
                HomeListenModel * model = [[HomeListenModel alloc]initWithDictionary:array[i]];
                [self.listArray addObject:model];
            }
            [self.tabview reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }
        
        if (self.listArray.count == 0 && result[@"nobuy"]) {
            self.NullString = result[@"nobuy"];
            [self.tabview reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }
    } errorBlock:^(KTError *error) {
        [self dismissLoadingView];
    }];
}


@end
