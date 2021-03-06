//
//  DownLoadSubViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/3.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "DownLoadSubViewController.h"
#import "DownLoadListCell.h"
#import "HomeTopModel.h"
#import "AudioDownLoader.h"
#import "TopListBottomView.h"
#import "DownLoadHeaderView.h"
@interface DownLoadSubViewController ()<UITableViewDelegate,UITableViewDataSource>

//@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic) BOOL isDelete;
@property (nonatomic, strong) UIButton * statusButton;
@property (nonatomic, strong) TopListBottomView * footView;
@property (nonatomic, strong) DownLoadHeaderView * headerView;
@end

@implementation DownLoadSubViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    self.isDelete = NO;
    [self refreshData];
    [self getData];
}
- (void)refreshData{
    [self.dataArray addObject:[AudioDownLoader loader].currentModel];
    [self.tabview reloadData];
}
- (void)getData{
    NSMutableArray * muarr = [[SqlManager manager] getAllDownLoaderStatus];
    self.dataArray = [NSMutableArray arrayWithArray:muarr];
    [self.tabview reloadData];
    if (self.dataArray.count == 0) {
        [self showNullViewWithNullViewType:NullTypeNoneDown];
    }else{
        [self hiddenNullView];
    }
    [self.headerView updateWithCount:self.dataArray];
}
- (void)creatUI{
    self.tabview = [KTFactory creatTabviewWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT  - 64) style:UITableViewStyleGrouped];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
    
    self.footView = [[TopListBottomView alloc]init];
    [self.footView.downLoadBtn setTitle:@"删除" forState:UIControlStateNormal];
    self.footView.frame = CGRectMake(0, UI_HEGIHT - Anno750(88), UI_WIDTH, Anno750(88));
    [self.footView.downLoadBtn addTarget:self action:@selector(deleteAllSelectAudio) forControlEvents:UIControlEventTouchUpInside];
    self.footView.hidden = YES;
    [self.view addSubview:self.footView];
    
    
    UIView * header = [KTFactory creatViewWithColor:KTColor_BackGround];
    header.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(110));
    self.headerView = [[DownLoadHeaderView alloc]initWithFrame:CGRectMake(0, Anno750(30), UI_WIDTH, Anno750(80))];
    [header addSubview:self.headerView];
    [self.headerView.statusButton addTarget:self action:@selector(changeDeleteStatus) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.selectButton addTarget:self action:@selector(slectAllAudio:) forControlEvents:UIControlEventTouchUpInside];
    self.tabview.tableHeaderView = header;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Anno750(120);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellid = @"DownLoadListCell";
    DownLoadListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[DownLoadListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    [cell updateWithHistoryModel:self.dataArray[indexPath.row] pausStatus:NO isDown:YES];
    [cell showSelectBotton:self.isDelete];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isDelete) {
        HomeTopModel * model = self.dataArray[indexPath.row];
        model.isSelectDown = !model.isSelectDown;
        [self.footView updateWithArrays:self.dataArray];
        [self.headerView updateWithCount:self.dataArray];
        [self.tabview reloadData];
    }else{
        HomeTopModel * model = self.dataArray[indexPath.row];
        [AudioPlayer instance].playList = self.dataArray;
        [[AudioPlayer instance] audioPlay:model];
        [self reloadTabviewFrame];
    }
}
- (void)slectAllAudio:(UIButton *)button{
    button.selected = !button.selected;
    for (int i = 0 ; i<self.dataArray.count; i++) {
        HomeTopModel * model = self.dataArray[i];
        model.isSelectDown = button.selected;
    }
    [self.tabview reloadData];
    [self.footView updateWithArrays:self.dataArray];
    [self.headerView updateWithCount:self.dataArray];
}
//- (void)audioDownLoadOver{
//    [self.dataArray addObject:[AudioDownLoader loader].currentModel];
//    [self.tabview reloadData];
//}
- (void)changeDeleteStatus{
    self.isDelete = !self.isDelete;
    CGRect frame = self.footView.frame;
    self.footView.frame = CGRectMake(frame.origin.x, UI_HEGIHT - Anno750(88) - 64 -([AudioPlayer instance].showFoot ? Anno750(100) : 0), frame.size.width, frame.size.height);
    if (self.isDelete) {
        self.footView.hidden = NO;
        self.tabview.frame = CGRectMake(0,0, UI_WIDTH, UI_HEGIHT - Anno750(88) - 64);
    }else{
        self.footView.hidden = YES;
        self.tabview.frame = CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT - 64);
    }
    [self.tabview reloadData];
}
- (void)deleteAllSelectAudio{
    
    NSInteger num = 0;
    for (int i = 0; i<self.dataArray.count; i++) {
        HomeTopModel * model = self.dataArray[i];
        if (model.isSelectDown) {
            num += 1;
            break;
        }
    }
    
    if (num ==0) {
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"请选择你要删除的文件" duration:1.0f];
        return;
    }
    [self changeDeleteStatus];
    [self.headerView statusButtonClick:self.headerView.statusButton];
    for (HomeTopModel * model in self.dataArray) {
        if (model.isSelectDown) {
            [[SqlManager manager] deleteAudioWithID:model.audioId];
            [[AudioDownLoader loader] deleteAudioWithLocalPath:model.localAddress];
        }
    }
    [self getData];
}
@end
