//
//  TopListViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/7.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "TopListViewController.h"
#import "TopListCell.h"
#import "TopHeaderView.h"
#import "HomeTopModel.h"
#import "CateListViewController.h"
#import "TopListDownCell.h"
#import "TopListBottomView.h"
#import "AudioPlayerViewController.h"
#import "AudioDownLoader.h"
#import "WKWebViewController.h"
#import "LoginViewController.h"
//测试
#import "SqlManager.h"
#import "AppDelegate.h"
#import "HistorySql.h"
@interface TopListViewController ()<UITableViewDelegate,UITableViewDataSource,TopListCellDelegate,AudioDownLoadDelegate>

//@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, assign) int page;

@property (nonatomic, strong) NSMutableArray * dataArray;
/**是否是下载界面*/
@property (nonatomic, assign) BOOL isDownLoad;
@property (nonatomic, strong) TopListBottomView * footView;
@property (nonatomic, strong) UIButton * downLoadBtn;
@property (nonatomic) BOOL hasReduce;

@end

@implementation TopListViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavUnAlpha];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //隐藏toolsbar
    for (int i = 0; i<self.dataArray.count; i++) {
        HomeTopModel * model = self.dataArray[i];
        model.showTools = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawBackButtonWithType:BackImgTypeBlack];
    [self setNavTitle:@"财经头条" color:KTColor_MainBlack];
    
    self.isDownLoad = NO;
    [self creatUI];
    [self refreshData];
    [AudioDownLoader loader].delegate = self;
    
}

