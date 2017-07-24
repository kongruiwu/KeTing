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
                                         fontValue:font750(26)
                                         textColor:KTColor_IconOrange
                                     textAlignment:NSTextAlignmentRight];
    self.topUpBtn = [KTFactory creatButtonWithTitle:@"充值"
                                    backGroundColor:[UIColor clearColor]
                                          textColor:KTColor_IconOrange
                                           textSize:font750(26)];
    self.topUpBtn.layer.borderColor = KTColor_IconOrange.CGColor;
    self.topUpBtn.layer.borderWidth = 0.5f;
    self.topUpBtn.layer.cornerRadius = 1.5f;
    self.line = [KTFactory creatViewWithColor:[UIColor clearColor]];
    
    [self addSubview:self.descLabel];
    [self addSubview:self.topUpBtn];
    [self addSubview:self.line];
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.top.equalTo(@0);
        make.width.equalTo(@0.5);
        make.centerX.equalTo(@0);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.line.mas_left).offset(Anno750(-10));
        make.centerY.equalTo(@0);
    }];
    
    [self.topUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line.mas_right).offset(Anno750(10));
        make.centerY.equalTo(@0);
        make.width.equalTo(@(Anno750(135)));
        make.height.equalTo(@(Anno750(60)));
    }];
    
}
@end
