//
//  SearchListCell.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/17.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "SearchListCell.h"

@implementation SearchListCell

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
    self.nameLabel = [KTFactory creatLabelWithText:@"菜鸟的一天"
                                         fontValue:font750(30)
                                         textColor:KTColor_MainBlack textAlignment:NSTextAlignmentLeft];
    [self addSubview:self.nameLabel];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.centerY.equalTo(@0);
    }];
}
@end