- (void)creatUI{
    TopHeaderView * topView = [[TopHeaderView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, Anno750(90))];
    [topView.cateBtn addTarget:self action:@selector(pushToTagListViewController) forControlEvents:UIControlEventTouchUpInside];
    [topView.downLoadBtn addTarget:self action:@selector(changeDownLoadStatus:) forControlEvents:UIControlEventTouchUpInside];
    self.downLoadBtn = topView.downLoadBtn;
    [self.view addSubview:topView];
    
    self.dataArray = [NSMutableArray new];
    self.tabview = [KTFactory creatTabviewWithFrame:CGRectMake(0, Anno750(90), UI_WIDTH, UI_HEGIHT - Anno750(90) - 64) style:UITableViewStylePlain];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
    
    self.footView = [[TopListBottomView alloc]init];
    self.footView.frame = CGRectMake(0, UI_HEGIHT - Anno750(88) - 64, UI_WIDTH, Anno750(88));
    [self.footView.downLoadBtn addTarget:self action:@selector(downAllSelectAudio) forControlEvents:UIControlEventTouchUpInside];
    self.footView.hidden = YES;
    [self.view addSubview:self.footView];

    
    self.refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
    self.tabview.mj_header = self.refreshHeader;
    self.tabview.mj_footer = self.refreshFooter;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeTopModel * model = self.dataArray[indexPath.row];
    CGSize size = [KTFactory getSize:model.audioName maxSize:CGSizeMake(Anno750(646), 9999) font:[UIFont systemFontOfSize:font750(30)]];
    return Anno750(96) + size.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isDownLoad) {
        
        HomeTopModel * model = self.dataArray[indexPath.row];
        if ([model.downStatus intValue]== 2) {
            static NSString * cellid = @"topListCell";
            TopListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[TopListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }
            [cell updateWithHomeTopModel:self.dataArray[indexPath.row]];
            cell.moreBtn.hidden = YES;
            return cell;
        }
        
        static NSString * cellid = @"TopListDown";
        TopListDownCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[TopListDownCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        [cell updateWithHomeTopModel:self.dataArray[indexPath.row]];
        return cell;
    }else{
        static NSString * cellid = @"topListCell";
        TopListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[TopListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        [cell updateWithHomeTopModel:self.dataArray[indexPath.row]];
        cell.moreBtn.hidden = NO;
        cell.delegate =self;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeTopModel * model = self.dataArray[indexPath.row];
    if (self.isDownLoad) {
        if ([model.downStatus integerValue] == 0 || [model.downStatus integerValue] == 1) {
            model.isSelectDown = !model.isSelectDown;
            [self.footView updateWithArrays:self.dataArray];
            [self.tabview reloadData];
        }
        //下载选择
    }else{
        [self hiddenToolsBar];
        //进入音乐播放器
        [AudioPlayer instance].currentAudio = model;
        [AudioPlayer instance].playList = self.dataArray;
        AudioPlayerViewController * audioVC = [AudioPlayerViewController new];
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:audioVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
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
    NSString * pageUrl = [NSString stringWithFormat:@"%@/pagesize/10/page/%d",page_TopList,self.page];
    [[NetWorkManager manager] GETRequest:@{} pageUrl:pageUrl complete:^(id result) {
        
        NSArray * datas = (NSArray *)result;
        if (self.dataArray.count != 0 && datas.count< 10) {
            if (datas.count == 0) {
                self.page -= 1;
            }
            [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"没有更多了" duration:1.0f];
        }
        for (int i = 0; i<datas.count; i++) {
            HomeTopModel * model = [[HomeTopModel alloc]initWithDictionary:datas[i]];
            NSNumber * status = [[SqlManager manager] checkDownStatusWithAudioid:model.audioId];
            if ([status integerValue] != 1000) {
                model.downStatus = status;
            }
            model.playLong = [[HistorySql sql] getPlayLongWithAudioID:model.audioId];
            [self.dataArray addObject:model];
        }
        
        [self.tabview reloadData];
        [self.refreshHeader endRefreshing];
        if (datas.count<10) {
            [self.refreshFooter endRefreshingWithNoMoreData];
        }else{
            [self.refreshFooter endRefreshing];
        }
    } errorBlock:^(KTError *error) {
        if (self.page > 1) {
            self.page -= 1;
        }
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:error.message duration:1.0f];
    }];
}
#pragma mark - 进入分类列表页
- (void)pushToTagListViewController{
    [self.navigationController pushViewController:[CateListViewController new] animated:YES];
}
#pragma mark - 下载状态更改
- (void)changeDownLoadStatus:(UIButton *)btn{
    btn.selected = !btn.selected;
    CGRect frame = self.footView.frame;
    if (!_hasReduce) {
        self.footView.frame = CGRectMake(frame.origin.x, frame.origin.y -([AudioPlayer instance].showFoot ? Anno750(100) : 0), frame.size.width, frame.size.height);
    }
    _hasReduce = !_hasReduce;
    //隐藏toolsbar
    for (int i = 0; i<self.dataArray.count; i++) {
        HomeTopModel * model = self.dataArray[i];
        model.showTools = NO;
    }
    self.isDownLoad = !self.isDownLoad;
    if (self.isDownLoad) {
        self.footView.hidden = NO;
        self.tabview.frame = CGRectMake(0, Anno750(90), UI_WIDTH, UI_HEGIHT - Anno750(90) - Anno750(88) - 64-([AudioPlayer instance].showFoot ? Anno750(100) : 0));
    }else{
        self.footView.hidden = YES;
        self.tabview.frame = CGRectMake(0, Anno750(90), UI_WIDTH, UI_HEGIHT - Anno750(90) - 64-([AudioPlayer instance].showFoot ? Anno750(100) : 0));
    }
    [self.tabview reloadData];
}
#pragma mark - 下载音频
- (void)downLoadAudio:(UIButton *)button{
    [self hiddenToolsBar];
    UITableViewCell * cell = (UITableViewCell *)[[button superview] superview];
    NSIndexPath * index = [self.tabview indexPathForCell:cell];
    HomeTopModel * model = self.dataArray[index.row];
    
    NSNumber * num = [[SqlManager manager] checkDownStatusWithAudioid:model.audioId];
    if ([num integerValue] == 0) {
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"已加入下载队列中" duration:1.5];
        return;
    }else if([num integerValue] == 1 || [num integerValue] == 2){
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"本地音频，无需下载" duration:1.5f];
        return;
    }
    
    AppDelegate * appdelegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdelegete.netStatus == ReachableViaWiFi) {
        [[AudioDownLoader loader] downLoadAudioWithHomeTopModel:@[model]];
    }else{
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您正在使用流量，是否确定下载？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cannce = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确定下载"
                                                        style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                            [[AudioDownLoader loader] downLoadAudioWithHomeTopModel:@[model]];
                                                        }];
        [alert addAction:cannce];
        [alert addAction:sure];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
