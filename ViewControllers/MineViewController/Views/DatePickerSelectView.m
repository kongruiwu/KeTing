//
//  DatePickerSelectView.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/5.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "DatePickerSelectView.h"

@implementation DatePickerSelectView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    
    self.hidden = YES;
    self.backgroundColor = [UIColor clearColor];
    
    self.showView = [KTFactory creatViewWithColor:[UIColor clearColor]];
    self.showView.frame = CGRectMake(0, UI_HEGIHT - 64, UI_WIDTH, Anno750(470));
    [self addSubview:self.showView];
    
    self.clearBtn = [KTFactory creatButtonWithNormalImage:@"" selectImage:@""];
    [self.clearBtn addTarget:self action:@selector(disMiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.clearBtn];
    
    self.headView = [KTFactory creatViewWithColor:KTColor_BackGround];
    self.cannceBtn = [KTFactory creatButtonWithTitle:@"取消"
                                     backGroundColor:[UIColor clearColor]
                                           textColor:KTColor_MainBlack
                                            textSize:font750(30)];
    [self.cannceBtn addTarget:self action:@selector(disMiss) forControlEvents:UIControlEventTouchUpInside];
    self.sureBtn = [KTFactory creatButtonWithTitle:@"确定"
                                   backGroundColor:[UIColor clearColor]
                                         textColor:KTColor_MainBlack
                                          textSize:font750(30)];
    self.lineView = [KTFactory creatLineView];
    self.datePicker = [[UIDatePicker alloc]init];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中
    self.datePicker.locale = locale;
    self.datePicker.backgroundColor = [UIColor whiteColor];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:0];//设置最大时间为：当前时间推后十年
    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    [comps setYear:-100];//设置最小时间为：当前时间前推十年
    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    
    [self.datePicker setMaximumDate:maxDate];
    [self.datePicker setMinimumDate:minDate];
    
    [self.showView addSubview:self.headView];
    [self.headView addSubview:self.cannceBtn];
    [self.headView addSubview:self.sureBtn];
    [self.headView addSubview:self.lineView];
    [self.showView addSubview:self.datePicker];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.height.equalTo(@(Anno750(80)));
        make.right.equalTo(@0);
    }];
    [self.cannceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
        make.width.equalTo(@(Anno750(100)));
    }];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.top.equalTo(@0);
        make.width.equalTo(@(Anno750(100)));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.height.equalTo(@1);
    }];
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.bottom.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(self.headView.mas_bottom);
    }];
    [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(self.showView.mas_top);
    }];
}

- (void)show{
    self.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.backgroundColor = UIColorFromRGBA(0x000000, 0.3);
        self.showView.frame = CGRectMake(0, UI_HEGIHT - Anno750(470) - 64, UI_WIDTH,  Anno750(470));
    }];
}
- (void)disMiss{
    [UIView animateWithDuration:0.5 animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.showView.frame = CGRectMake(0, UI_HEGIHT - 64, UI_WIDTH, Anno750(470));
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
    });
}
@end
