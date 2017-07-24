//
//  ChangePhoneViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/5.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "ChangePhoneViewController.h"
#import "CheckPhoneViewController.h"
@interface ChangePhoneViewController ()

@end

@implementation ChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavUnAlpha];
    [self drawBackButtonWithType:BackImgTypeBlack];
    [self setNavTitle:@"更换手机号" color:KTColor_MainBlack];
    [self creatUI];
}
- (void)creatUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView * view = [KTFactory creatViewWithColor:KTColor_BackGround];
    view.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(30));
    [self.view addSubview:view];
    
    UIImageView * phoneImg = [KTFactory creatImageViewWithImage:@"Mobile phone"];
    [self.view addSubview:phoneImg];
    [phoneImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(view.mas_bottom).offset(Anno750(80));
    }];
    NSMutableString * phoneNumber = [NSMutableString stringWithFormat:@"%@",[UserManager manager].info.MOBILE];
    [phoneNumber replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    UILabel * title = [KTFactory creatLabelWithText:[NSString stringWithFormat:@"您当前的手机号码为%@",phoneNumber]
                                          fontValue:font750(28)
                                          textColor:KTColor_MainBlack
                                      textAlignment:NSTextAlignmentLeft];
    UILabel * desc = [KTFactory creatLabelWithText:@"更换后个人信息不变，下次需使用新手机号登录"
                                         fontValue:font750(24)
                                         textColor:KTColor_darkGray
                                     textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:title];
    [self.view addSubview:desc];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(phoneImg.mas_bottom).offset(Anno750(20));
    }];
    [desc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(title.mas_bottom).offset(Anno750(15));
    }];
    UIButton * changeBtn = [KTFactory creatButtonWithTitle:@"更换手机号"
                                           backGroundColor:[UIColor clearColor]
                                                 textColor:KTColor_MainOrange
                                                  textSize:font750(32)];
    [changeBtn addTarget:self action:@selector(pushToChangePhoneViewController) forControlEvents:UIControlEventTouchUpInside];
    changeBtn.layer.borderColor = KTColor_MainOrange.CGColor;
    changeBtn.layer.borderWidth = 0.5;
    changeBtn.layer.cornerRadius = 4.0f;
    [self.view addSubview:changeBtn];
    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(30)));
        make.right.equalTo(@(Anno750(-30)));
        make.height.equalTo(@(Anno750(90)));
        make.top.equalTo(desc.mas_bottom).offset(Anno750(90));
    }];
    
}
- (void)pushToChangePhoneViewController{
    [self.navigationController pushViewController:[CheckPhoneViewController new] animated:YES];
}


@end
