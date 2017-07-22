//
//  VoiceSummaryCell.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/13.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "VoiceSummaryCell.h"

@implementation VoiceSummaryCell

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
    self.nameLabel = [KTFactory creatLabelWithText:@"专栏简介"
                                         fontValue:font750(32)
                                         textColor:KTColor_MainBlack
                                     textAlignment:NSTextAlignmentLeft];
    self.countLabel = [KTFactory creatLabelWithText:@"298人订阅"
                                          fontValue:font750(24)
                                          textColor:KTColor_lightGray
                                      textAlignment:NSTextAlignmentRight];
    self.descLabel = [KTFactory creatLabelWithText:@""
                                         fontValue:font750(28)
                                         textColor:KTColor_darkGray
                                     textAlignment:NSTextAlignmentLeft];
    self.descLabel.numberOfLines = 0;
    [self addSubview:self.nameLabel];
    [self addSubview:self.countLabel];
    [self addSubview:self.descLabel];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.top.equalTo(@(Anno750(30)));
    }];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Anno750(24)));
        make.centerY.equalTo(self.nameLabel.mas_centerY);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(-Anno750(24)));
        make.top.equalTo(self.nameLabel.mas_bottom).offset(Anno750(28));
    }];
}
- (void)updateWithDescString:(NSString *)string count:(NSString *)count hasBuy:(BOOL)rec{
    self.descLabel.attributedText = [KTFactory changeHtmlString:string withFont:font750(28)];
    self.countLabel.text = [NSString stringWithFormat:@"%@人订阅",count];
    if (rec) {
        self.nameLabel.text = @"专栏简介";
    }else{
        self.nameLabel.text = @"书籍简介";
    }
}
- (void)updateWithDescString:(NSString *)string time:(NSNumber *)time{
    self.descLabel.attributedText = [KTFactory changeHtmlString:string withFont:font750(28)];
    self.countLabel.text = [NSString stringWithFormat:@"时长：%@",[KTFactory getTimeStingWithCurrentTime:time.intValue andTotalTime:time.intValue]];
}

@end
