//
//  ChangePwdViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/28.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "ChangePwdViewController.h"
#import <ReactiveObjC.h>
#import "SetUserNameViewController.h"
@interface ChangePwdViewController ()

@property (nonatomic, strong) UITextField * pwdT;
@property (nonatomic, strong) UITextField * checkT;
@property (nonatomic, strong) UIButton * overBtn;

@end

@implementation ChangePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatBackGroundImg];
    [self creatUI];
    [self bindSingal];
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)creatUI{
    UIView * navView = [KTFactory creatViewWithColor:[UIColor clearColor]];
    navView.frame = CGRectMake(0, 20, UI_WIDTH, Anno750(88));
    [self.view addSubview:navView];
    
    UIButton * backBtn = [KTFactory creatButtonWithNormalImage:@"back_white" selectImage:nil];
    [backBtn addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(30)));
        make.centerY.equalTo(@0);
        make.width.equalTo(@(Anno750(64)));
        make.height.equalTo(@(Anno750(64)));
    }];
    UILabel * titleLabel = [KTFactory creatLabelWithText:@"设置密码"
                                               fontValue:font750(32)
                                               textColor:[UIColor whiteColor]
                                           textAlignment:NSTextAlignmentCenter];
    [navView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.centerX.equalTo(@0);
    }];
    
    self.pwdT = [KTFactory creattextfildWithPlaceHloder:@"输入密码"];
    self.pwdT.secureTextEntry = YES;
    [self.view addSubview:self.pwdT];
    [self.pwdT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(90)));
        make.right.equalTo(@(-Anno750(90)));
        make.height.equalTo(@(Anno750(50)));
        make.top.equalTo(navView.mas_bottom).offset(Anno750(88));
    }];
    
    UIView * lineUp = [KTFactory creatLineView];
    [self.view addSubview:lineUp];
    [lineUp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pwdT.mas_left);
        make.right.equalTo(self.pwdT.mas_right);
        make.height.equalTo(@0.5);
        make.top.equalTo(self.pwdT.mas_bottom).offset(Anno750(18));
    }];
    self.checkT = [KTFactory creattextfildWithPlaceHloder:@"确认密码"];
    self.checkT.secureTextEntry = YES;
    [self.view addSubview:self.checkT];
    [self.checkT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pwdT.mas_left);
        make.right.equalTo(self.pwdT.mas_right);
        make.height.equalTo(@(Anno750(50)));
        make.top.equalTo(lineUp.mas_bottom).offset(Anno750(28));
    }];
    UIView * lineDown = [KTFactory creatLineView];
    [self.view addSubview:lineDown];
    [lineDown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.checkT.mas_left);
        make.right.equalTo(self.checkT.mas_right);
        make.height.equalTo(@0.5);
        make.top.equalTo(self.checkT.mas_bottom).offset(Anno750(18));
    }];
    
    self.overBtn = [KTFactory creatButtonWithTitle:@"完成"
                                   backGroundColor:KTColor_IconOrange
                                         textColor:KTColor_MainBlack
                                          textSize:font750(32)];
    [self.view addSubview:self.overBtn];
    [self.overBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.checkT.mas_left);
        make.right.equalTo(self.checkT.mas_right);
        make.height.equalTo(@(Anno750(88)));
        make.top.equalTo(lineDown.mas_bottom).offset(Anno750(100));
    }];
    [self.overBtn addTarget:self action:@selector(setUserPassword) forControlEvents:UIControlEventTouchUpInside];
}
- (void)bindSingal{
    RAC(self.overBtn,enabled) = [RACSignal combineLatest:@[self.pwdT.rac_textSignal,self.checkT.rac_textSignal] reduce:^(NSString * pwd, NSString * checkPwd){
        if (pwd.length>= 6 && checkPwd.length >= 6) {
            return @1;
        }else{
            return @0;
        }
    }];
    [RACObserve(self.overBtn, enabled) subscribeNext:^(id  _Nullable x) {
        self.overBtn.backgroundColor = [x boolValue]?KTColor_IconOrange:KTColor_MainOrangeAlpha;
    }];
}

- (void)setUserPassword{
    if (![self.pwdT.text isEqualToString:self.checkT.text]) {
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"两次密码输入不一致，请重新输入" duration:1.0f];
        return;
    }
    [self showLoadingCantTouchAndClear];
    NSDictionary * params = @{
                              @"mobileEmail":self.phoneNum,
                              @"password":self.pwdT.text
                              };
    [[NetWorkManager manager] POSTRequest:params pageUrl:Page_Register complete:^(id result) {
        [self dismissLoadingView];
        [[UserManager manager] userLoginWithInfoDic:result];
        [UserManager manager].userid = [UserManager manager].info.USERID;
        [ToastView presentToastWithin:self.view.window withIcon:APToastIconNone text:@"注册成功" duration:2.0f];
        [self.navigationController pushViewController:[SetUserNameViewController new] animated:YES];
    } errorBlock:^(KTError *error) {
        [self dismissLoadingView];
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:error.message duration:1.0f];
    }];
}


@end