#pragma mark - 下载所选择音频
- (void)downAllSelectAudio{
    NSMutableArray * muarr = [NSMutableArray new];
    for (int i = 0; i<self.dataArray.count; i++) {
        HomeTopModel * model = self.dataArray[i];
        if (model.isSelectDown) {
            NSNumber * num = [[SqlManager manager] checkDownStatusWithAudioid:model.audioId];
            if ([num integerValue] == 1000) {
                [muarr addObject:model];
            }
        }
    }
    AppDelegate * appdelegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdelegete.netStatus == ReachableViaWiFi) {
        [[AudioDownLoader loader] downLoadAudioWithHomeTopModel:muarr];
        [self changeDownLoadStatus:self.downLoadBtn];
    }else{
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您正在使用流量，是否确定下载？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cannce = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确定下载"
                                                        style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                            [[AudioDownLoader loader] downLoadAudioWithHomeTopModel:muarr];
                                                            [self changeDownLoadStatus:self.downLoadBtn];
                                                        }];
        [alert addAction:cannce];
        [alert addAction:sure];
        [self presentViewController:alert animated:YES completion:nil];
    }
   
    
}
#pragma mark - 查看音频文档
- (void)checkAudioText:(UIButton *)button{
    UITableViewCell * cell = (UITableViewCell *)[[button superview] superview];
    NSIndexPath * index = [self.tabview indexPathForCell:cell];
    HomeTopModel * model = self.dataArray[index.row];
    WKWebViewController * vc= [[WKWebViewController alloc]init];
    vc.model = model;
    vc.webType = PROTOCOLTYPEELSETEXT;
    [self hiddenToolsBar];
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - 音频点赞
- (void)likeAudioClick:(UIButton *)button{
    if (![UserManager manager].isLogin) {
        LoginViewController * vc = [LoginViewController new];
        UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nvc animated:YES completion:nil];
    }else{
        UITableViewCell * cell = (UITableViewCell *)[[button superview] superview];
        NSIndexPath * index = [self.tabview indexPathForCell:cell];
        HomeTopModel * model = self.dataArray[index.row];
        NSDictionary * params = @{
                                  //关联1.头条、2.听书、3.声度、0.音频(音频不是栏目所以为0)
                                  @"relationType":@1,
                                  @"relationId":model.audioId,
                                  @"nickName":[UserManager manager].info.NICKNAME
                                  };
        NSString * pageUrl = Page_AddLike;
        if (button.selected) {
            pageUrl = Page_DelLike;
        }
        [[NetWorkManager manager] POSTRequest:params pageUrl:pageUrl complete:^(id result) {
            [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:button.selected ? @"取消成功":@"点赞成功" duration:1.0f];
            button.selected = !button.selected;
            model.isprase = button.selected;
            [self.tabview reloadData];
        } errorBlock:^(KTError *error) {
            
        }];
    }
    [self hiddenToolsBar];
}
#pragma mark - 分享
- (void)shareBtnClick:(UIButton *)button{
    UITableViewCell * cell = (UITableViewCell *)[[button superview] superview];
    NSIndexPath * index = [self.tabview indexPathForCell:cell];
    HomeTopModel * model = self.dataArray[index.row];

    [self hiddenToolsBar];
}
#pragma mark - 点击更多按钮
- (void)moreBtnClick:(UIButton *)button{
    UITableViewCell * cell = (UITableViewCell *)[button superview];
    NSIndexPath * index = [self.tabview indexPathForCell:cell];
    for (int i = 0; i<self.dataArray.count; i++) {
        HomeTopModel * model = self.dataArray[i];
        if (i == index.row) {
            model.showTools =!model.showTools;
        }else{
            model.showTools = NO;
        }
    }
    [self.tabview reloadData];
}

#pragma mark - 音频下载完成
- (void)audioDownLoadOver{
    if (self) {
        NSInteger index = [self.dataArray indexOfObject:[AudioDownLoader loader].currentModel];
        HomeTopModel * model = self.dataArray[index];
        model.downStatus = @2;
        [self.tabview reloadData];
    }
}

#pragma mark - 隐藏toolbar
- (void)hiddenToolsBar{
    for (int i = 0; i<self.dataArray.count; i++) {
        HomeTopModel * model = self.dataArray[i];
        model.showTools = NO;
    }
    [self.tabview reloadData];
}


@end
