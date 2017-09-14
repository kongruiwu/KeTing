//
//  VoiceDetailViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/12.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "VoiceDetailViewController.h"
#import "VoiceDetailHeader.h"
#import "VoiceSummaryCell.h"
#import "VoiceUpdateListCell.h"
#import "HomeListenModel.h"
#import "VoiceSectionCell.h"
#import "TopListCell.h"
#import "TopListDownCell.h"
#import "TopListBottomView.h"
#import "SetAccoutViewController.h"
#import "AudioDownLoader.h"
#import "AppDelegate.h"
#import "WKWebViewController.h"
#import "LoginViewController.h"
#import "RootViewController.h"
#import "RMIAPHelper.h"
#import "OrderModel.h"


#define NAVBAR_CHANGE_POINT 10

@interface VoiceDetailViewController ()<UITableViewDelegate,UITableViewDataSource,TopListCellDelegate,AudioDownLoadDelegate,RMIAPHelperDelegate>

//@property (nonatomic, strong) UITableView * tabview;

@property (nonatomic, strong) HomeListenModel * listenModel;

@property (nonatomic, strong) VoiceDetailHeader * header;
/**是否是下载界面*/
@property (nonatomic, assign) BOOL isDownLoad;
/**已购买界面是否展开简介等栏目*/
@property (nonatomic, assign) BOOL isOpen;
/**下载状态下的 下载footer*/
@property (nonatomic, strong) TopListBottomView * footView;

@property (nonatomic, strong) UIButton * buyBtn;
@end

@implementation VoiceDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [AudioDownLoader loader].delegate = self;
    [self checkNetStatus];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCell) name:AudioReadyPlaying object:nil];
    [self scrollViewDidScroll:self.tabview];
    [self getData];
    [self.tabview reloadData];
}



- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [AudioDownLoader loader].delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self hiddenNullView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self drawBackButtonWithType:BackImgTypeBlack];
    [self drawRightShare];
    [self creatUI];
    id obj = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@",self.voiceID]];
    if (obj) {
        [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:[NSString stringWithFormat:@"%@",self.voiceID]];
    }
}
- (void)drawRightShare{
    UIImage * image = [[UIImage imageNamed:@"Webshare"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem * barItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(showShareView)];
    self.navigationItem.rightBarButtonItem = barItem;
}

- (void)creatUI{
    self.isDownLoad = NO;
    self.isOpen = NO;
    self.tabview = [KTFactory creatTabviewWithFrame:CGRectMake(0, 64, UI_WIDTH, UI_HEGIHT - 64) style:UITableViewStylePlain];
    
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
    
    self.footView = [[TopListBottomView alloc]init];
    self.footView.hidden = YES;
    [self.view addSubview:self.footView];
    self.footView.frame = CGRectMake(0, UI_HEGIHT - Anno750(88) - 64, UI_WIDTH, Anno750(88));
    [self.footView.downLoadBtn addTarget:self action:@selector(downAllSelectAudio) forControlEvents:UIControlEventTouchUpInside];
    
    self.header  = [[VoiceDetailHeader alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, Anno750(485))];
//    [self.header.backBtn addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
//    [self.header.shareBtn addTarget:self action:@selector(showShareView) forControlEvents:UIControlEventTouchUpInside];
    self.header.backBtn.hidden = YES;
    self.header.shareBtn.hidden = YES;
    [self.header.checkSummy addTarget:self action:@selector(checkVoiceSummy:) forControlEvents:UIControlEventTouchUpInside];
    self.tabview.tableHeaderView = self.header;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headView = [KTFactory creatViewWithColor:[UIColor whiteColor]];
    headView.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(120));
    UIButton * likeBtn = [KTFactory creatButtonWithTitle:[NSString stringWithFormat:@"  %@",self.listenModel.praseNum ? self.listenModel.praseNum : @0]
                                         backGroundColor:[UIColor clearColor]
                                               textColor:KTColor_MainOrange
                                                textSize:font750(30)];
    [likeBtn setImage:[UIImage imageNamed:@"listen_like"] forState:UIControlStateNormal];
    [likeBtn setImage:[UIImage imageNamed:@"listen_liked"] forState:UIControlStateSelected];
    likeBtn.selected = self.listenModel.isprase;
    [likeBtn addTarget:self action:@selector(likeThisBookClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton * buyBtn = [KTFactory creatButtonWithTitle:[NSString stringWithFormat:@"订阅:%@",self.listenModel.timePrice ? self.listenModel.timePrice:@0.00]
                                        backGroundColor:KTColor_MainOrange
                                              textColor:[UIColor whiteColor]
                                               textSize:font750(28)];
    buyBtn.layer.borderColor = KTColor_MainOrange.CGColor;
    buyBtn.layer.borderWidth = 1.0f;
    buyBtn.layer.cornerRadius = 4.0f;
    self.buyBtn = buyBtn;
    if (self.isOpen) {
        [buyBtn setTitle:@"  批量下载" forState:UIControlStateNormal];
        [buyBtn setTitleColor:KTColor_MainOrange forState:UIControlStateNormal];
        [buyBtn setImage:[UIImage imageNamed:@"finance_download"] forState:UIControlStateNormal];
        [buyBtn setTitle:@"  取消下载" forState:UIControlStateSelected];
        [buyBtn setTitleColor:KTColor_MainOrange forState:UIControlStateSelected];
        [buyBtn setImage:[UIImage imageNamed:@"finance_ close"] forState:UIControlStateSelected];
    }else{
        [buyBtn setTitle:[NSString stringWithFormat:@"订阅:%@",self.listenModel.timePrice ? self.listenModel.timePrice:@0.00] forState:UIControlStateNormal];
    }
    
    
    
    buyBtn.backgroundColor = self.isOpen ? [UIColor clearColor] : KTColor_MainOrange;
    [buyBtn addTarget:self action:@selector(buyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [headView addSubview:likeBtn];
    [headView addSubview:buyBtn];
    [likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.centerY.equalTo(@10);
        make.width.equalTo(@(Anno750(321)));
        make.height.equalTo(@(Anno750(68)));
    }];
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Anno750(24)));
        make.centerY.equalTo(@10);
        make.width.equalTo(@(Anno750(321)));
        make.height.equalTo(@(Anno750(68)));
    }];
    likeBtn.layer.borderColor = KTColor_MainOrange.CGColor;
    likeBtn.layer.borderWidth = 1.0f;
    likeBtn.layer.cornerRadius= 2.0f;
    buyBtn.layer.cornerRadius = 2.0f;
    
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.listenModel.isFree || self.listenModel.Isbuy || [self.listenModel.promotionType integerValue] == 2) {
        return self.isOpen ? Anno750(120) : 0;
    }
    return Anno750(120);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.isOpen ? (self.listenModel.audio.count + 1) : ( 2 + (self.listenModel.audio.count > 3 ? 3 : self.listenModel.audio.count));
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isOpen) {
        if (indexPath.row == 0) {
            return Anno750(80);
        }
        int index =(int)(indexPath.row - 1);
        HomeTopModel * model = self.listenModel.audio[index];
        CGSize size = [KTFactory getSize:model.audioName maxSize:CGSizeMake(Anno750(646), 9999) font:[UIFont systemFontOfSize:font750(30)]];
        return Anno750(96) + size.height;
    }else{
        if (indexPath.row == 0) {
            CGSize size = [KTFactory getSize:[KTFactory changeHtmlString:self.listenModel.descString withFont:font750(28)] maxSize:CGSizeMake(font750(702), 99999)];
            return Anno750(80)+ size.height;
        }else if (indexPath.row == 1) {
            return Anno750(80);
        }else{
            return Anno750(175);
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!self.isOpen) {
        if (indexPath.row == 0) {
            static NSString * cellid = @"summaryCell";
            VoiceSummaryCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[VoiceSummaryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }
            [cell updateWithDescString:self.listenModel.descString count:self.listenModel.orderNum isBook:NO];
            return cell;
        }else if(indexPath.row == 1){
            static NSString * cellid = @"sectionCell";
            VoiceSectionCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[VoiceSectionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }

            [cell updateWithName:@"最新更新" color:KTColor_MainBlack font:font750(32)];
            return cell;
        }else{
            static NSString * cellid = @"updateCell";
            VoiceUpdateListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[VoiceUpdateListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }
            [cell updateWithHomeListenModel:self.listenModel.audio[indexPath.row - 2]];
            return cell;
        }
    }else{
        if (indexPath.row == 0) {
            static NSString * cellid = @"sectionCell";
            VoiceSectionCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[VoiceSectionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }
            [cell updateWithName:[NSString stringWithFormat:@"已更新%ld条音频",(unsigned long)self.listenModel.audio.count] color:KTColor_lightGray font:font750(26)];
            return cell;
        }else{
            if (self.isDownLoad) {
                HomeTopModel * model = self.self.listenModel.audio[indexPath.row - 1];
                if ([model.downStatus intValue]== 2) {
                    static NSString * cellid = @"topListCell";
                    TopListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
                    if (!cell) {
                        cell = [[TopListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
                    }
                    [cell updateWithHomeTopModel:model];
                    cell.moreBtn.hidden = YES;
                    return cell;
                }
                
                static NSString * cellid = @"TopListDown";
                TopListDownCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
                if (!cell) {
                    cell = [[TopListDownCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
                }
                [cell updateVoiceDetailWithHomeTopModel:model];
                return cell;
            }else{
                static NSString * cellid = @"topListCell";
                TopListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
                if (!cell) {
                    cell = [[TopListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
                }
                [cell updateWithHomeTopModel:self.listenModel.audio[indexPath.row - 1]];
                cell.delegate =self;
                return cell;
            }
        }
        
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.isOpen) {
        HomeTopModel * model = self.listenModel.audio[indexPath.row - 1];
        if (self.isDownLoad) {
            //下载选择
            if ([model.downStatus integerValue] == 0 || [model.downStatus integerValue] == 1) {
                model.isSelectDown = !model.isSelectDown;
            }
            [self.footView updateWithArrays:self.listenModel.audio];
            [self.tabview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }else{
            [self hiddenToolsBar];
            [[AVQueenManager Manager] playAudioList:self.listenModel.audio playAtIndex:indexPath.row - 1];
            [self reloadTabviewFrame];
        }
    }
    
}
- (void)getData{
    [self showLoadingCantTouchAndGround];
    [[NetWorkManager manager] GETRequest:@{} pageUrl:[NSString stringWithFormat:@"%@/%@",Page_VoiceDetail,self.voiceID] complete:^(id result) {
        [self dismissLoadingView];
        NSDictionary * dic = (NSDictionary *)result;
        self.listenModel = [[HomeListenModel alloc]initWithDictionary:dic];
        if (self.listenModel.isFree || self.listenModel.Isbuy || [self.listenModel.promotionType integerValue] == 2) {
            self.header.checkSummy.hidden = NO;
            self.isOpen = YES;
        }else{
            self.header.checkSummy.hidden = YES;
            self.isOpen = NO;
        }
        [self.header updateWithImage:self.listenModel.thumb title:self.listenModel.name];
        [self.tabview reloadData];
        [self hiddenNullView];
    } errorBlock:^(KTError *error) {
        [self dismissLoadingView];
        [self showNullViewWithNullViewType:NullTypeNetError];
    }];
}


#pragma mark - 分享
- (void)showShareView{
    
    if (!self.listenModel) {
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"无网络，暂时无法分享" duration:1.0f];
        return;
    }
    
    ShareModel * model = [[ShareModel alloc]init];
    model.shareTitle = [NSString stringWithFormat:@"可听声度：%@",self.listenModel.name];
    model.shareDesc = self.listenModel.summary;
    UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.listenModel.thumb]]];
    model.image = image;
    model.targeturl = [NSString stringWithFormat:@"%@%@%@",Base_Url,Page_ShareVoice,self.listenModel.listenId];
    RootViewController * tbc = (RootViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    [tbc.shareView updateWithShareModel:model];
    [tbc.shareView show];
    
}
#pragma mark - 订阅按钮 / 批量下载
- (void)buyButtonClick:(UIButton *)button{
    
    if (self.isOpen) {
        CGRect frame = self.footView.frame;
        self.footView.frame = CGRectMake(frame.origin.x, UI_HEGIHT - Anno750(88) -([AVQueenManager Manager].showFoot ? Anno750(100) : 0), frame.size.width, frame.size.height);
        button.selected = !button.selected;
        self.isDownLoad = button.selected;
        NSMutableArray * muarr = [NSMutableArray new];
        for (int i = 0; i<self.listenModel.audio.count; i++) {
            NSIndexPath * index = [NSIndexPath indexPathForRow:(i+1) inSection:0];
            [muarr addObject:index];
        }
        [self.tabview reloadRowsAtIndexPaths:muarr withRowAnimation:(self.isDownLoad ? UITableViewRowAnimationLeft : UITableViewRowAnimationRight)];
        if (self.isDownLoad) {
            self.footView.hidden = NO;
            self.tabview.frame = CGRectMake(0, 64, UI_WIDTH, UI_HEGIHT - Anno750(88)- 64 -([AVQueenManager Manager].showFoot ? Anno750(100) : 0));
        }else{
            self.footView.hidden = YES;
            self.tabview.frame = CGRectMake(0, 64, UI_WIDTH, UI_HEGIHT - 64 -([AVQueenManager Manager].showFoot ? Anno750(100) : 0));
        }
    }else{
        if (![UserManager manager].isLogin) {
            LoginViewController * vc = [LoginViewController new];
            UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:vc];
            [self presentViewController:nvc animated:YES completion:nil];
        }else{
            //订阅
            [self recharge];

        }
    }
    
}
#pragma mark - 查看简介
- (void)checkVoiceSummy:(UIButton *)button{
    
    self.isOpen = !self.isOpen;
    button.selected = !button.selected;
    [self.tabview reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    
}
#pragma mark - 点赞
- (void)likeThisBookClick:(UIButton *)btn{
    if (![UserManager manager].isLogin) {
        LoginViewController * vc = [LoginViewController new];
        UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nvc animated:YES completion:nil];
    }else{
        NSDictionary * params = @{
                                  //关联1.头条、2.听书、3.声度、0.音频(音频不是栏目所以为0)
                                  @"relationType":@3,
                                  @"relationId":self.listenModel.listenId,
                                  @"nickName":[UserManager manager].info.NICKNAME
                                  };
        NSString * pageUrl = Page_AddLike;
        if (btn.selected) {
            pageUrl = Page_DelLike;
        }
        [[NetWorkManager manager] POSTRequest:params pageUrl:pageUrl complete:^(id result) {
            
            int num = [self.listenModel.praseNum intValue];
            if (btn.selected) {
                num -= 1;
            }else{
                num += 1;
            }
            [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:btn.selected ? @"取消成功":@"点赞成功" duration:1.0f];
            self.listenModel.praseNum = @(num);
            [btn setTitle:[NSString stringWithFormat:@"  %@",self.listenModel.praseNum] forState:UIControlStateNormal];
            btn.selected = !btn.selected;
        } errorBlock:^(KTError *error) {
            
        }];
    }
}

#pragma mark - 下载音频
- (void)downLoadAudio:(UIButton *)button{
    UITableViewCell * cell = (UITableViewCell *)[[button superview] superview];
    NSIndexPath * index = [self.tabview indexPathForCell:cell];
    HomeTopModel * model = self.listenModel.audio[index.row - 1];
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
    for (int i = 0; i<self.listenModel.audio.count; i++) {
        HomeTopModel * model = self.listenModel.audio[i];
        if (model.isSelectDown) {
            NSNumber * num = [[SqlManager manager] checkDownStatusWithAudioid:model.audioId];
            if ([num integerValue] == 1000) {
                [muarr addObject:model];
            }
        }
    }
    if (muarr.count == 0) {
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"请选择你要下载的音频" duration:1.0f];
        return;
    }
    AppDelegate * appdelegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdelegete.netManager.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi) {
        [[AudioDownLoader loader] downLoadAudioWithHomeTopModel:muarr];
        [self buyButtonClick:self.buyBtn];
    }else{
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您正在使用流量，是否确定下载？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cannce = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确定下载"
                                                        style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                            [[AudioDownLoader loader] downLoadAudioWithHomeTopModel:muarr];
                                                            [self buyButtonClick:self.buyBtn];
                                                        }];
        [alert addAction:cannce];
        [alert addAction:sure];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    
}
#pragma mark - 查看音频文档
- (void)checkAudioText:(UIButton *)button{
    UITableViewCell * cell = (UITableViewCell *)[button superview];
    NSIndexPath * index = [self.tabview indexPathForCell:cell];
    HomeTopModel * model = self.listenModel.audio[index.row - 1];
    WKWebViewController * vc= [[WKWebViewController alloc]init];
    vc.model = model;
    vc.isFromNav = YES;
    vc.listenID = self.listenModel.listenId;
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
        HomeTopModel * model = self.listenModel.audio[index.row - 1];
        NSDictionary * params = @{
                                  //关联1.头条、2.听书、3.声度、0.音频(音频不是栏目所以为0)
                                  @"relationType":model.relationType,
                                  @"relationId":model.relationId,
                                  @"keyId":model.audioId,
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
    
    if (!self.listenModel || !self.listenModel.audio) {
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"无网络，暂时无法分享" duration:1.0f];
        return;
    }
    
    UITableViewCell * cell = (UITableViewCell *)[[button superview] superview];
    NSIndexPath * index = [self.tabview indexPathForCell:cell];
    HomeTopModel * Audio = self.listenModel.audio[index.row - 1];
    ShareModel * model = [[ShareModel alloc]init];
    model.shareTitle = Audio.audioName;
    model.shareDesc = Audio.summary;
    UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:Audio.thumbnail]]];
    model.image = image;
    model.targeturl = [NSString stringWithFormat:@"%@%@%@/type/%@/rid/%@",Base_Url,Page_ShareAudio,Audio.audioId,Audio.relationType,self.listenModel.listenId];
    RootViewController * tbc = (RootViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    [tbc.shareView updateWithShareModel:model];
    [tbc.shareView show];
    [self hiddenToolsBar];
}
/**音频下载完成*/
- (void)audioDownLoadOver{
    if (self) {
        NSInteger index = -1 ;
        for (int i = 0; i<self.listenModel.audio.count; i++) {
            HomeTopModel * model = self.listenModel.audio[i];
            if ([[AudioDownLoader loader].currentModel.audioId integerValue] == [model.audioId integerValue]) {
                index = i;
            }
        }
        if (index == -1) {
            return;
        }
        HomeTopModel * model = self.listenModel.audio[index];
        model.downStatus = @2;
        [self.tabview reloadData];
    }
}
#pragma mark - 点击更多按钮
- (void)moreBtnClick:(UIButton *)button{
    UITableViewCell * cell = (UITableViewCell *)[button superview];
    NSIndexPath * index = [self.tabview indexPathForCell:cell];
    for (int i = 0; i<self.listenModel.audio.count; i++) {
        HomeTopModel * model = self.listenModel.audio[i];
        if (i == index.row - 1) {
            model.showTools =!model.showTools;
        }else{
            model.showTools = NO;
        }
    }
    NSMutableArray * muarr = [NSMutableArray new];
    for (int i = 0; i<self.listenModel.audio.count; i++) {
        NSIndexPath * index = [NSIndexPath indexPathForRow:( i + 1) inSection:0];
        [muarr addObject:index];
    }
    [self.tabview reloadRowsAtIndexPaths:muarr withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - 隐藏工具栏
- (void)hiddenToolsBar{
    for (int i = 0; i<self.listenModel.audio.count; i++) {
        HomeTopModel * model = self.listenModel.audio[i];
        model.showTools = NO;
    }
    NSMutableArray * muarr = [NSMutableArray new];
    for (int i = 0; i<self.listenModel.audio.count; i++) {
        NSIndexPath * index = [NSIndexPath indexPathForRow:(1 + i) inSection:0];
        [muarr addObject:index];
    }
    [self.tabview reloadRowsAtIndexPaths:muarr withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - 头部拉伸效果
//设置头部拉伸效果
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //图片高度
    CGFloat imageHeight = self.header.frame.size.height;
    //图片宽度
    CGFloat imageWidth = UI_WIDTH;
    //图片上下偏移量
    CGFloat imageOffsetY = scrollView.contentOffset.y;
    //上移
    if (imageOffsetY < 0) {
        CGFloat totalOffset = imageHeight + ABS(imageOffsetY);
        CGFloat f = totalOffset / imageHeight;
        
        self.header.groundImg.frame = CGRectMake(-(imageWidth * f - imageWidth) * 0.5, imageOffsetY, imageWidth * f, totalOffset);
    }

    
}

#pragma mark- ------内购支付------


#pragma makr- 立即充值    按钮点击事件
- (void)recharge{
    [self showLoadingCantTouchAndClear];
    RMIAPHelper *storeShared = [RMIAPHelper sharedInstance];
    storeShared.delegate = self;
    [storeShared setup];  //开始交易监听
    [storeShared buy:self.listenModel.appleStoreId];
}

#pragma mark - 充值请求失败
- (void)paymentRequestFaild{
    [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"交易请求失败" duration:1.0f];
    [self dismissLoadingView];
}

#pragma mark - RMIAPHelperdelegate
-(void)requestProduct:(RMIAPHelper*)sender start:(SKProductsRequest*)request{
    
    //    NSLog(@"start---------1发送交易请求------------");
    //    [SVProgressHUD showWithStatus:@"发送交易请求,获取产品信息" maskType:SVProgressHUDMaskTypeBlack];
    
}
-(void)requestProduct:(RMIAPHelper*)sender received:(SKProductsRequest*)request{
    //    NSLog(@"received----------2收到响应-------------");
}

- (void)paymentRequest:(RMIAPHelper*)sender start:(SKPayment*)payment{
    //    NSLog(@"startpayment----------3发送支付请求--------");
    //    [SVProgressHUD dismiss];
    
}

- (void)paymentRequest:(RMIAPHelper*)sender purchased:(SKPaymentTransaction*)transaction money:(NSString *)rechargeMoney {
    
    NSString * transactionID     = transaction.transactionIdentifier;
    NSString * paymentTime       = [self stringFromDate:transaction.transactionDate];
    
    if (rechargeMoney != nil) {
        [self verifyPruchase:transactionID time:paymentTime money:rechargeMoney];
    }
    [[RMIAPHelper sharedInstance] finishWithWithTransation:transaction];
}

- (void)paymentRequest:(RMIAPHelper*)sender restored:(SKPaymentTransaction*)transaction {
    [[RMIAPHelper sharedInstance] restore];
}

- (void)paymentRequest:(RMIAPHelper*)sender failed:(SKPaymentTransaction*)transaction {
    [[RMIAPHelper sharedInstance] finishWithWithTransation:transaction];
    [self dismissLoadingView];
}

//恢复
-(BOOL)restoredArray:(RMIAPHelper*)sender withArray:(NSArray*)productsIdArray{
    return YES;
}
//不支持内购
-(void)iapNotSupported:(RMIAPHelper*)sender{
    [self dismissLoadingView];
}


#pragma mark 验证购买凭据
- (void)verifyPruchase:(NSString *)transactionID time:(NSString *)paymentTime money:(NSString *)rechargeMoney {
    // 验证凭据，获取到苹果返回的交易凭据
    // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
    NSURL *receiptURL   = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    NSURL *url = [NSURL URLWithString:BUY_VIRIFY_RECEIPT_URL];
    // 国内访问苹果服务器比较慢，timeoutInterval需要长一点
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0f];
    request.HTTPMethod = @"POST";
    
    // 在网络中传输数据，大多情况下是传输的字符串而不是二进制数据
    // 传输的是BASE64编码的字符串
    /**
     BASE64 常用的编码方案，通常用于数据传输，以及加密算法的基础算法，传输过程中能够保证数据传输的稳定性
     BASE64是可以编码和解码的
     */
    NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    NSString *payload = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", encodeStr];
    NSData *payloadData = [payload dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody = payloadData;
    
    // 提交验证请求，并获得官方的验证JSON结果
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    // 官方验证结果为空
    if (result == nil) {
        [self dismissLoadingView];
        [ToastView presentToastWithin:[UIApplication sharedApplication].keyWindow withIcon:APToastIconNone text:@"苹果验证失败" duration:1.5];
    } else {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        NSNumber* status = [dict objectForKey:@"status"];
        NSInteger myStatus = [status integerValue];
        if (myStatus == 0) {
            //验证成功通知合肥后台充值
            [self createPayOrders:transactionID time:paymentTime money:rechargeMoney];
        } else {
            [self dismissLoadingView];
            [ToastView presentToastWithin:[UIApplication sharedApplication].keyWindow withIcon:APToastIconNone text:@"苹果验证失败" duration:1.5];
        }
    }
}
#pragma mark - 创建支付订单
- (void)createPayOrders:(NSString *)transactionID time:(NSString *)paymentTime money:(NSString *)rechargeMoney {
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    //关联1.头条、2.听书、3.声度、0.音频(音频不是栏目所以为0)
    NSDictionary * dic = @{@"relationType":@3,@"relationId":self.listenModel.listenId};
    [arr addObject:dic];
    NSData *data=[NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary * params = @{
                              @"userId":[UserManager manager].userid,
                              @"nickName":[UserManager manager].info.NICKNAME,
                              @"phone":[UserManager manager].info.MOBILE,
                              //订单类型  0 充值  1消费
                              @"orderType":@1,
                              //充值金额
                              @"payAmount":rechargeMoney,
                              //支付方式  1微信  2  余额支付
                              @"payMethod":@1,
                              //商品字符串
                              @"goodList":jsonStr,
                              //生成订单来源 0 购物车   1  直接购买
                              @"actFrom":@1
                              };
    [[NetWorkManager manager] POSTRequest:params pageUrl:Page_Order complete:^(id result) {
        OrderModel * model = [[OrderModel alloc]initWithDictionary:result];
        NSDictionary * orderParams = @{
                                       @"userId":[UserManager manager].userid,
                                       @"orderId":model.orderId,
                                       @"orderNo":model.orderNo,
                                       @"payStatus":@1
                                       };
        [[NetWorkManager manager] POSTRequest:orderParams pageUrl:Page_PayStatus complete:^(id result) {
            NSDictionary * dic = (NSDictionary *)result;
            if ([dic[@"payStatus"] integerValue] == 1) {
                [ToastView presentToastWithin:self.view.window withIcon:APToastIconNone text:@"订阅成功" duration:1.0f];
                [self getData];
            }else{
                [self dismissLoadingView];
                [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"支付失败" duration:1.0f];
            }
            
        } errorBlock:^(KTError *error) {
            [self dismissLoadingView];
            [ToastView presentToastWithin:self.view.window withIcon:APToastIconNone text:error.message duration:1.0f];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } errorBlock:^(KTError *error) {
        [self dismissLoadingView];
        [ToastView presentToastWithin:self.view.window withIcon:APToastIconNone text:error.message duration:1.0f];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
#pragma mark - 处理交易时间
- (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}

#pragma mark - 刷新cell
- (void)refreshCell{
    [self.tabview reloadData];
}


@end
