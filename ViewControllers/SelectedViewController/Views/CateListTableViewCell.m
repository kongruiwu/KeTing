//
//  CateListTableViewCell.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/9.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "CateListTableViewCell.h"

@implementation CateListTableViewCell

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
    self.leftName = [KTFactory creatLabelWithText:@""
                                        fontValue:font750(26)
                                        textColor:KTColor_darkGray
                                    textAlignment:NSTextAlignmentLeft];
    self.seletImg = [KTFactory creatImageViewWithImage:@"icon_select"];
    self.seletImg.hidden = YES;
    self.bottomLine = [KTFactory creatLineView];
    [self addSubview:self.leftName];
    [self addSubview:self.seletImg];
    [self addSubview:self.bottomLine];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.leftName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.centerY.equalTo(@0);
    }];
    [self.seletImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Anno750(24)));
        make.centerY.equalTo(@0);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
        make.right.equalTo(@(-Anno750(24)));
    }];
}

- (void)updateWithModel:(TopTagModel *)model{
    self.leftName.text = [NSString stringWithFormat:@"#  %@  (%@)",model.tagName,model.useCount];
    self.seletImg.hidden = !model.hasSelect;
}
@end
