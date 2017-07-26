//
//  CateDetailViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/9.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "CateDetailViewController.h"
#import "HomeTopModel.h"
#import "TopListCell.h"
#import "AudioPlayerViewController.h"
#import "AppDelegate.h"
#import "AudioDownLoader.h"
#import "WKWebViewController.h"
#import "LoginViewController.h"
#import "HistorySql.h"
#import "RootViewController.h"
@interface CateDetailViewController ()<UITableViewDelegate,UITableViewDataSource,AudioDownLoadDelegate,TopListCellDelegate>

@property (nonatomic, strong) NSString * tagID;
@property (nonatomic, strong) NSString * name;

//@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation CateDetailViewController

- (instancetype)initWithTagid:(NSString *)tagid tagName:(NSString *)tagName{
    self = [super init];
    if (self) {
        self.tagID = tagid;
        self.name = tagName;
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [AudioDownLoader loader].delegate = nil;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [AudioDownLoader loader].delegate = self;
    [self checkNetStatus];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawBackButtonWithType:BackImgTypeBlack];
    [self setNavTitle:@"财经头条" color:KTColor_MainBlack];
    [self creatUI];
    [self getData];
    
}
- (void)creatUI{
    self.dataArray = [NSMutableArray new];
    
    self.tabview = [KTFactory creatTabviewWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT) style:UITableViewStylePlain];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
    
    UILabel * headLabel = [KTFactory creatLabelWithText:self.name
                                              fontValue:font750(30)
                                              textColor:KTColor_MainBlack
                                          textAlignment:NSTextAlignmentCenter];
    headLabel.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(88));
    self.tabview.tableHeaderView = headLabel;
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
    
    static NSString * cellid = @"cateDetail";
    TopListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[TopListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    [cell updateWithHomeTopModel:self.dataArray[indexPath.row]];
    cell.delegate = self;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [AudioPlayer instance].currentAudio = self.dataArray[indexPath.row];
    [AudioPlayer instance].playList = self.dataArray;
    AudioPlayerViewController * audioVC = [AudioPlayerViewController new];
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:audioVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)getData{
    [self showLoadingCantTouchAndClear];
    NSDictionary * params = @{
                              @"tagId":self.tagID
                              };
    [[NetWorkManager manager] GETRequest:params pageUrl:Page_TagAudio complete:^(id result) {
        [self dismissLoadingView];
        NSArray * arr = (NSArray *)result;
        for (int i = 0; i<arr.count; i++) {
            HomeTopModel * model = [[HomeTopModel alloc]initWithDictionary:arr[i]];
            NSNumber * status = [[SqlManager manager] checkDownStatusWithAudioid:model.audioId];
            if ([status integerValue] != 1000) {
                model.downStatus = status;
            }
            model.playLong = [[HistorySql sql] getPlayLongWithAudioID:model.audioId];
            [self.dataArray addObject:model];
        }
        [self.tabview reloadData];
    } errorBlock:^(KTError *error) {
        [self dismissLoadingView];
    }];
}

#pragma mark - 下载音频
- (void)downLoadAudio:(UIButton *)button{
    UITableViewCell * cell = (UITableViewCell *)[[button superview] superview];
    NSIndexPath * index = [self.tabview indexPathForCell:cell];
    HomeTopModel * model = self.dataArray[index.row];
    NSNumber * num = [[SqlManager manager] checkDownStatusWithAudioid:model.audioId];
    [self hiddenToolsBar];
    if ([num integerValue] == 0) {
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"已加入下载队列中" duration:1.5];
        return;
    }else if([num integerValue] == 1 || [num integerValue] == 2){
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"本地音频，无需下载" duration:1.5f];
        return;
    }
    
    AppDelegate * appdelegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdelegete.netManager.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi) {
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
    BOOL rec = NO;
    for (int i = 0; i<self.dataArray.count; i++) {
        HomeTopModel * model = self.dataArray[i];
        if (model.isSelectDown) {
            rec = YES;
            NSNumber * num = [[SqlManager manager] checkDownStatusWithAudioid:model.audioId];
            if ([num integerValue] == 1000) {
                [muarr addObject:model];
            }
        }
    }
    if (muarr.count ==0) {
        NSString * message = @"请选择您要下载的音频";
        if (rec) {
            message = @"所选音频已在下载队列中";
        }
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:message duration:1.0f];
        return;
    }
    AppDelegate * appdelegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdelegete.netManager.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi) {
        [[AudioDownLoader loader] downLoadAudioWithHomeTopModel:muarr];
        
    }else{
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您正在使用流量，是否确定下载？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cannce = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确定下载"
                                                        style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                            [[AudioDownLoader loader] downLoadAudioWithHomeTopModel:muarr];
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
    vc.isFromNav = YES;
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
                                  @"keyId":model.audioId,
                                  @"nickName":[UserManager manager].info.NICKNAME
                                  };
        NSString * pageUrl = Page_AddLike;
        if (button.selected) {
            pageUrl = Page_DelLike;
        }
        [self showLoadingCantClear:YES];
        [[NetWorkManager manager] POSTRequest:params pageUrl:pageUrl complete:^(id result) {
            [self dismissLoadingView];
            [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:button.selected ? @"取消成功":@"点赞成功" duration:1.0f];
            button.selected = !button.selected;
            model.isprase = button.selected;
            [self.tabview reloadData];
        } errorBlock:^(KTError *error) {
            [self dismissLoadingView];
        }];
    }
    [self hiddenToolsBar];
}
#pragma mark - 分享
- (void)shareBtnClick:(UIButton *)button{
    UITableViewCell * cell = (UITableViewCell *)[[button superview] superview];
    NSIndexPath * index = [self.tabview indexPathForCell:cell];
    HomeTopModel * Audio = self.dataArray[index.row];
    ShareModel * model = [[ShareModel alloc]init];
    model.shareTitle = Audio.audioName;
    model.shareDesc = Audio.summary;
    UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:Audio.thumbnail]]];
    model.image = image;
    model.targeturl = [NSString stringWithFormat:@"%@%@%@/type/%@/rid/%@",Base_Url,Page_ShareAudio,Audio.audioId,@1,Audio.topId];
    RootViewController * tbc = (RootViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    [tbc.shareView updateWithShareModel:model];
    [tbc.shareView show];

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
        NSInteger index = -1 ;
        for (int i = 0; i<self.dataArray.count; i++) {
            HomeTopModel * model = self.dataArray[i];
            if ([[AudioDownLoader loader].currentModel.audioId integerValue] == [model.audioId integerValue]) {
                index = i;
            }
        }
        if (index == -1) {
            return;
        }
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
