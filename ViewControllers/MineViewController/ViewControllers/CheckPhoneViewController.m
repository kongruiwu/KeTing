//
//  CheckPhoneViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/5.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "CheckPhoneViewController.h"
#import <ReactiveObjC.h>
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
                                          textSize:font750(28)];
    [self.getCode setTitleColor:KTColor_lightGray forState:UIControlStateDisabled];
    [self.getCode addTarget:self action:@selector(getCodeRequest) forControlEvents:UIControlEventTouchUpInside];
    self.getCode.frame = CGRectMake(0, 0, Anno750(170), Anno750(50));
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
                                   backGroundColor:KTColor_MainOrangeAlpha
                                         textColor:KTColor_MainBlack
                                          textSize:font750(32)];
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
        return [NSNumber numberWithBool:phone.length>=11];
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
        self.nextBtn.backgroundColor = [x boolValue]?KTColor_MainOrange:KTColor_MainOrangeAlpha;
    }];
}
#pragma mark - 验证验证码
- (void)checkCodeRequest{
    NSDictionary * params = @{
                              @"mobile":self.phoneTF.text,
                              @"code":self.codeTF.text
                              };
    [[NetWorkManager manager] POSTRequest:params pageUrl:Page_CheckCode complete:^(id result) {
        [self doBack];
    } errorBlock:^(KTError *error) {
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"验证码错误，请重新输入" duration:1.0f];
    }];
}
#pragma mark - 获取验证码
- (void)getCodeRequest{
    NSDictionary * params = @{
                              @"mobile":self.phoneTF.text
                              };
    [[NetWorkManager manager] POSTRequest:params pageUrl:Page_SendCode complete:^(id result) {
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"验证码已发至您的手机，请查收" duration:1.0f];
        self.time = 60;
        self.getCode.enabled = NO;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(changeButttonTime) userInfo:nil repeats:YES];
    } errorBlock:^(KTError *error) {
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"验证码发送失败，请稍后再试" duration:1.0f];
    }];
}
- (void)changeButttonTime{
    if (self.time == 1) {
        self.time = 60;
        self.getCode.enabled = YES;
        [self.getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.timer invalidate];
        self.timer = nil;
    }else{
        self.time -- ;
        NSMutableAttributedString * attstr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"获取验证码(%d)",self.time]];
        NSString * timestr = [NSString stringWithFormat:@"%d",self.time];
        [attstr addAttribute:NSForegroundColorAttributeName value:KTColor_MainOrange range:NSMakeRange(4, timestr.length)];
        [self.getCode setAttributedTitle:attstr forState:UIControlStateDisabled];
    }
}
@end
