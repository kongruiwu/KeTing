//
//  ShareView.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/12.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "ShareView.h"

@implementation shareButton

- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake((self.bounds.size.width - Anno750(86))/2, Anno750(50), Anno750(86), Anno750(86));
    self.titleLabel.frame = CGRectMake(0, Anno750(146), UI_WIDTH / 3, Anno750(30));
}


@end

@implementation ShareView

- (instancetype)initWithFrame:(CGRect)frame hasNav:(BOOL)rec{
    self = [super initWithFrame:frame];
    if (self) {
        self.hasNav = rec;
        [self creatUI];
        [self setFristValue];
    }
    return self;
}


- (void)creatUI{
    
    float y = UI_HEGIHT;
    if (self.hasNav) {
        y = UI_HEGIHT - 64;
    }
    
    self.backgroundColor = [UIColor clearColor];
    self.hidden = YES;
    self.showView = [KTFactory creatViewWithColor:[UIColor whiteColor]];
    self.showView.frame = CGRectMake(0, y, UI_WIDTH, Anno750(330));
    [self addSubview:self.showView];
    
    self.cannceBtn = [KTFactory creatButtonWithNormalImage:@"" selectImage:@""];
    self.cannceBtn.frame = CGRectMake(0, 0, UI_WIDTH, y - Anno750(330));
    [self.cannceBtn addTarget:self action:@selector(disMiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cannceBtn];
    
    self.wechatBtn = [self creatSubShareButtonTitle:@"微信好友" imageName:@"share_wechat"];
    self.momentBtn = [self creatSubShareButtonTitle:@"朋友圈" imageName:@"share_circle"];
    self.QQbtn = [self creatSubShareButtonTitle:@"QQ" imageName:@"share_qq"];
    
    
    self.wechatBtn.tag = 1001;
    self.momentBtn.tag = 1002;
    self.QQbtn.tag = 1003;
    
    [self.wechatBtn addTarget:self action:@selector(doShareWithButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.momentBtn addTarget:self action:@selector(doShareWithButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.QQbtn addTarget:self action:@selector(doShareWithButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.showView addSubview:self.wechatBtn];
    [self.showView addSubview:self.momentBtn];
    [self.showView addSubview:self.QQbtn];
    
    [self.wechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.width.equalTo(@(UI_WIDTH/3));
        make.height.equalTo(@(Anno750(220)));
    }];
    [self.momentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.wechatBtn.mas_right);
        make.top.equalTo(@0);
        make.width.equalTo(@(UI_WIDTH/3));
        make.height.equalTo(@(Anno750(220)));
    }];
    [self.QQbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.momentBtn.mas_right);
        make.top.equalTo(@0);
        make.width.equalTo(@(UI_WIDTH/3));
        make.height.equalTo(@(Anno750(220)));
    }];
    
    self.grayView = [KTFactory creatViewWithColor:Audio_progessWhite];
    [self.showView addSubview:self.grayView];
    [self.grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@(Anno750(10)));
        make.top.equalTo(self.wechatBtn.mas_bottom);
    }];
    self.disBtn = [KTFactory creatButtonWithTitle:@"取消"
                                     backGroundColor:[UIColor clearColor]
                                           textColor:KTColor_lightGray
                                            textSize:font750(30)];
    [self.showView addSubview:self.disBtn];
    [self.disBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.grayView.mas_bottom);
        make.bottom.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
    }];
    [self.disBtn addTarget:self action:@selector(disMiss) forControlEvents:UIControlEventTouchUpInside];
    
}
- (shareButton *)creatSubShareButtonTitle:(NSString *)title imageName:(NSString *)imgName{
    shareButton * btn = [shareButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:KTColor_darkGray forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:font750(26)];
    [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    return btn;
}

- (void)show{
    self.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.backgroundColor = UIColorFromRGBA(0x000000, 0.5);
        if (!self.hasNav) {
            self.showView.frame = CGRectMake(0, UI_HEGIHT - Anno750(330), UI_WIDTH,  Anno750(330));
        }else{
            self.showView.frame = CGRectMake(0, UI_HEGIHT - Anno750(330) - 64, UI_WIDTH,  Anno750(330));
        }
        
    }];
}
- (void)disMiss{
    [UIView animateWithDuration:0.5 animations:^{
        self.backgroundColor = [UIColor clearColor];
        if (!self.hasNav) {
            self.showView.frame = CGRectMake(0, UI_HEGIHT, UI_WIDTH, Anno750(330));
        }else{
            self.showView.frame = CGRectMake(0, UI_HEGIHT - 64, UI_WIDTH, Anno750(330));
        }
        
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
    });
}

- (void)setFristValue{
    self.shareTitle = @"可听";
    self.shareDesc = @"欢迎来到可听";
    self.targeturl = @"https://itunes.apple.com/app/id1014233862";
    self.imageUrl = @"";
    self.image = [UIImage imageNamed:@"logo"];
}
- (void)updateShareInfoWithTitle:(NSString *)title desc:(NSString *)desc contentUlr:(NSString *)url imageUrl:(NSString *)imageUrl{
    if (title.length>0) {
        self.shareTitle = title;
    }
    if (desc.length>0) {
        self.shareDesc = desc;
    }
    if (url.length>0) {
        self.targeturl = url;
    }
    if (imageUrl.length>0) {
        self.imageUrl = imageUrl;
    }
}
- (void)doShareWithButton:(UIButton *)btn{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    id image;
    if (self.imageUrl.length<1) {
        image = self.image;
    }else{
        image = self.imageUrl;
    }
    UMShareWebpageObject * shareObj = [UMShareWebpageObject shareObjectWithTitle:self.shareTitle descr:self.shareDesc thumImage:image];
    UMShareImageObject * shareImage = [UMShareImageObject shareObjectWithTitle:self.shareTitle descr:self.shareDesc thumImage:image];
    shareObj.webpageUrl = self.targeturl;
    UMSocialPlatformType type = UMSocialPlatformType_WechatSession;
    switch (btn.tag - 1001) {
        case 0:
            type = UMSocialPlatformType_WechatSession;
            break;
        case 1:
            type = UMSocialPlatformType_WechatTimeLine;
            break;
        case 2:
            type = UMSocialPlatformType_QQ;
            break;
        case 3:
            type = UMSocialPlatformType_Qzone;
            break;
        case 4:
        {
            type = UMSocialPlatformType_Sina;
            [shareImage setShareImage:image];
        }
            break;
    }
    
    messageObject.shareObject = shareObj;
    //调用分享接口
    if (type == UMSocialPlatformType_Sina) {
        messageObject.text = [NSString stringWithFormat:@"%@%@",self.shareDesc,self.targeturl];
        messageObject.shareObject = shareImage;
    }
    [[UMSocialManager defaultManager] shareToPlatform:type messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
    }];
    [self disMiss];
    
}
@end
