//
//  HotWordCell.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/17.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "HotWordCell.h"

@implementation HotWordCell

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
    self.tags = [NSMutableArray new];
    self.backgroundColor = [UIColor whiteColor];
}
- (void)updateHotWords:(NSArray *)tags{
    for (UIButton * button in self.tags) {
        [button removeFromSuperview];
    }
    [self.tags removeAllObjects];
    float leftWith = Anno750(702); //剩余宽度
    for (int i = 0; i<tags.count; i++) {
        HotWordModel * model = tags[i];
        UIButton * btn = [KTFactory creatButtonWithTitle:model.searchName
                                         backGroundColor:KTColor_BackGround
                                               textColor:KTColor_darkGray
                                                textSize:font750(28)];
        
        btn.tag = i;
        btn.layer.cornerRadius = 2.0f;
        [self.contentView addSubview:btn];
        if (i == 0) {
            //首个  应该 减去  自身宽度  两边间距 与下一个 控件间距
            leftWith -= Anno750(24) + model.with + 2 * Anno750(30) + Anno750(20);
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@(Anno750(24)));
                make.top.equalTo(@0);
                make.height.equalTo(@(Anno750(60)));
                make.width.equalTo(@(model.with +Anno750(30)));
            }];
        }else{
            UIButton * lastbtn = self.tags[i - 1];
            if (leftWith > model.with) {
                leftWith -= Anno750(20);  //  计算下个控件 要去掉的宽度
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(lastbtn.mas_right).offset(Anno750(20));
                    make.top.equalTo(lastbtn.mas_top);
                    make.height.equalTo(@(Anno750(60)));
                    make.width.equalTo(@(model.with+Anno750(30)));
                }];
                leftWith -= model.with+ Anno750(30);
            }else{
                //换行后重置 leftwith宽度 同时减去 首个控件应该  减去的 宽度
                leftWith = Anno750(702);
                leftWith -= Anno750(24) + model.with + 2 * Anno750(30) + Anno750(20);
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(@(Anno750(24)));
                    make.top.equalTo(lastbtn.mas_bottom).offset(Anno750(20));
                    make.height.equalTo(@(Anno750(60)));
                    make.width.equalTo(@(model.with+Anno750(30)));
                }];
            }
        }
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.tags addObject:btn];
    }

}
- (void)btnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(HotWordBtnClick:)]) {
        [self.delegate HotWordBtnClick:btn.titleLabel.text];
    }
}
@end
