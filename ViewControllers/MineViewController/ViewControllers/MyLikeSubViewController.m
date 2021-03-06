//
//  MyLikeSubViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/3.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "MyLikeSubViewController.h"
#import "HistoryListCell.h"
#import "HomeListenModel.h"
#import "HomeTopModel.h"
#import "HomeVoiceCell.h"
#import "ListenListCell.h"
//#import "AudioPlayerViewController.h"
#import "ListenDetailViewController.h"
#import "VoiceDetailViewController.h"

@interface MyLikeSubViewController ()<UITableViewDelegate,UITableViewDataSource>

//@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation MyLikeSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self getData];
    [self checkNetStatus];
}
- (void)creatUI{
    
    self.dataArray = [NSMutableArray new];
    self.tabview = [KTFactory creatTabviewWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT - Anno750(90)- 64) style:UITableViewStyleGrouped];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Anno750(30);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.subType == LIKESUBTYPETOPLIST) {
        return Anno750(160);
    }else if(self.subType == LIKESUBTYPEBUY){
        return Anno750(190);
    }else{
        return Anno750(250);
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [KTFactory creatViewWithColor:KTColor_BackGround];
    view.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(30));
    return view;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.subType == LIKESUBTYPETOPLIST) {
        static NSString * cellid = @"HistoryListCell";
        HistoryListCell * cell = [tableView  dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[HistoryListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        [cell updateWithHistoryModel:self.dataArray[indexPath.row]];
        return cell;
    }else if(self.subType == LIKESUBTYPEBOOK){
        static NSString * cellid = @"ListenListCell";
        ListenListCell * cell = [tableView  dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[ListenListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        [cell updateWithListenModel:self.dataArray[indexPath.row]];
        cell.shopCar.hidden = YES;
        cell.buybtn.hidden = YES;
        return cell;
    }else{
        static NSString * cellid = @"HomeVoiceCell";
        HomeVoiceCell * cell = [tableView  dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[HomeVoiceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        cell.updateTime.hidden = NO;
        [cell updateWithVoiceModel:self.dataArray[indexPath.row]];
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.subType == LIKESUBTYPEBOOK) {
        HomeListenModel * model = self.dataArray[indexPath.row];
        ListenDetailViewController * vc = [[ListenDetailViewController alloc]init];
        vc.listenID = model.listenId;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(self.subType == LIKESUBTYPEBUY){
        HomeListenModel * model = self.dataArray[indexPath.row];
        VoiceDetailViewController * vc = [[VoiceDetailViewController alloc]init];
        vc.voiceID = model.listenId;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [[AudioPlayer instance] audioPlay:self.dataArray[indexPath.row]];
        [AudioPlayer instance].playList = self.dataArray;
        [self reloadTabviewFrame];
//        AudioPlayerViewController * audioVC = [AudioPlayerViewController new];
//        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:audioVC];
//        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)getData{
    [self showLoadingCantTouchAndClear];
    NSDictionary * pamrams = @{
                               @"userId":[UserManager manager].userid,
                               @"logType":@0,
                               @"relationType":@(self.subType + 1),
                               };
    [[NetWorkManager manager] GETRequest:pamrams pageUrl:Page_Liked complete:^(id result) {
        [self dismissLoadingView];
        NSArray * arr = (NSArray *)result;
        if (arr.count == 0) {
            [self showNullViewWithNullViewType:NullTypeNoneLike];
        }else{
            [self hiddenNullView];
            for (int i = 0; i<arr.count; i++) {
                if (self.subType == LIKESUBTYPETOPLIST) {
                    HomeTopModel * model = [[HomeTopModel alloc]initWithDictionary:arr[i]];
                    [self.dataArray addObject:model];
                }else{
                    HomeListenModel * model = [[HomeListenModel alloc]initWithDictionary:arr[i]];
                    [self.dataArray addObject:model];
                }
            }
            [self.tabview reloadData];
        }
    } errorBlock:^(KTError *error) {
        [self dismissLoadingView];
    }];
}


@end
