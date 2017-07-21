//
//  LoginViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/27.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "LoginViewController.h"
#import "ForgotPwdViewController.h"
#import "RegisterViewController.h"
#import <ReactiveObjC.h>
#import "UserManager.h"
#import <UMSocialCore/UMSocialCore.h>
@interface LoginViewController ()

@property (nonatomic, strong) UITextField * phoneTF;
@property (nonatomic, strong) UITextField * pwdTextF;
@property (nonatomic, strong) UIButton * loginBtn;
@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIView * clearView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, 20)];
    [self.view addSubview:clearView];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

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
    self.backType = SelectorBackTypeDismiss;
    UIButton * backBtn = [KTFactory creatButtonWithNormalImage:@"back_white" selectImage:nil];
    [backBtn addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(30)));
        make.top.equalTo(@(20+ Anno750(12)));
        make.width.equalTo(@(Anno750(64)));
        make.height.equalTo(@(Anno750(64)));
    }];
    
    UIImageView * logo = [KTFactory creatImageViewWithImage:@"register_logo"];
    [self.view addSubview:logo];
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.width.equalTo(@(Anno750(174)));
        make.height.equalTo(@(Anno750(174)));
        make.top.equalTo(@(Anno750(180)));
    }];
    
    UIImageView * phoneImg = [KTFactory creatImageViewWithImage:@"register_ ph"];
    phoneImg.frame = CGRectMake(0, 0, Anno750(24), Anno750(34));
    UIImageView * pwdImg = [KTFactory creatImageViewWithImage:@"register_ password"];
    pwdImg.frame = CGRectMake(0, 0, Anno750(24), Anno750(34));
    UIView * spaceView = [KTFactory creatViewWithColor:[UIColor clearColor]];
    spaceView.frame = CGRectMake(0, 0, Anno750(48), Anno750(34));
    UIView * spaceView2 = [KTFactory creatViewWithColor:[UIColor clearColor]];
    spaceView2.frame = CGRectMake(0, 0, Anno750(48), Anno750(34));
    [spaceView addSubview:phoneImg];
    [spaceView2 addSubview:pwdImg];
    self.phoneTF = [KTFactory creattextfildWithPlaceHloder:@"手机号"];
    UIView * lineup = [KTFactory creatLineView];
    self.pwdTextF = [KTFactory creattextfildWithPlaceHloder:@"密码"];
    self.pwdTextF.secureTextEntry = YES;
    UIView * linedown = [KTFactory creatLineView];
    self.pwdTextF.leftViewMode = UITextFieldViewModeAlways;
    self.phoneTF.leftViewMode =UITextFieldViewModeAlways;
    self.phoneTF.leftView = spaceView;
    self.pwdTextF.leftView = spaceView2;
    [self.view addSubview:self.phoneTF];
    [self.view addSubview:lineup];
    [self.view addSubview:self.pwdTextF];
    [self.view addSubview:linedown];
    [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(90)));
        make.right.equalTo(@(-Anno750(90)));
        make.top.equalTo(logo.mas_bottom).offset(Anno750(158 - 96));
        make.height.equalTo(@(Anno750(50)));
    }];
    [lineup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneTF.mas_left);
        make.right.equalTo(self.phoneTF.mas_right);
        make.height.equalTo(@0.5);
        make.top.equalTo(self.phoneTF.mas_bottom).offset(Anno750(18));
    }];
    [self.pwdTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneTF.mas_left);
        make.right.equalTo(self.phoneTF.mas_right);
        make.height.equalTo(@(Anno750(50)));
        make.top.equalTo(lineup.mas_bottom).offset(Anno750(28));
    }];
    [linedown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneTF.mas_left);
        make.right.equalTo(self.phoneTF.mas_right);
        make.height.equalTo(@0.5);
        make.top.equalTo(self.pwdTextF.mas_bottom).offset(Anno750(18));
    }];
    
    UIButton * forgetPwd = [KTFactory creatButtonWithTitle:@"忘记密码?"
                                           backGroundColor:[UIColor clearColor]
                                                 textColor:UIColorFromRGB(0x887fb1)
                                                  textSize:font750(28)];
    [self.view addSubview:forgetPwd];
    [forgetPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.phoneTF.mas_right);
        make.top.equalTo(linedown.mas_bottom).offset(Anno750(10));
        make.height.equalTo(@(Anno750(50)));
    }];
    [forgetPwd addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
    
    self.loginBtn = [KTFactory creatButtonWithTitle:@"登录"
                                    backGroundColor:KTColor_IconOrange
                                          textColor:KTColor_MainBlack
                                           textSize:font750(32)];
    [self.view addSubview:self.loginBtn];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneTF.mas_left);
        make.right.equalTo(self.phoneTF.mas_right);
        make.height.equalTo(@(Anno750(88)));
        make.top.equalTo(forgetPwd.mas_bottom).offset(Anno750(30));
    }];
    [self.loginBtn addTarget:self action:@selector(userLogin) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * regisBtn = [KTFactory creatButtonWithTitle:@"点击注册>>"
                                          backGroundColor:[UIColor clearColor]
                                                textColor:UIColorFromRGB(0xcdc7e9)
                                                 textSize:font750(30)];
    [regisBtn addTarget:self action:@selector(userRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:regisBtn];
    [regisBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.loginBtn.mas_bottom).offset(Anno750(50));
        make.height.equalTo(@(Anno750(40)));
    }];
    
    
