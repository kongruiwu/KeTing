//
//  TopUpCell.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/18.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "TopUpCell.h"

@implementation TopUpCell

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
    self.descLabel = [KTFactory creatLabelWithText:@"余额不足"
                                         fontValue:font750(30)
                                         textColor:KTColor_MainOrange
                                     textAlignment:NSTextAlignmentLeft];
    self.topUpBtn = [KTFactory creatButtonWithTitle:@"充值"
                                    backGroundColor:[UIColor clearColor]
                                          textColor:KTColor_IconOrange
                                           textSize:font750(26)];
    self.topUpBtn.layer.borderColor = KTColor_IconOrange.CGColor;
    self.topUpBtn.layer.borderWidth = 1.0f;
    self.topUpBtn.layer.cornerRadius = 3.0f;
    self.line = [KTFactory creatLineView];
    
    [self addSubview:self.descLabel];
    [self addSubview:self.topUpBtn];
    [self addSubview:self.line];
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(95)));
        make.centerY.equalTo(@0);
    }];
    
    [self.topUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Anno750(24)));
        make.centerY.equalTo(@0);
        make.width.equalTo(@(Anno750(135)));
        make.height.equalTo(@(Anno750(60)));
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(Anno750(-24)));
        make.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
}
@end
