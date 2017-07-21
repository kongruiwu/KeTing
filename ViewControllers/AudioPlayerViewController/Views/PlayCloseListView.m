//
//  PlayCloseListView.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/12.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "PlayCloseListView.h"
#import "CloseListCell.h"
#import "AudioPlayer.h"
@implementation PlayCloseListView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    self.hidden = YES;
    self.backgroundColor = [UIColor clearColor];
    
    UIButton * disBtn = [KTFactory creatButtonWithNormalImage:@"" selectImage:@""];
    [disBtn addTarget:self action:@selector(disMiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:disBtn];
    disBtn.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(660));
    
    self.chosseArray = @[@"30分钟",@"60分钟",@"90分钟",@"播完当前音频再关闭",@"关闭倒计时"];
    
    self.tabview = [KTFactory creatTabviewWithFrame:CGRectMake(0, UI_HEGIHT, UI_WIDTH,Anno750(660)) style:UITableViewStylePlain];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self addSubview:self.tabview];
    self.tabview.bounces = NO;
    [self creatTabviewFooter];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.chosseArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Anno750(108);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * str = @"";
    if (indexPath.row == 0) {
        [AudioPlayer instance].closeTime = CloseTime30min;
        str = @"设置成功,将于30分钟关闭";
    }else if(indexPath.row == 1){
        [AudioPlayer instance].closeTime = CloseTime60min;
        str = @"设置成功,将于60分钟关闭";
    }else if(indexPath.row == 2){
        [AudioPlayer instance].closeTime = CloseTime90min;
        str = @"设置成功,将于90分钟关闭";
    }else if(indexPath.row == 3){
        [AudioPlayer instance].closeTime = CloseTimeThisAudio;
        str = @"设置成功,当前音频播放完成后关闭";
    }else if(indexPath.row ==4){
        [AudioPlayer instance].closeTime = CloseTimeNone;
        if ([AudioPlayer instance].closeTime &&[AudioPlayer instance].closeTime != CloseTimeNone) {
            str = @"设置成功,定时已关闭";
        }
    }
    if (str.length >0) {
        [ToastView presentToastWithin:[UIApplication sharedApplication].keyWindow withIcon:APToastIconNone text:str duration:2.0f];
    }
    [self disMiss];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellid = @"colseList";
    CloseListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[CloseListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.choselabel.text = self.chosseArray[indexPath.row];
    return cell;
}
- (void)creatTabviewFooter{
    UIView * footer = [KTFactory creatViewWithColor:[UIColor whiteColor]];
    footer.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(120));
    
    UIView * grayView = [KTFactory creatViewWithColor:Audio_progessWhite];
    [footer addSubview:grayView];
    
    UIButton * cannceBtn = [KTFactory creatButtonWithTitle:@"取消"
                                     backGroundColor:[UIColor clearColor]
                                           textColor:KTColor_lightGray
                                            textSize:font750(30)];
    [footer addSubview:cannceBtn];
    grayView.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(20));
    cannceBtn.frame = CGRectMake(0, Anno750(20), UI_WIDTH, Anno750(100));
    [cannceBtn addTarget:self action:@selector(disMiss) forControlEvents:UIControlEventTouchUpInside];
    self.tabview.tableFooterView = footer;
}
- (void)show{
    self.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.backgroundColor = UIColorFromRGBA(0x000000, 0.5);
        self.tabview.frame = CGRectMake(0, UI_HEGIHT - Anno750(660), UI_WIDTH, Anno750(660));
    }];
    
}
- (void)disMiss{
    [UIView animateWithDuration:0.5 animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.tabview.frame = CGRectMake(0, UI_HEGIHT, UI_WIDTH, Anno750(660));
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
    });
}


@end
