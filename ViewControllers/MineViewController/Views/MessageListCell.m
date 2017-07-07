//
//  MessageListCell.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/4.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "MessageListCell.h"

@implementation MessageListCell

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
    self.nameLabel = [KTFactory creatLabelWithText:@"获得奖励：恭喜您获得6千元，已直接存入您的余额"
                                         fontValue:font750(30)
                                         textColor:KTColor_darkGray
                                     textAlignment:NSTextAlignmentLeft];
    self.nameLabel.numberOfLines = 0;
    self.timelabel = [KTFactory creatLabelWithText:@"1月23日"
                                         fontValue:font750(24)
                                         textColor:KTColor_lightGray
                                     textAlignment:NSTextAlignmentRight];
    self.lineView = [KTFactory creatLineView];
    
    [self addSubview:self.nameLabel];
    [self addSubview:self.timelabel];
    [self addSubview:self.lineView];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(-Anno750(200)));
        make.centerY.equalTo(@0);
    }];
    [self.timelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Anno750(24)));
        make.centerY.equalTo(@0);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(Anno750(-24)));
        make.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
}
@end
