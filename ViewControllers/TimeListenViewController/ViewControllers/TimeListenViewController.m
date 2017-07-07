//
//  TimeListenViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/13.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "TimeListenViewController.h"

@interface TimeListenViewController ()

@property (nonatomic, strong) UIImageView * userIcon;
@property (nonatomic, strong) UILabel * userName;
@property (nonatomic, strong) UILabel * descLabel;
@property (nonatomic, strong) UIButton * threeBtn;
@property (nonatomic, strong) UIButton * tenBtn;
@property (nonatomic, strong) UIButton * fourBtn;
@property (nonatomic, strong) UIButton * hourBtn;

@end

@implementation TimeListenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatui];
}
- (void)creatui{
    self.userIcon = [KTFactory creatImageViewWithImage:@""];
    
    self.userIcon.layer.cornerRadius = Anno750(60);
    self.userIcon.layer.masksToBounds = YES;
    self.userName = [KTFactory creatLabelWithText:@"天才你好"
                                        fontValue:font750(28)
                                        textColor:KTColor_darkGray
                                    textAlignment:NSTextAlignmentCenter];
    self.descLabel = [KTFactory creatLabelWithText:@"此刻，这里的时间由你决定"
                                         fontValue:font750(36)
                                         textColor:KTColor_lightGray
                                     textAlignment:NSTextAlignmentCenter];
    self.threeBtn = [KTFactory creatButtonWithNormalImage:@"listening_30" selectImage:nil];
    self.tenBtn = [KTFactory creatButtonWithNormalImage:@"listening_15" selectImage:nil];
    self.fourBtn = [KTFactory creatButtonWithNormalImage:@"listening_45" selectImage:nil];
    self.hourBtn = [KTFactory creatButtonWithNormalImage:@"listening_1H" selectImage:nil];
    
    [self.view addSubview:self.userIcon];
    [self.view addSubview:self.userName];
    [self.view addSubview:self.descLabel];
    [self.view addSubview:self.threeBtn];
    [self.view addSubview:self.tenBtn];
    [self.view addSubview:self.fourBtn];
    [self.view addSubview:self.hourBtn];
    
    [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(Anno750(100)));
        make.centerX.equalTo(@0);
        make.height.equalTo(@(Anno750(120)));
        make.width.equalTo(@(Anno750(120)));
    }];
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userIcon.mas_bottom).offset(Anno750(20));
        make.centerX.equalTo(@0);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.userName.mas_bottom).offset(Anno750(110));
    }];
    [self.threeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.descLabel.mas_bottom).offset(Anno750(60));
        make.width.equalTo(@(Anno750(226)));
        make.height.equalTo(@(Anno750(226)));
    }];
    [self.fourBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.threeBtn.mas_bottom).offset(Anno750(72));
        make.height.equalTo(@(Anno750(176)));
        make.width.equalTo(@(Anno750(176)));
    }];
    [self.tenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.fourBtn.mas_left).offset(Anno750(-80));
        make.centerY.equalTo(self.fourBtn.mas_centerY);
        make.height.equalTo(@(Anno750(176)));
        make.width.equalTo(@(Anno750(176)));
    }];
    [self.hourBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fourBtn.mas_right).offset(Anno750(80));
        make.centerY.equalTo(self.fourBtn.mas_centerY);
        make.height.equalTo(@(Anno750(176)));
        make.width.equalTo(@(Anno750(176)));
    }];
}

@end
