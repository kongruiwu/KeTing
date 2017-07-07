//
//  WI-FISettingCell.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/4.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "WI-FISettingCell.h"

@implementation WI_FISettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)creatUI{
    self.nameLabel = [KTFactory creatLabelWithText:@"WI-FI时自动下载音频"
                                         fontValue:font750(30)
                                         textColor:KTColor_MainBlack
                                     textAlignment:NSTextAlignmentLeft];
    self.desclabel = [KTFactory creatLabelWithText:@"开启后，WI-FI环境下将自动下载订阅专刊的最新更新音频"
                                         fontValue:font750(24)
                                         textColor:KTColor_lightGray
                                     textAlignment:NSTextAlignmentLeft];
    self.desclabel.numberOfLines = 0;
    self.switchView = [[UISwitch alloc]init];
    self.switchView.onTintColor = KTColor_MainOrange;
    self.lineView = [KTFactory creatLineView];
    
    [self addSubview:self.nameLabel];
    [self addSubview:self.desclabel];
    [self addSubview:self.switchView];
    [self addSubview:self.lineView];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.top.equalTo(@(Anno750(20)));
    }];
    [self.desclabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.top.equalTo(self.nameLabel.mas_bottom).offset(Anno750(10));
        make.right.equalTo(@(Anno750(-180)));
    }];
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Anno750(24)));
        make.centerY.equalTo(@0);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.bottom.equalTo(@0);
        make.right.equalTo(@(-Anno750(24)));
        make.height.equalTo(@0.5);
    }];
}
- (void)updateWithTitle:(NSString *)title desc:(NSString *)desc isOpen:(BOOL)rec{
    self.nameLabel.text = title;
    self.desclabel.text = desc;
    self.switchView.on = rec;
}
@end
