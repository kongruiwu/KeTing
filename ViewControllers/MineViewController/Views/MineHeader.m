//
//  MainHeader.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/26.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "MineHeader.h"

@implementation MineHeader

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    self.groundImg = [KTFactory creatImageViewWithImage:@"mineground"];
    [self.groundImg setContentMode:UIViewContentModeScaleAspectFill];
    [self.groundImg setClipsToBounds:YES];
    
    
    self.userIcon = [KTFactory creatImageViewWithImage:@"default_head"];
    self.userIcon.layer.cornerRadius = Anno750(70);
    self.userIcon.layer.masksToBounds = YES;
    self.userName = [KTFactory creatLabelWithText:@"天才"
                                        fontValue:font750(28)
                                        textColor:[UIColor whiteColor]
                                    textAlignment:NSTextAlignmentCenter];
    self.clearButton = [KTFactory creatButtonWithNormalImage:@"" selectImage:@""];
    self.timeLabel = [self creatBottomLabel:@"收听时间"];
    self.bookLabel = [self creatBottomLabel:@"收听书籍"];
    self.dayLabel = [self creatBottomLabel:@"连续登录"];
    self.timeValue = [KTFactory creatLabelWithText:@"-"
                                         fontValue:font750(24)
                                         textColor:[UIColor colorWithRed:0.69 green:0.58 blue:0.38 alpha:1.00]
                                     textAlignment:NSTextAlignmentCenter];
    self.bookCount = [KTFactory creatLabelWithText:@"-"
                                         fontValue:font750(24)
                                         textColor:[UIColor colorWithRed:0.00 green:0.63 blue:0.66 alpha:1.00]
                                     textAlignment:NSTextAlignmentCenter];
    self.dayTime = [KTFactory creatLabelWithText:@"-"
                                       fontValue:font750(24)
                                       textColor:[UIColor colorWithRed:0.41 green:0.59 blue:0.84 alpha:1.00]
                                   textAlignment:NSTextAlignmentCenter];
    
//    self.navView = [KTFactory creatViewWithColor:[UIColor clearColor]];
//    self.backBtn = [KTFactory creatButtonWithNormalImage:@"back_white" selectImage:nil];
//    self.titleLabel = [KTFactory creatLabelWithText:@"我的"
//                                          fontValue:font750(34)
//                                          textColor:[UIColor whiteColor]
//                                      textAlignment:NSTextAlignmentCenter];
    [self addSubview:self.clearButton];
    [self addSubview:self.groundImg];
    [self addSubview:self.userIcon];
    [self addSubview:self.userName];
    [self addSubview:self.timeValue];
    [self addSubview:self.timeLabel];
    [self addSubview:self.bookLabel];
    [self addSubview:self.bookCount];
    [self addSubview:self.dayTime];
    [self addSubview:self.dayLabel];
//    [self addSubview:self.navView];
//    [self.navView addSubview:self.backBtn];
//    [self.navView addSubview:self.titleLabel];
    
}
- (UILabel *)creatBottomLabel:(NSString *)title{
    UILabel * label = [KTFactory creatLabelWithText:title
                                          fontValue:font750(24)
                                          textColor:KTColor_lightGray
                                      textAlignment:NSTextAlignmentCenter];
    return label;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.groundImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(Anno750(130)));
        make.centerX.equalTo(@0);
        make.height.equalTo(@(Anno750(140)));
        make.width.equalTo(@(Anno750(140)));
    }];
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userIcon.mas_bottom).offset(Anno750(10));
        make.centerX.equalTo(@0);
    }];
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userIcon.mas_left);
        make.top.equalTo(self.userIcon.mas_top);
        make.right.equalTo(self.userIcon.mas_right);
        make.bottom.equalTo(self.userName.mas_bottom);
    }];
    [self.bookCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.width.equalTo(@(UI_WIDTH/3));
        make.top.equalTo(self.userName.mas_bottom).offset(Anno750(30));
    }];
    [self.timeValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(self.bookCount.mas_top);
        make.width.equalTo(@(UI_WIDTH/3));
    }];
    [self.dayTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0);
        make.top.equalTo(self.bookCount.mas_top);
        make.width.equalTo(@(UI_WIDTH/3));
    }];
    [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dayTime.mas_bottom).offset(Anno750(10));
        make.right.equalTo(@0);
        make.width.equalTo(@(UI_WIDTH/3));
    }];
    [self.bookLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.width.equalTo(@(UI_WIDTH/3));
        make.top.equalTo(self.dayLabel.mas_top);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.width.equalTo(@(UI_WIDTH/3));
        make.top.equalTo(self.dayLabel.mas_top);
    }];
//    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@0);
//        make.right.equalTo(@0);
//        make.top.equalTo(@20);
//        make.height.equalTo(@44);
//    }];
//    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@(Anno750(30)));
//        make.centerY.equalTo(@0);
//        make.width.equalTo(@(Anno750(64)));
//        make.height.equalTo(@(Anno750(64)));
//    }];
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(@0);
//        make.centerX.equalTo(@0);
//    }];
}
- (void)updateDatas{
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:[UserManager manager].info.ICON] placeholderImage:[UIImage imageNamed:@"default_head"]];
    self.userName.text = @"点击登录";
    if ([UserManager manager].isLogin) {
        self.userName.text = [UserManager manager].info.NICKNAME;
        NSMutableAttributedString * attstr = [[NSMutableAttributedString alloc]initWithString:[UserManager manager].info.listenCount[@"listenLong"]];
        [attstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:Anno750(24)] range:NSMakeRange(attstr.length - 1, 1)];
        [attstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:Anno750(24)] range:NSMakeRange(attstr.length - 5, 2)];
        self.timeValue.font = [UIFont systemFontOfSize:Anno750(32)];
        self.timeValue.attributedText = attstr;
        
        attstr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@本",[UserManager manager].info.listenCount[@"listenCount"]]];
        [attstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:Anno750(24)] range:NSMakeRange(attstr.length - 1, 1)];
        self.bookCount.font = [UIFont systemFontOfSize:Anno750(32)];
        self.bookCount.attributedText = attstr;
        
        attstr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@天",[UserManager manager].info.loginday]];
        [attstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:Anno750(24)] range:NSMakeRange(attstr.length - 1, 1)];
        self.dayTime.font = [UIFont systemFontOfSize:Anno750(32)];
        self.dayTime.attributedText = attstr;
    }else{
        self.timeValue.font = [UIFont systemFontOfSize:font750(24)];
        self.bookCount.font = [UIFont systemFontOfSize:font750(24)];
        self.dayTime.font = [UIFont systemFontOfSize:font750(24)];
        self.timeValue.text = @"-";
        self.bookCount.text = @"-";
        self.dayTime.text = @"-";
    }
}
@end
