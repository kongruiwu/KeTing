//
//  VoiceDetailViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/12.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "VoiceDetailViewController.h"
#import "VoiceDetailHeader.h"
#import "ShareView.h"
#import "VoiceSummaryCell.h"
#import "VoiceUpdateListCell.h"
#import "HomeListenModel.h"
#import "VoiceSectionCell.h"
#import "TopListCell.h"
#import "TopListDownCell.h"
#import "TopListBottomView.h"
#import "AudioPlayerViewController.h"
@interface VoiceDetailViewController ()<UITableViewDelegate,UITableViewDataSource,TopListCellDelegate>

@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) ShareView * shareView;
@property (nonatomic, strong) HomeListenModel * listenModel;
@property (nonatomic, strong) VoiceDetailHeader * header;
/**是否是下载界面*/
@property (nonatomic, assign) BOOL isDownLoad;
/**已购买界面是否展开简介等栏目*/
@property (nonatomic, assign) BOOL isOpen;
/**下载状态下的 下载footer*/
@property (nonatomic, strong) TopListBottomView * footView;
@end

@implementation VoiceDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIView * clearView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, 20)];
    [self.view addSubview:clearView];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self getData];
}

- (void)creatUI{
    self.isDownLoad = NO;
    self.isOpen = YES;
    self.tabview = [KTFactory creatTabviewWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT) style:UITableViewStylePlain];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
    
    self.footView = [[TopListBottomView alloc]init];
    self.footView.hidden = YES;
    [self.view addSubview:self.footView];
    [self.footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.height.equalTo(@(Anno750(88)));
    }];
    
    self.header  = [[VoiceDetailHeader alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, Anno750(485))];
    [self.header.backBtn addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    [self.header.shareBtn addTarget:self action:@selector(showShareView) forControlEvents:UIControlEventTouchUpInside];
    [self.header.checkSummy addTarget:self action:@selector(checkVoiceSummy:) forControlEvents:UIControlEventTouchUpInside];
    self.tabview.tableHeaderView = self.header;
    
    self.shareView = [[ShareView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT) hasNav:NO];
    [self.view addSubview:self.shareView];
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
    
    
    UIButton * buyBtn = [KTFactory creatButtonWithTitle:[NSString stringWithFormat:@"订阅：%@",self.listenModel.timePrice ? self.listenModel.timePrice:@0.00]
                                        backGroundColor:KTColor_MainOrange
                                              textColor:[UIColor whiteColor]
                                               textSize:font750(30)];
    buyBtn.layer.borderColor = KTColor_MainOrange.CGColor;
    buyBtn.layer.borderWidth = 1.0f;
    buyBtn.layer.cornerRadius = 4.0f;
    
    if (self.listenModel.Isbuy) {
        [buyBtn setTitle:@"  批量下载" forState:UIControlStateNormal];
        [buyBtn setTitleColor:KTColor_MainOrange forState:UIControlStateNormal];
        [buyBtn setImage:[UIImage imageNamed:@"finance_download"] forState:UIControlStateNormal];
    }
    [buyBtn setTitle:@"  取消下载" forState:UIControlStateSelected];
    [buyBtn setTitleColor:KTColor_MainOrange forState:UIControlStateSelected];
    [buyBtn setImage:[UIImage imageNamed:@"finance_ close"] forState:UIControlStateSelected];
    
    
    buyBtn.backgroundColor = self.listenModel.Isbuy ? [UIColor clearColor] : KTColor_MainOrange;
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
    return Anno750(120);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listenModel.Isbuy ? 1 + 2 *(self.listenModel.audio.count + 1) : self.listenModel.audio.count + 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if (!self.isOpen) {
            return 0;
        }
        CGSize size = [KTFactory getSize:[KTFactory changeHtmlString:self.listenModel.descString withFont:font750(28)] maxSize:CGSizeMake(font750(702), 99999)];
        return Anno750(80)+ size.height;
    }else if(indexPath.row == 1 || indexPath.row == self.listenModel.audio.count + 2){
        return (indexPath.row == 1 && self.isOpen) || (indexPath.row == self.listenModel.audio.count + 2) ? Anno750(80) : 0;
    }else if(indexPath.row > 1 && indexPath.row < self.listenModel.audio.count + 2){
        return self.isOpen ? Anno750(175) : 0;
    }else{
        int index =(int)(indexPath.row - self.listenModel.audio.count - 3);
        HomeTopModel * model = self.listenModel.audio[index];
        CGSize size = [KTFactory getSize:model.audioName maxSize:CGSizeMake(Anno750(646), 9999) font:[UIFont systemFontOfSize:font750(30)]];
        return Anno750(96) + size.height;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        static NSString * cellid = @"summaryCell";
        VoiceSummaryCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[VoiceSummaryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        if (self.isOpen) {
            [cell updateWithDescString:self.listenModel.descString count:self.listenModel.orderNum];
        }
        cell.hidden = !self.isOpen;
        return cell;
    }else if(indexPath.row == 1 || indexPath.row == self.listenModel.audio.count + 2){
            static NSString * cellid = @"sectionCell";
            VoiceSectionCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[VoiceSectionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }
            if (indexPath.row == 1) {
                if (self.isOpen) {
                    [cell updateWithName:@"最近更新" color:KTColor_MainBlack font:font750(32)];
                }
                cell.hidden = !self.isOpen;
            }else{
                [cell updateWithName:[NSString stringWithFormat:@"已更新%ld条音频",self.listenModel.audio.count] color:KTColor_lightGray font:font750(26)];
            }
            return cell;
    }else if(indexPath.row > 1 && indexPath.row < self.listenModel.audio.count + 2){
        static NSString * cellid = @"updateCell";
        VoiceUpdateListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[VoiceUpdateListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        if (self.isOpen) {
            [cell updateWithHomeListenModel:self.listenModel.audio[indexPath.row - 2]];
        }
        cell.hidden = !self.isOpen;
        return cell;
    }else{
        
        if (self.isDownLoad) {
            static NSString * cellid = @"TopListDown";
            TopListDownCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[TopListDownCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }
            [cell updateWithHomeTopModel:self.listenModel.audio[indexPath.row - self.listenModel.audio.count - 3]];
            return cell;
        }else{
            static NSString * cellid = @"topListCell";
            TopListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[TopListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }
            [cell updateWithHomeTopModel:self.self.listenModel.audio[indexPath.row - self.listenModel.audio.count - 3]];
            cell.delegate =self;
            return cell;
        }
        
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > self.listenModel.audio.count + 2) {
        HomeTopModel * model = self.listenModel.audio[indexPath.row - self.listenModel.audio.count - 3];
        if (self.isDownLoad) {
            //下载选择
            model.isSelectDown = !model.isSelectDown;
            [self.footView updateWithArrays:self.listenModel.audio];
            [self.tabview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }else{
            [self hiddenToolsBar];
            //进入音乐播放器
            [AudioPlayer instance].currentAudio = model;
            [AudioPlayer instance].playList = [NSMutableArray arrayWithArray:self.listenModel.audio];
            AudioPlayerViewController * audioVC = [AudioPlayerViewController new];
            UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:audioVC];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
    
}
- (void)getData{
    [[NetWorkManager manager] GETRequest:@{} pageUrl:[NSString stringWithFormat:@"%@/%@",Page_VoiceDetail,self.voiceID] complete:^(id result) {
        NSDictionary * dic = (NSDictionary *)result;
        self.listenModel = [[HomeListenModel alloc]initWithDictionary:dic];
        [self.header updateWithImage:self.listenModel.thumb title:self.listenModel.name];
        self.isOpen = self.header.checkSummy.hidden = !self.listenModel.Isbuy;
        [self.tabview reloadData];
    } errorBlock:^(KTError *error) {
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:error.message duration:2.0f];
    }];
}
#pragma mark - 分享
- (void)showShareView{
    [self.shareView show];
}
#pragma mark - 订阅按钮
- (void)buyButtonClick:(UIButton *)button{
    if (self.listenModel.Isbuy) {
        button.selected = !button.selected;
        self.isDownLoad = button.selected;
        NSMutableArray * muarr = [NSMutableArray new];
        for (int i = 0; i<self.listenModel.audio.count; i++) {
            NSIndexPath * index = [NSIndexPath indexPathForRow:(self.listenModel.audio.count + 3 + i) inSection:0];
            [muarr addObject:index];
        }
        [self.tabview reloadRowsAtIndexPaths:muarr withRowAnimation:(self.isDownLoad ? UITableViewRowAnimationLeft : UITableViewRowAnimationRight)];
        if (self.isDownLoad) {
            self.footView.hidden = NO;
            self.tabview.frame = CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT - Anno750(88));
        }else{
            self.footView.hidden = YES;
            self.tabview.frame = CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT);
        }
    }else{
        //订阅
        
    }
}
#pragma mark - 查看简介
- (void)checkVoiceSummy:(UIButton *)button{
    button.selected = !button.selected;
    self.isOpen = button.selected;
    NSMutableArray * muarr = [[NSMutableArray alloc]init];
    for (int i = 0; i<self.listenModel.audio.count + 3;i++ ) {
        NSIndexPath * index = [NSIndexPath indexPathForRow:i inSection:0];
        [muarr addObject:index];
    }
    [self.tabview reloadRowsAtIndexPaths:muarr withRowAnimation:(self.isOpen ? UITableViewRowAnimationTop :UITableViewRowAnimationBottom)];
    
}
#pragma mark - 点赞
- (void)likeThisBookClick:(UIButton *)btn{
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
        self.listenModel.praseNum = @(num);
        [btn setTitle:[NSString stringWithFormat:@"  %@",self.listenModel.praseNum] forState:UIControlStateNormal];
        btn.selected = !btn.selected;
    } errorBlock:^(KTError *error) {
        
    }];
}
#pragma mark - 点击更多按钮
- (void)moreBtnClick:(UIButton *)button{
    UITableViewCell * cell = (UITableViewCell *)[button superview];
    NSIndexPath * index = [self.tabview indexPathForCell:cell];
    for (int i = 0; i<self.listenModel.audio.count; i++) {
        HomeTopModel * model = self.listenModel.audio[i];
        if (i == index.row - self.listenModel.audio.count - 3) {
            model.showTools =!model.showTools;
        }else{
            model.showTools = NO;
        }
    }
    NSMutableArray * muarr = [NSMutableArray new];
    for (int i = 0; i<self.listenModel.audio.count; i++) {
        NSIndexPath * index = [NSIndexPath indexPathForRow:(self.listenModel.audio.count + 3 + i) inSection:0];
        [muarr addObject:index];
    }
    [self.tabview reloadRowsAtIndexPaths:muarr withRowAnimation:UITableViewRowAnimationNone];
}
- (void)hiddenToolsBar{
    for (int i = 0; i<self.listenModel.audio.count; i++) {
        HomeTopModel * model = self.listenModel.audio[i];
        model.showTools = NO;
    }
    NSMutableArray * muarr = [NSMutableArray new];
    for (int i = 0; i<self.listenModel.audio.count; i++) {
        NSIndexPath * index = [NSIndexPath indexPathForRow:(self.listenModel.audio.count + 3 + i) inSection:0];
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

@end
