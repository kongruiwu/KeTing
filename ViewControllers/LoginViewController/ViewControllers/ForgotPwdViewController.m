//
//  ForgotPwdViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/27.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "ForgotPwdViewController.h"
#import "ChangePwdViewController.h"
#import <ReactiveObjC.h>
@interface ForgotPwdViewController ()

@property (nonatomic, strong) UITextField * phoneTF;
@property (nonatomic, strong) UITextField * codeTF;
@property (nonatomic, strong) UIButton * nextBtn;
@property (nonatomic, strong) UIButton * getCode;

@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, assign) int time;


@end

@implementation ForgotPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatBackGroundImg];
    [self creatUI];
    [self bindSignal];
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)creatUI{
    self.time = 60;
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
    UILabel * titleLabel = [KTFactory creatLabelWithText:@"忘记密码"
                                               fontValue:font750(32)
                                               textColor:[UIColor whiteColor]
                                           textAlignment:NSTextAlignmentCenter];
    [navView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.centerX.equalTo(@0);
    }];

    UILabel * messageLabel = [KTFactory creatLabelWithText:@"输入您的手机号并重置密码"
                                                 fontValue:font750(30)
                                                 textColor:UIColorFromRGB(0xcdc7e9)
                                             textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:messageLabel];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navView.mas_bottom).offset(Anno750(100));
        make.centerX.equalTo(@0);
    }];
    
    UILabel * numLabel = [KTFactory creatLabelWithText:@"+86"
                                          fontValue:font750(30)
                                          textColor:KTColor_MainOrange
                                      textAlignment:NSTextAlignmentLeft];
    UIView * line = [KTFactory creatLineView];
    [numLabel addSubview:line];
    numLabel.frame = CGRectMake(0, 0, Anno750(105), Anno750(40));
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
        make.width.equalTo(@0.5);
        make.right.equalTo(@(-Anno750(20)));
    }];
    self.phoneTF = [KTFactory creattextfildWithPlaceHloder:@"手机号"];
    self.phoneTF.leftViewMode = UITextFieldViewModeAlways;
    self.phoneTF.leftView = numLabel;
    [self.view addSubview:self.phoneTF];
    [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(90)));
        make.right.equalTo(@(-Anno750(90)));
        make.height.equalTo(@(Anno750(50)));
        make.top.equalTo(messageLabel.mas_bottom).offset(Anno750(88));
    }];
    self.getCode = [KTFactory creatButtonWithTitle:@"获取验证码"
                                   backGroundColor:[UIColor clearColor]
                                         textColor:KTColor_MainOrange
                                          textSize:font750(24)];
    [self.getCode setTitleColor:KTColor_lightGray forState:UIControlStateDisabled];
    [self.getCode addTarget:self action:@selector(getCodeRequest) forControlEvents:UIControlEventTouchUpInside];
    self.getCode.frame = CGRectMake(0, 0, Anno750(190), Anno750(50));
    self.getCode.layer.borderWidth = 1.0f;
    self.getCode.layer.cornerRadius = 2.0f;
    self.phoneTF.rightView = self.getCode;
    self.phoneTF.rightViewMode = UITextFieldViewModeAlways;
    
    UIView * lineUp = [KTFactory creatLineView];
    [self.view addSubview:lineUp];
    [lineUp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneTF.mas_left);
        make.right.equalTo(self.phoneTF.mas_right);
        make.height.equalTo(@0.5);
        make.top.equalTo(self.phoneTF.mas_bottom).offset(Anno750(18));
    }];
    self.codeTF = [KTFactory creattextfildWithPlaceHloder:@"验证码"];
    [self.view addSubview:self.codeTF];
    [self.codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneTF.mas_left);
        make.right.equalTo(self.phoneTF.mas_right);
        make.height.equalTo(@(Anno750(50)));
        make.top.equalTo(lineUp.mas_bottom).offset(Anno750(28));
    }];
    UIView * lineDown = [KTFactory creatLineView];
    [self.view addSubview:lineDown];
    [lineDown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneTF.mas_left);
        make.right.equalTo(self.phoneTF.mas_right);
        make.height.equalTo(@0.5);
        make.top.equalTo(self.codeTF.mas_bottom).offset(Anno750(18));
    }];
    
    self.nextBtn = [KTFactory creatButtonWithTitle:@"下一步"
                                    backGroundColor:KTColor_IconOrange
                                          textColor:KTColor_MainBlack
                                           textSize:font750(32)];
    [self.view addSubview:self.nextBtn];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneTF.mas_left);
        make.right.equalTo(self.phoneTF.mas_right);
        make.height.equalTo(@(Anno750(88)));
        make.top.equalTo(lineDown.mas_bottom).offset(Anno750(100));
    }];
    [self.nextBtn addTarget:self action:@selector(pushToNextViewController) forControlEvents:UIControlEventTouchUpInside];
}
- (void)bindSignal{
    RAC(self.getCode,enabled) = [RACSignal combineLatest:@[self.phoneTF.rac_textSignal] reduce:^(NSString * phone){
        if (self.time == 60) {
            return [NSNumber numberWithBool:phone.length>=11];
        }else{
            return @0;
        }
    }];
    [RACObserve(self.getCode, enabled) subscribeNext:^(id  _Nullable x) {
        self.getCode.layer.borderColor = [x boolValue] ? KTColor_MainOrange.CGColor : KTColor_lightGray.CGColor;
    }];
    
    RAC(self.nextBtn,enabled) = [RACSignal combineLatest:@[self.phoneTF.rac_textSignal, self.codeTF.rac_textSignal] reduce:^(NSString * phone, NSString * code){
        if (phone.length>=11 && code.length>=4) {
            return @1;
        }else{
            return @0;
        }
    }];
    [RACObserve(self.nextBtn, enabled) subscribeNext:^(id  _Nullable x) {
        self.nextBtn.backgroundColor = [x boolValue]?KTColor_IconOrange:KTColor_MainOrangeAlpha;
    }];
}


