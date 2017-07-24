//
//  ChangeMinepwdViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/5.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "ChangeMinepwdViewController.h"
#import <ReactiveObjC.h>
@interface ChangeMinepwdViewController ()

@property (nonatomic, strong) UITextField * oldPwdT;
@property (nonatomic, strong) UITextField * pwdT;
@property (nonatomic, strong) UITextField * checkT;
@property (nonatomic, strong) UIButton * overBtn;

@end

@implementation ChangeMinepwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavUnAlpha];
    [self drawBackButtonWithType:BackImgTypeBlack];
    [self setNavTitle:@"修改密码" color:KTColor_MainBlack];
    [self creatUI];
    [self bindSingl];
}
- (void)creatUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView * view = [KTFactory creatViewWithColor:KTColor_BackGround];
    view.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(30));
    [self.view addSubview:view];
    
    self.oldPwdT = [KTFactory creattextfildWithPlaceHloder:@"原密码" placeColor:KTColor_lightGray];
    self.pwdT = [KTFactory creattextfildWithPlaceHloder:@"新密码" placeColor:KTColor_lightGray];
    self.checkT = [KTFactory creattextfildWithPlaceHloder:@"确认密码" placeColor:
                   KTColor_lightGray];
    self.oldPwdT.secureTextEntry = YES;
    self.pwdT.secureTextEntry = YES;
    self.checkT.secureTextEntry = YES;
    
    UIView * topline = [KTFactory creatLineView];
    UIView * centerline = [KTFactory creatLineView];
    UIView * bottomline = [KTFactory creatLineView];
    
    [self.view addSubview:self.oldPwdT];
    [self.view addSubview:self.pwdT];
    [self.view addSubview:self.checkT];
    [self.view addSubview:topline];
    [self.view addSubview:centerline];
    [self.view addSubview:bottomline];
    
    [self.oldPwdT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(30)));
        make.right.equalTo(@(-Anno750(30)));
        make.height.equalTo(@(Anno750(50)));
        make.top.equalTo(view.mas_bottom).offset(Anno750(50));
    }];
    [topline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(30)));
        make.right.equalTo(@(-Anno750(30)));
        make.height.equalTo(@0.5);
        make.bottom.equalTo(self.oldPwdT.mas_bottom).offset(Anno750(18));
    }];
    [self.pwdT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(30)));
        make.right.equalTo(@(-Anno750(30)));
        make.height.equalTo(@(Anno750(50)));
        make.top.equalTo(topline.mas_bottom).offset(Anno750(28));
    }];
    [centerline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(30)));
        make.right.equalTo(@(-Anno750(30)));
        make.height.equalTo(@0.5);
        make.bottom.equalTo(self.pwdT.mas_bottom).offset(Anno750(18));
    }];
    [self.checkT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(30)));
        make.right.equalTo(@(-Anno750(30)));
        make.height.equalTo(@(Anno750(50)));
        make.top.equalTo(centerline.mas_bottom).offset(Anno750(28));
    }];
    [bottomline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(30)));
        make.right.equalTo(@(-Anno750(30)));
        make.height.equalTo(@0.5);
        make.bottom.equalTo(self.checkT.mas_bottom).offset(Anno750(18));
    }];
    self.overBtn = [KTFactory creatButtonWithTitle:@"完成"
                                   backGroundColor:[UIColor clearColor]
                                         textColor:KTColor_MainOrange
                                          textSize:font750(30)];
    [self.overBtn setTitleColor:KTColor_lightGray forState:UIControlStateDisabled];
    [self.overBtn addTarget:self action:@selector(changePasswordRequest) forControlEvents:UIControlEventTouchUpInside];
    self.overBtn.layer.borderWidth = 1.0f;
    self.overBtn.layer.borderColor = KTColor_lightGray.CGColor;
    self.overBtn.layer.cornerRadius = 4.0f;
    [self.view addSubview:self.overBtn];
    [self.overBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(30)));
        make.right.equalTo(@(-Anno750(30)));
        make.height.equalTo(@(Anno750(90)));
        make.top.equalTo(bottomline.mas_bottom).offset(Anno750(90));
    }];
}
- (void)bindSingl{
    RAC(self.overBtn,enabled) = [RACSignal combineLatest:@[self.oldPwdT.rac_textSignal,self.pwdT.rac_textSignal,self.checkT.rac_textSignal] reduce:^(NSString * oldpwd,NSString * pwd,NSString * checkPwd){
        if (oldpwd.length >= 6 && pwd.length>= 6 && checkPwd.length >= 6) {
            return @1;
        }else{
            return @0;
        }
    }];
    [RACObserve(self.overBtn, enabled) subscribeNext:^(id  _Nullable x) {
        UIColor * color = [x boolValue]?KTColor_MainOrange:KTColor_lightGray;
        self.overBtn.layer.borderColor = color.CGColor;
    }];
}
- (void)changePasswordRequest{
    if (![self.pwdT.text isEqualToString:self.checkT.text]) {
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"两次密码不一致" duration:1.0f];
        return;
    }
    NSDictionary * params = @{
                              @"originPassword":self.oldPwdT.text,
                              @"newPassWord":self.pwdT.text,
                              @"confirmPassWord":self.checkT.text
                              };
    [[NetWorkManager manager] POSTRequest:params pageUrl:Page_ChangePwd complete:^(id result) {
        [ToastView presentToastWithin:self.view.window withIcon:APToastIconNone text:@"密码修改成功" duration:1.0f];
        [self doBack];
    } errorBlock:^(KTError *error) {
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:error.message duration:1.0f];
    }];
}
@end
