//
//  SelectedViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/5.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "SelectedViewController.h"
#import "SelectSectionHeader.h"
#import "HomeVoiceCell.h"
#import "HomeFinancialCell.h"
#import "HomeCollectionCell.h"
#import "HomeBottomNewsCell.h"
#import "HomeViewModel.h"
#import "VoiceDetailViewController.h"
#import "ListenDetailViewController.h"
//头条
#import "TopListViewController.h"
//声度
#import "VoiceListViewController.h"
//听书
#import "ListenListViewController.h"
//播放器
#import "AudioPlayerViewController.h"

#import <MBProgressHUD.h>
@interface SelectedViewController ()<UITableViewDelegate,UITableViewDataSource,ListenBookDelegate,HomeFinancialDelegate,AudioPlayerDelegate>

//@property (nonatomic, strong) UITableView * tabview;

@property (nonatomic, strong) HomeViewModel * model;

@end

@implementation SelectedViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self AudioPlayerPlayStatusReady];
    [AudioPlayer instance].delegate = self;
    
    [self checkNetStatus];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [AudioPlayer instance].delegate = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self getData];
}
- (void)creatUI{
    
    
    self.tabview = [KTFactory creatTabviewWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT - 64) style:UITableViewStyleGrouped];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.model.titleArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return self.model.voice.count;
    }
    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return self.model.tops.count >= 4 ? Anno750(50) * self.model.tops.count + Anno750(50): Anno750(210) ;
        case 1:
            return Anno750(190);
        case 2:
            return Anno750(440);
        case 3:
            return Anno750(290);
        default:
            return Anno750(100);
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 3) {
        return Anno750(20);
    }
    return Anno750(120);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 3) {
        return nil;
    }
    UIView * headView = [KTFactory creatViewWithColor:[UIColor clearColor]];
    headView.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(120));
    
    UIView * grayView = [KTFactory creatViewWithColor:KTColor_BackGround];
    grayView.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(20));
    SelectSectionHeader * sectionView = [[SelectSectionHeader alloc]initWithFrame:CGRectMake(0, Anno750(20), UI_WIDTH, Anno750(100))];
    [sectionView updateWithTitle:self.model.titleArray[section] andSection:section];
    [sectionView.checkButton addTarget:self action:@selector(checkAllViewController:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:grayView];
    [headView addSubview:sectionView];
    return headView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        static NSString * cellid = @"finnalcell";
        HomeFinancialCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[HomeFinancialCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        [cell updateWithHomeTopModels:self.model.tops];
        cell.delegate = self;
        return cell;
    } else if(indexPath.section == 1){
        static NSString * cellid = @"voiceCell";
        HomeVoiceCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[HomeVoiceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        [cell updateWithVoiceModel:self.model.voice[indexPath.row]];
        return cell;
    } else if(indexPath.section == 2){
        static NSString * cellid = @"listenCell";
        HomeCollectionCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[HomeCollectionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        [cell updateWithArray:self.model.listen];
        cell.delegate = self;
        return cell;
    } else if(indexPath.section == 3){
        static NSString * cellid = @"bottomCell";
        HomeBottomNewsCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[HomeBottomNewsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        [cell updateWithvoiceStockSecret:self.model.voiceStockSecret];
        return cell;
    }
    
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
        HomeListenModel * model = self.model.voice[indexPath.row];
        VoiceDetailViewController * vc = [VoiceDetailViewController new];
        vc.voiceID = model.listenId;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.section == 3){
        VoiceDetailViewController * vc = [VoiceDetailViewController new];
        vc.voiceID =self.model.voiceStockSecret.listenId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
- (void)PlayAudioAtIndex:(NSInteger)index{
    [AudioPlayer instance].currentAudio = self.model.tops[index];
    [AudioPlayer instance].playList = [NSMutableArray arrayWithArray:self.model.tops];
    AudioPlayerViewController * audioVC = [AudioPlayerViewController new];
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:audioVC];
    [self presentViewController:nav animated:YES completion:nil];
    
}
- (void)PlayTopList{
    [AudioPlayer instance].playList = [NSMutableArray arrayWithArray:self.model.tops];
    [[AudioPlayer instance] audioPlay:self.model.tops[0]];
}
- (void)checkBookAtIndex:(NSInteger)index{
    ListenDetailViewController * vc = [ListenDetailViewController new];
    HomeListenModel * model = self.model.listen[index];
    vc.listenID = model.listenId;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)getData{
    [self showLoadingCantTouchAndClear];
    [[NetWorkManager manager] GETRequest:@{} pageUrl:Page_home complete:^(id result) {
        [self dismissLoadingView];
        NSDictionary * dic = (NSDictionary *)result;
        self.model = [[HomeViewModel alloc]initWithDictionary:dic];
        [self.tabview reloadData];
    } errorBlock:^(KTError *error) {
        [self dismissLoadingView];
    }];
}

#pragma mark - 查看更多
- (void)checkAllViewController:(UIButton *)btn{
    int section = (int)btn.tag - 1000;
    switch (section) {
        case 0:
            [self.navigationController pushViewController:[TopListViewController new] animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:[VoiceListViewController new] animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:[ListenListViewController new] animated:YES];
            break;
        default:
        {
            UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:[AudioPlayerViewController new]];
            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
    }
}
- (void)AudioPlayerPlayStatusReady{
    [self.tabview reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}


@end
