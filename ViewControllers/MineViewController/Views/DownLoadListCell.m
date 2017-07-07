//
//  DownLoadListCell.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/3.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "DownLoadListCell.h"

@implementation DownLoadListCell

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
    self.nameLabel = [KTFactory creatLabelWithText:@"权利的游戏"
                                         fontValue:font750(30)
                                         textColor:KTColor_MainBlack
                                     textAlignment:NSTextAlignmentLeft];
    self.tagLabel = [KTFactory creatLabelWithText:@"已暂停，点击继续下载  3:47  财经  新闻  已播3%"
                                        fontValue:font750(24)
                                        textColor:KTColor_lightGray
                                    textAlignment:NSTextAlignmentLeft];
    self.line = [KTFactory creatLineView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.tagLabel];
    [self addSubview:self.line];
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(-Anno750(24)));
        make.top.equalTo(@(Anno750(20)));
    }];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(-Anno750(24)));
        make.bottom.equalTo(@(-Anno750(20)));
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(-Anno750(24)));
        make.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    
}
- (void)updateWithHistoryModel:(HistoryModel *)model{
    
}

@end
