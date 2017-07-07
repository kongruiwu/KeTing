//
//  SettingListCell.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/4.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "SettingListCell.h"

@implementation SettingListCell

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
    self.nameLabel = [KTFactory creatLabelWithText:@"推荐给好友"
                                         fontValue:font750(30)
                                         textColor:KTColor_MainBlack
                                     textAlignment:NSTextAlignmentLeft];
    self.descLabel = [KTFactory creatLabelWithText:@"35.00M"
                                         fontValue:font750(26)
                                         textColor:KTColor_lightGray
                                     textAlignment:NSTextAlignmentRight];
    self.arrowIcon = [KTFactory creatArrowImage];
    self.lineView = [KTFactory creatLineView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.descLabel];
    [self addSubview:self.arrowIcon];
    [self addSubview:self.lineView];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.centerY.equalTo(@0);
    }];
    [self.arrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Anno750(24)));
        make.centerY.equalTo(@0);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.arrowIcon.hidden) {
            make.right.equalTo(@(-Anno750(24)));
        }else{
            make.right.equalTo(self.arrowIcon.mas_left).offset(Anno750(-10));
        }
        make.centerY.equalTo(@0);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(-Anno750(24)));
        make.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
}
- (void)updateWithName:(NSString *)name desc:(NSString *)desc{
    self.nameLabel.text = name;
    self.descLabel.text = desc;
}
- (void)updateWithName:(NSString *)name desc:(NSString *)desc hiddenArrow:(BOOL)rec{
    self.nameLabel.text = name;
    self.descLabel.text = desc;
    self.descLabel.textColor = KTColor_MainBlack;
    self.arrowIcon.hidden = rec;
}
@end
