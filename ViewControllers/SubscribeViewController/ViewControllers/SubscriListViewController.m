//
//  SubscriListViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/18.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "SubscriListViewController.h"
#import "HomeListenModel.h"
#import "SubscribeListCell.h"
#import "ListenDetailViewController.h"
#import "VoiceDetailViewController.h"
@interface SubscriListViewController ()<UITableViewDelegate,UITableViewDataSource>

//@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation SubscriListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavUnAlpha];
    [self setNavTitle:@"我的订阅" color:KTColor_MainBlack];
    [self drawBackButtonWithType:BackImgTypeBlack];
    [self creatUI];
    [self getListData];
}
- (void)creatUI{
    self.dataArray = [NSMutableArray new];
    
    self.tabview = [KTFactory creatTabviewWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT - 64) style:UITableViewStyleGrouped];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Anno750(170);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Anno750(30);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellid = @"SubscribeListCell";
    SubscribeListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[SubscribeListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    [cell updateWithModel:self.dataArray[indexPath.row]];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        HomeListenModel * model = self.dataArray[indexPath.row];
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


- (void)getListData{
    [[NetWorkManager manager] GETRequest:@{} pageUrl:Page_Subscribed complete:^(id result) {
        if (result[@"list"] && [result[@"list"] isKindOfClass:[NSArray class]]) {
            [self hiddenNullView];
            NSArray * array = result[@"list"];
            for (int i = 0; i< array.count; i++) {
                HomeListenModel * model = [[HomeListenModel alloc]initWithDictionary:array[i]];
                [self.dataArray addObject:model];
            }
            [self.tabview reloadData];
        }
        if (self.dataArray.count == 0) {
            [self showNullViewWithNullViewType:NullTypeNoneAudio];
        }
    } errorBlock:^(KTError *error) {
        [self showNullViewWithNullViewType:NullTypeNoneAudio];
    }];
}

@end
