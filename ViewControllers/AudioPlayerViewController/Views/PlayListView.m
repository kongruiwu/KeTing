//
//  PlayListView.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/12.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "PlayListView.h"

@implementation PlayListView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    UIButton * cannceBtn = [KTFactory creatButtonWithNormalImage:@"" selectImage:@""];
    cannceBtn.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(390));
    cannceBtn.backgroundColor = [UIColor clearColor];
    [self addSubview:cannceBtn];
    [cannceBtn addTarget:self action:@selector(disMiss) forControlEvents:UIControlEventTouchUpInside];
    
    self.hidden = YES;
    
    self.showView = [KTFactory creatViewWithColor:[UIColor whiteColor]];
    self.showView.frame = CGRectMake(0, UI_HEGIHT, UI_WIDTH, UI_HEGIHT - Anno750(390));
    [self addSubview:self.showView];
    
    UIView * headView = [KTFactory creatViewWithColor:[UIColor whiteColor]];
    headView.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(100));
    UILabel * label = [KTFactory creatLabelWithText:[NSString stringWithFormat:@"播放列表  （%ld首）",[AudioPlayer instance].playList.count]
                                          fontValue:font750(32)
                                          textColor:KTColor_MainBlack
                                      textAlignment:NSTextAlignmentLeft];
    [headView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.centerY.equalTo(@0);
    }];
    [self.showView addSubview:headView];
    
    UIView * bottomView = [KTFactory creatViewWithColor:[UIColor whiteColor]];
    bottomView.frame = CGRectMake(0, self.showView.frame.size.height - Anno750(100), UI_WIDTH, Anno750(100));
    UIView * groundView = [KTFactory creatLineView];
    UIButton * disBtn = [KTFactory creatButtonWithTitle:@"取消"
                                        backGroundColor:[UIColor clearColor]
                                              textColor:KTColor_lightGray
                                               textSize:font750(30)];
    [bottomView addSubview:groundView];
    [bottomView addSubview:disBtn];
    [disBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.height.equalTo(@(Anno750(100)));
    }];
    [groundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    [disBtn addTarget:self action:@selector(disMiss) forControlEvents:UIControlEventTouchUpInside];
    [self.showView addSubview:bottomView];
    
    self.tabview = [KTFactory creatTabviewWithFrame:CGRectMake(0, Anno750(100), UI_WIDTH,self.showView.frame.size.height - Anno750(200)) style:UITableViewStylePlain];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.showView addSubview:self.tabview];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [AudioPlayer instance].playList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeTopModel * model = [AudioPlayer instance].playList[indexPath.row];
    CGSize size = [KTFactory getSize:model.audioName maxSize:CGSizeMake(Anno750(702), 99999) font:[UIFont systemFontOfSize:font750(30)]];
    return Anno750(74) + size.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellid = @"PlayListcell";
    PlayListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[PlayListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    [cell updateWithHomeTopModel:[AudioPlayer instance].playList[indexPath.row]];
    return cell;
}
- (void)show{
    self.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.backgroundColor = UIColorFromRGBA(0x000000, 0.5);
        self.showView.frame = CGRectMake(0, Anno750(390), UI_WIDTH, UI_HEGIHT - Anno750(390));
    }];
    
}
- (void)disMiss{
    [UIView animateWithDuration:0.5 animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.showView.frame = CGRectMake(0, UI_HEGIHT, UI_WIDTH, UI_HEGIHT - Anno750(390));
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
    });
}
@end