//    UIButton * QQBtn = [KTFactory creatButtonWithNormalImage:@"register_qq" selectImage:nil];
//    UIButton * WechatBtn = [KTFactory creatButtonWithNormalImage:@"register_ weixin" selectImage:nil];
//    [QQBtn addTarget:self action:@selector(QQuserLogin) forControlEvents:UIControlEventTouchUpInside];
//    [WechatBtn addTarget:self action:@selector(WechatUserLogin) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:QQBtn];
//    [self.view addSubview:WechatBtn];
//    [WechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(regisBtn.mas_bottom).offset(Anno750(180));
//        make.height.equalTo(@(Anno750(115)));
//        make.width.equalTo(@(Anno750(115)));
//        make.left.equalTo(@((UI_WIDTH - Anno750(230))/3));
//    }];
//    [QQBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(regisBtn.mas_bottom).offset(Anno750(180));
//        make.height.equalTo(@(Anno750(115)));
//        make.width.equalTo(@(Anno750(115)));
//        make.right.equalTo(@(-(UI_WIDTH - Anno750(230))/3));
//    }];
}
- (void)bindSignal{
    RAC(self.loginBtn,enabled) = [RACSignal combineLatest:@[self.phoneTF.rac_textSignal, self.pwdTextF.rac_textSignal] reduce:^(NSString * phone, NSString * pwd){
        if (phone.length>=11 && pwd.length>=6) {
            return @1;
        }else{
            return @0;
        }
    }];
    [RACObserve(self.loginBtn, enabled) subscribeNext:^(id  _Nullable x) {
        self.loginBtn.backgroundColor =  [x boolValue]?KTColor_MainOrange:KTColor_MainOrangeAlpha;
    }];
    
}

- (void)forgetPassword{
    [self.navigationController pushViewController:[ForgotPwdViewController new] animated:YES];
}
- (void)userLogin{
    NSDictionary * params = @{
                              @"Mobile":self.phoneTF.text,
                              @"Pword":self.pwdTextF.text
                              };
    [[NetWorkManager manager] POSTRequest:params pageUrl:Page_Login complete:^(id result) {
        [[UserManager manager] userLoginWithInfoDic:result];
        NSDictionary * params1 =  @{
                                   @"userid":[UserManager manager].userid
                                   };
        [[NetWorkManager manager] GETRequest:params1 pageUrl:Page_UserInfo complete:^(id result) {
            [[UserManager manager] userLoginWithInfoDic:result];
            [ToastView presentToastWithin:self.view.window withIcon:APToastIconNone text:@"登录成功" duration:2.0f];
            [self doBack];
        } errorBlock:^(KTError *error) {
            [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"请求超时" duration:1.0f];
        }];
    } errorBlock:^(KTError *error) {
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:error.message duration:1.0f];
    }];
}
- (void)userRegister{
    [self.navigationController pushViewController:[RegisterViewController new] animated:YES];
}
- (void)QQuserLogin{
    [self getUserInfoForPlatform:UMSocialPlatformType_QQ];
}
- (void)WechatUserLogin{
    [self getUserInfoForPlatform:UMSocialPlatformType_WechatSession];
}

- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
        
        UMSocialUserInfoResponse *resp = result;
        [UserManager manager].userid = resp.uid;
        NSDictionary * params1 =  @{
                                    @"userid":[UserManager manager].userid
                                    };
        [[NetWorkManager manager] GETRequest:params1 pageUrl:Page_UserInfo complete:^(id result) {
            [[UserManager manager] userLoginWithInfoDic:result];
            [ToastView presentToastWithin:self.view.window withIcon:APToastIconNone text:@"登录成功" duration:2.0f];
            [self doBack];
        } errorBlock:^(KTError *error) {
            [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"请求超时" duration:1.0f];
        }];

    }];
}
@end
