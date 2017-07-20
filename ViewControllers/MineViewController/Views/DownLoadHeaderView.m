//
//  DownLoadHeaderView.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/20.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "DownLoadHeaderView.h"
#import "HomeTopModel.h"
@implementation DownLoadHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    self.backgroundColor = [UIColor whiteColor];
    self.selectButton = [KTFactory creatButtonWithNormalImage:@"icon_unselect" selectImage:@"icon_select"];
    [self.selectButton setTitle:@"  全选" forState:UIControlStateNormal];
    self.selectButton.hidden = YES;
    [self.selectButton setTitleColor:KTColor_MainBlack forState:UIControlStateNormal];
    self.selectButton.titleLabel.font = [UIFont systemFontOfSize:font750(26)];
    
    self.countLabel = [KTFactory creatLabelWithText:[NSString stringWithFormat:@"共7条"]
                                          fontValue:font750(26)
                                          textColor:KTColor_MainBlack
                                      textAlignment:NSTextAlignmentLeft];
    self.statusButton = [KTFactory creatButtonWithTitle:@"批量管理"
                                        backGroundColor:[UIColor clearColor]
                                              textColor:KTColor_darkGray
                                               textSize:font750(26)];
    [self.statusButton setTitle:@"取消" forState:UIControlStateSelected];
    [self.statusButton addTarget:self action:@selector(statusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.line = [KTFactory creatLineView];
    
    [self addSubview:self.selectButton];
    [self addSubview:self.countLabel];
    [self addSubview:self.statusButton];
    [self addSubview:self.line];

}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.centerY.equalTo(@0);
    }];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.centerY.equalTo(@0);
    }];
    [self.statusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Anno750(24)));
        make.centerY.equalTo(@0);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(Anno750(-24)));
        make.height.equalTo(@0.5);
        make.bottom.equalTo(@0);
    }];
}
- (void)updateWithCount:(NSArray *)dataArray{
    BOOL rec = YES;
    for (int i = 0; i<dataArray.count; i++) {
        HomeTopModel * model = dataArray[i];
        if (!model.isSelectDown) {
            rec = NO;
        }
    }
    self.countLabel.text = [NSString stringWithFormat:@"共%ld条",dataArray.count];
    self.selectButton.selected = rec;
    
}
- (void)statusButtonClick:(UIButton *)button{
    button.selected = !button.selected;
    self.selectButton.hidden = !button.selected;
    self.countLabel.hidden = button.selected;
}
@end
