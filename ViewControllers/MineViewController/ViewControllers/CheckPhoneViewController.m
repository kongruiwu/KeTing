//
//  CheckPhoneViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/5.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "CheckPhoneViewController.h"
#import <ReactiveObjC.h>
#import "AccountSafeViewController.h"
@interface CheckPhoneViewController ()
@property (nonatomic, strong) UITextField * phoneTF;
@property (nonatomic, strong) UIButton * getCode;
@property (nonatomic, strong) UITextField * codeTF;
@property (nonatomic, strong) UIButton * nextBtn;
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, assign) int time;
@end

@implementation CheckPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavUnAlpha];
    [self drawBackButtonWithType:BackImgTypeBlack];
    [self setNavTitle:@"手机号" color:KTColor_MainBlack];
    
    [self creatUI];
    [self bindSignal];
}
- (void)creatUI{
    self.time = 60;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView * view = [KTFactory creatViewWithColor:KTColor_BackGround];
    view.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(30));
    [self.view addSubview:view];
    
    UILabel * numLabel = [KTFactory creatLabelWithText:@"+86"
                                             fontValue:font750(30)
                                             textColor:KTColor_MainBlack
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
    self.phoneTF = [KTFactory creattextfildWithPlaceHloder:@"手机号" placeColor:
                    KTColor_Line];
    self.phoneTF.textColor = KTColor_MainBlack;
    self.phoneTF.leftViewMode = UITextFieldViewModeAlways;
    self.phoneTF.leftView = numLabel;
    [self.view addSubview:self.phoneTF];
    [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(30)));
        make.right.equalTo(@(-Anno750(30)));
        make.height.equalTo(@(Anno750(50)));
        make.top.equalTo(view.mas_bottom).offset(Anno750(65));
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
    self.codeTF = [KTFactory creattextfildWithPlaceHloder:@"手机验证码" placeColor:KTColor_Line];
    self.codeTF.textColor = KTColor_MainBlack;
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

    self.nextBtn = [KTFactory creatButtonWithTitle:@"保存"
                                   backGroundColor:[UIColor clearColor]
                                         textColor:KTColor_MainOrange
                                          textSize:font750(32)];
    self.nextBtn.layer.borderColor = KTColor_MainOrange.CGColor;
    self.nextBtn.layer.borderWidth = 1.0f;
    self.nextBtn.layer.cornerRadius = 2.0f;
    [self.view addSubview:self.nextBtn];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneTF.mas_left);
        make.right.equalTo(self.phoneTF.mas_right);
        make.height.equalTo(@(Anno750(88)));
        make.top.equalTo(lineDown.mas_bottom).offset(Anno750(100));
    }];
    [self.nextBtn addTarget:self action:@selector(checkCodeRequest) forControlEvents:UIControlEventTouchUpInside];
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
        [self.nextBtn setTitleColor:[x boolValue]?KTColor_MainOrange:KTColor_lightGray forState:UIControlStateNormal];
        self.nextBtn.layer.borderColor = ([x boolValue]?KTColor_MainOrange:KTColor_lightGray).CGColor;
    }];
}
#pragma mark - 验证验证码
- (void)checkCodeRequest{
    NSDictionary * params = @{
                              @"mobile":self.phoneTF.text,
                              @"code":self.codeTF.text
                              };
    [self showLoadingCantTouchAndClear];
    [[NetWorkManager manager] POSTRequest:params pageUrl:Page_CheckCode complete:^(id result) {
        NSDictionary * dic = @{};
        [[NetWorkManager manager] POSTRequest:dic pageUrl:Page_ChangePhone complete:^(id result) {
            [self dismissLoadingView];
            NSDictionary * dic = (NSDictionary *)result;
            if (dic[@"SUCCESS"] && [dic[@"SUCCESS"] intValue] != 0) {
                [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"修改成功" duration:1.0f];
                for (int i = 0; i<self.navigationController.viewControllers.count; i++) {
                    UIViewController * vc = self.navigationController.viewControllers[i];
                    if ([vc isKindOfClass:[AccountSafeViewController class]]) {
                        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
                        break;
                    }
                }
            }else{
                [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"验证码错误，请重新输入" duration:1.0f];
            }
        } errorBlock:^(KTError *error) {
            [self dismissLoadingView];
        }];
    } errorBlock:^(KTError *error) {
        [self dismissLoadingView];
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"验证码错误，请重新输入" duration:1.0f];
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
