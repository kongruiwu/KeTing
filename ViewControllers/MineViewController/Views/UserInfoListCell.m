//
//  UserInfoListCell.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/27.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "UserInfoListCell.h"

@implementation UserInfoListCell

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
    self.nameLabel = [KTFactory creatLabelWithText:@"昵称"
                                         fontValue:font750(30)
                                         textColor:KTColor_darkGray
                                     textAlignment:NSTextAlignmentLeft];
    self.descLabel = [KTFactory creatLabelWithText:@"小西瓜"
                                         fontValue:font750(28)
                                         textColor:KTColor_MainBlack
                                     textAlignment:NSTextAlignmentRight];
    self.bottonline = [KTFactory creatLineView];
    
    [self addSubview:self.nameLabel];
    [self addSubview:self.descLabel];
    [self addSubview:self.bottonline];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.centerY.equalTo(@0);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Anno750(24)));
        make.centerY.equalTo(@0);
    }];
    [self.bottonline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(-Anno750(24)));
        make.top.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
}
- (void)updateWithName:(NSString *)name desc:(NSString *)desc{
    self.nameLabel.text = name;
    self.descLabel.text = desc;
    if ([desc isEqualToString:@"点击设置"]) {
        self.descLabel.textColor = KTColor_lightGray;
    }else{
        self.descLabel.textColor = KTColor_MainBlack;
    }
}

@end
