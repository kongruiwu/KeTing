//
//  PushSettingViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/4.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "PushSettingViewController.h"
#import "WI-FISettingCell.h"
#import "PushSettingCell.h"
@interface PushSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) NSArray * titles;

@end

@implementation PushSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavUnAlpha];
    [self drawBackButtonWithType:BackImgTypeBlack];
    [self setNavTitle:@"推送消息设置" color:KTColor_MainBlack];
    [self creatUI];
}
- (void)creatUI{
    
    self.titles = @[@"开启后，将收到精选的内容推送和活动通知",@"开启后，专栏更新时会及时收到通知消息"];
    
    self.tabview = [KTFactory creatTabviewWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT - 64) style:UITableViewStyleGrouped];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return Anno750(160);
    }
    return Anno750(120);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return Anno750(30);
    }
    return Anno750(80);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * header = [KTFactory creatViewWithColor:KTColor_BackGround];
    
    if (section == 0) {
        header.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(30));
    }else{
        header.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(80));
        NSString * title = @"运营类消息";
        if(section == 2){
            title = @"专栏更新消息";
        }
        UILabel * titleLabel = [KTFactory creatLabelWithText:title
                                         fontValue:font750(26)
                                         textColor:KTColor_darkGray
                                     textAlignment:NSTextAlignmentLeft];
        [header addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(Anno750(24)));
            make.centerY.equalTo(@0);
        }];
    }
    return header;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString * cellid = @"PushSettingCell";
        PushSettingCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[PushSettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        return cell;
    }
    static NSString * cellid = @"WI-FISettingCell";
    WI_FISettingCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[WI_FISettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    [cell updateWithTitle:@"接收新消息通知" desc:self.titles[indexPath.section -1] isOpen:NO];
    return cell;
}


@end
