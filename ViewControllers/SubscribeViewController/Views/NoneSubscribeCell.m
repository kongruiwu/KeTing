//
//  NoneSubscribeCell.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/14.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "NoneSubscribeCell.h"

@implementation NoneSubscribeCell

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
    self.noneImg = [KTFactory creatImageViewWithImage:@"empty_page6"];
    self.descLabel = [KTFactory creatLabelWithText:@"尚未订阅，看看我们为你推荐的吧"
                                         fontValue:font750(26)
                                         textColor:KTColor_lightGray
                                     textAlignment:NSTextAlignmentCenter];
    [self addSubview:self.noneImg];
    [self addSubview:self.descLabel];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.noneImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(@(Anno750(60)));
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.noneImg.mas_bottom).offset(Anno750(30));
    }];
}

@end
