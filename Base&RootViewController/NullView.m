//
//  NullView.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/6.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "NullView.h"

@implementation NullView

- (instancetype)initWithFrame:(CGRect)frame andNullType:(NullType)type{
    self = [super initWithFrame:frame];
    if (self) {
        self.nullType = type;
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    self.backgroundColor = KTColor_BackGround;
    
    self.imgView = [KTFactory creatImageViewWithImage:@""];
    self.descLabel = [KTFactory creatLabelWithText:@""
                                         fontValue:font750(28)
                                         textColor:KTColor_lightGray
                                     textAlignment:NSTextAlignmentCenter];
    [self addSubview:self.imgView];
    [self addSubview:self.descLabel];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(@(Anno750(170)));
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.imgView.mas_bottom).offset(Anno750(30));
    }];
    
}
- (void)setNullType:(NullType)nullType{
    _nullType = nullType;
    NSString * imageName;
    NSString * desc;
    switch (self.nullType) {
        case NullTypeNetError:
            imageName = @"empty_page3";
            desc = @"网络不给力，请检查网络";
            break;
        case NullTypeNoneLike:
            imageName = @"empty_page7";
            desc = @"至今还没赞过呢，你好挑剔啊";
            break;
        case NullTypeNoneAudio:
            imageName = @"empty_page2";
            desc = @"你还没有购买音频，快去逛逛吧";
            break;
        case NullTypeNoneListen:
            imageName = @"empty_page1";
            desc = @"你还没有收听过音频，快去收听吧";
            break;
        case NullTypeNoneShopCar:
            imageName = @"empty_page6";
            desc = @"购物车空空荡荡，快去逛逛吧";
            break;
        case NullTypeNoneSerach:
            imageName = @"empty_page4";
            desc = @"未搜索到相关内容，试试其他关键词吧";
            break;
        case NullTypeNoneDown:
            imageName = @"empty_page5";
            desc = @"你还没有下载音频，快去下载吧";
            break;
        case NullTypeNoneTopUp:
            imageName = @"empty_page4";
            desc = @"暂时没有任何记录";
            break;
        case NullTypeNoneMessage:
            imageName = @"empty_page1";
            desc = @"暂时没有任何消息";
            break;
        default:
            break;
    }
    self.imgView.image = [UIImage imageNamed:imageName];
    self.descLabel.text = desc;
}

@end
