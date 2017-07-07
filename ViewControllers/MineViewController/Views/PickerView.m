//
//  PickerView.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/6.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "PickerView.h"

@implementation PickerView

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
    
    self.picker = [[UIPickerView alloc]init];
    self.picker.delegate = self;
    self.picker.dataSource = self;
    self.picker.backgroundColor = [UIColor whiteColor];
    
    
    [self.showView addSubview:self.picker];
    [self.showView addSubview:self.headView];
    [self.headView addSubview:self.cannceBtn];
    [self.headView addSubview:self.sureBtn];
    [self.headView addSubview:self.lineView];
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
    [self.picker mas_makeConstraints:^(MASConstraintMaker *make) {
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
- (void)setPickerDatas:(NSArray *)pickerDatas{
    _pickerDatas = [NSArray arrayWithArray:pickerDatas];
    [self.picker reloadAllComponents];
}
//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件包含的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1; // 返回1表明该控件只包含1列
}

//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // 由于该控件只包含一列，因此无须理会列序号参数component
    // 该方法返回teams.count，表明teams包含多少个元素，该控件就包含多少行
    return self.pickerDatas.count;
}


// UIPickerViewDelegate中定义的方法，该方法返回的NSString将作为UIPickerView
// 中指定列和列表项的标题文本
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    // 由于该控件只包含一列，因此无须理会列序号参数component
    // 该方法根据row参数返回teams中的元素，row参数代表列表项的编号，
    // 因此该方法表示第几个列表项，就使用teams中的第几个元素
    
    return [self.pickerDatas objectAtIndex:row];
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel * label = [KTFactory creatLabelWithText:[self pickerView:self.picker titleForRow:row forComponent:component]
                                          fontValue:font750(36)
                                          textColor:KTColor_MainOrange
                                      textAlignment:NSTextAlignmentCenter];
    return label;
}

@end
