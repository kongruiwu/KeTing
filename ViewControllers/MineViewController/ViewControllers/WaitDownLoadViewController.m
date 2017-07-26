//
//  WaitDownLoadViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/19.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "WaitDownLoadViewController.h"
#import "TopHeaderView.h"
#import "DownLoadListCell.h"
#import "AudioDownLoader.h"
@interface WaitDownLoadViewController ()<UITableViewDelegate,UITableViewDataSource>

//@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) TopHeaderView * header;
@property (nonatomic, strong) NSMutableArray * dataArray;
@end

@implementation WaitDownLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self refreshData];
    [self getData];
}
- (void)refreshData{
    NSInteger index = -1 ;
    for (int i = 0; i<self.dataArray.count; i++) {
        HomeTopModel * model = self.dataArray[i];
        if ([model.audioId longLongValue] == [[AudioDownLoader loader].currentModel.audioId longLongValue]) {
            index = i;
            break;
        }
    }
    if (index == -1) {
        return;
    }
    [self.dataArray removeObjectAtIndex:index];
    [self.tabview reloadData];
    if (self.dataArray.count == 0 ) {
        [self showNullViewWithNullViewType:NullTypeNoneDown];
    }
}
- (void)getData{
    NSMutableArray * muarr = [[SqlManager manager] getWaitDownLoadingAudios];
    self.dataArray = [NSMutableArray arrayWithArray:muarr];
    NSMutableArray * current = [[SqlManager manager] getDownLoadingAudio];
    if (current.count >0) {
        [self.dataArray addObject:current[0]];
    }
    [self.tabview reloadData];
    if (self.dataArray.count == 0) {
        [self showNullViewWithNullViewType:NullTypeNoneDown];
    }else{
        [self hiddenNullView];
    }
}
- (void)creatUI{
    self.header = [[TopHeaderView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, Anno750(90))];
    [self.header updateWithImages:@[@"my_ stop",@"my_ delete"] titles:@[@"    全部暂停",@"    全部清空"]];
    [self.header.cateBtn addTarget:self action:@selector(pauseAllDownLoad:) forControlEvents:UIControlEventTouchUpInside];
    [self.header.downLoadBtn addTarget:self action:@selector(clearAllDownLoadList) forControlEvents:UIControlEventTouchUpInside];
    [self.header.cateBtn setImage:[UIImage imageNamed:@"my_play"] forState:UIControlStateSelected];
    [self.header.cateBtn setTitle:@"    开始下载" forState:UIControlStateSelected];
    self.header.cateBtn.selected = ![AudioDownLoader loader].isDownLoading;
    [self.view addSubview:self.header];
    
    self.tabview = [KTFactory creatTabviewWithFrame:CGRectMake(0, Anno750(90), UI_WIDTH, UI_HEGIHT - Anno750(90) - 64 ) style:UITableViewStyleGrouped];
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
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Anno750(30);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellid = @"DownLoadListCell";
    DownLoadListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[DownLoadListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    [cell showSelectBotton:NO];
    [cell updateWithHistoryModel:self.dataArray[indexPath.row] pausStatus:YES isDown:NO];
    cell.downStatus.text = [AudioDownLoader loader].isDownLoading ?  @"" : @"已暂停";
    return cell;
}

- (void)pauseAllDownLoad:(UIButton *)button{
    if (button.selected) {
        [[AudioDownLoader loader] resumeDownLoading];
    }else{
        [[AudioDownLoader loader] cancelDownLoading];
    }
    button.selected = !button.selected;
    [self.tabview reloadData];
    self.header.cateBtn.selected = ![AudioDownLoader loader].isDownLoading;
}
- (void)clearAllDownLoadList{
    for (int i = 0; i<self.dataArray.count; i++) {
        HomeTopModel * model = self.dataArray[i];
        [[SqlManager manager] deleteAudioWithID:model.audioId];
    }
    //清空正在下载数据
    [[AudioDownLoader loader] clearDownLoadingData];
    [self getData];
}

@end