#pragma mark - 验证验证码
- (void)pushToNextViewController{
    [self showLoadingCantTouchAndClear];
    NSDictionary * params = @{
                              @"mobile":self.phoneTF.text,
                              @"code":self.codeTF.text
                              };
    [[NetWorkManager manager] POSTRequest:params pageUrl:Page_CheckCode complete:^(id result) {
        [self dismissLoadingView];
        NSDictionary * dic = (NSDictionary *)result;
        if (dic[@"SUCCESS"] && [dic[@"SUCCESS"] intValue] != 0) {
            ChangePwdViewController * vc = [ChangePwdViewController new];
            vc.phoneNum = self.phoneTF.text;
            vc.isChange = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"验证码错误，请重新输入" duration:1.0f];
        }
    } errorBlock:^(KTError *error) {
        [self dismissLoadingView];
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:error.message duration:1.0f];
    }];
    
}
#pragma mark - 获取验证码
- (void)getCodeRequest{
    [self showLoadingCantTouchAndClear];
    self.getCode.enabled = NO;
    NSDictionary * params = @{
                              @"mobile":self.phoneTF.text
                              };
    [[NetWorkManager manager] POSTRequest:params pageUrl:Page_SendCode complete:^(id result) {
        [self dismissLoadingView];
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"验证码已发至您的手机，请查收" duration:1.0f];
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(changeButttonTime) userInfo:nil repeats:YES];
    } errorBlock:^(KTError *error) {
        [self dismissLoadingView];
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:error.message duration:1.0f];
        self.getCode.enabled = YES;
    }];
}
- (void)changeButttonTime{
    if (self.time == 1) {
        [self.timer invalidate];
        self.timer = nil;
        self.time = 60;
        self.getCode.enabled = YES;
        [self.getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    }else{
        self.time -- ;
        NSString * timestr = [NSString stringWithFormat:@"%d",self.time];
        NSString * str = [NSString stringWithFormat:@"获取验证码(%@)",timestr];
        [self.getCode setTitle:str forState:UIControlStateNormal];
    }
}
@end
