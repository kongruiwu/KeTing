//
//  TopListBottomView.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/9.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "TopListBottomView.h"

@implementation TopListBottomView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    self.backgroundColor = [UIColor whiteColor];
    self.topLine = [KTFactory creatLineView];
    self.leftLabel = [KTFactory creatLabelWithText:@"已选择0条,共0.00M"
                                         fontValue:font750(28)
                                         textColor:KTColor_darkGray
                                     textAlignment:NSTextAlignmentLeft];
    self.downLoadBtn = [KTFactory creatButtonWithTitle:@"下载"
                                       backGroundColor:KTColor_MainOrange
                                             textColor:[UIColor whiteColor]
                                              textSize:font750(30)];
    self.downLoadBtn.layer.cornerRadius = 2.0f;
    
    [self addSubview:self.topLine];
    [self addSubview:self.leftLabel];
    [self addSubview:self.downLoadBtn];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(@(Anno750(24)));
    }];
    [self.downLoadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Anno750(24)));
        make.centerY.equalTo(@0);
        make.height.equalTo(@(Anno750(60)));
        make.width.equalTo(@(Anno750(186)));
    }];
}
- (void)updateWithArrays:(NSArray *)datas{
    long audioSize = 0;
    int num = 0;
    for (int i = 0; i<datas.count; i++) {
        HomeTopModel * model = datas[i];
        if (model.isSelectDown) {
            audioSize += [model.audioSize longValue];
            num += 1;
        }
    }
    int Gnum = (int)audioSize/1024/1024/1024;
    float Mnum = (float)(audioSize -  Gnum * 1024 * 1024 * 1024)/1024/1024;
    if (Gnum>0) {
        self.leftLabel.text = [NSString stringWithFormat:@"已选择%d条,共%dG%.2fM",num,Gnum,Mnum];
    }else{
        self.leftLabel.text = [NSString stringWithFormat:@"已选择%d条,共%.2fM",num,Mnum];
    }
    
}

@end
