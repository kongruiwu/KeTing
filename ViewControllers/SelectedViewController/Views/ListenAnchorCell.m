//
//  ListenAnchorCell.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/13.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "ListenAnchorCell.h"

@implementation ListenAnchorCell

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
    self.leftImg = [KTFactory creatImageViewWithImage:@""];
    self.leftImg.layer.masksToBounds = YES;
    self.leftImg.layer.cornerRadius = Anno750(40);
    self.nameLabel = [KTFactory creatLabelWithText:@""
                                         fontValue:font750(30)
                                         textColor:KTColor_darkGray
                                     textAlignment:NSTextAlignmentLeft];
    self.nextIcon = [KTFactory creatImageViewWithImage:@"listen_more"];
    self.bottomLine = [KTFactory creatLineView];
    
    [self addSubview:self.leftImg];
    [self addSubview:self.nameLabel];
    [self addSubview:self.nextIcon];
    [self addSubview:self.bottomLine];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.centerY.equalTo(@0);
        make.width.equalTo(@(Anno750(80)));
        make.height.equalTo(@(Anno750(80)));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImg.mas_right).offset(Anno750(24));
        make.centerY.equalTo(self.leftImg.mas_centerY);
    }];
    [self.nextIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Anno750(24)));
        make.centerY.equalTo(@0);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(-Anno750(24)));
        make.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
}
- (void)updateWithIcon:(NSString *)imgurl name:(NSString *)name{
    [self.leftImg sd_setImageWithURL:[NSURL URLWithString:imgurl]];
    NSMutableAttributedString * attstr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"讲述人  %@",name]];
    [attstr addAttribute:NSForegroundColorAttributeName value:KTColor_lightGray range:NSMakeRange(0, 3)];
    [attstr addAttribute:NSForegroundColorAttributeName value:KTColor_MainBlack range:NSMakeRange(3, attstr.length -3)];
    self.nameLabel.attributedText = attstr;
}
@end
