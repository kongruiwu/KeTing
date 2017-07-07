//
//  CloseListCell.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/12.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "CloseListCell.h"

@implementation CloseListCell

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
    self.choselabel = [KTFactory creatLabelWithText:@""
                                          fontValue:font750(30)
                                          textColor:KTColor_MainBlack
                                      textAlignment:NSTextAlignmentCenter];
    self.bottomLine = [KTFactory creatLineView];
    [self addSubview:self.choselabel];
    [self addSubview:self.bottomLine];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.choselabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.centerY.equalTo(@0);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
}

@end
