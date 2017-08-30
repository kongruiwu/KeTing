//
//  NullView.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/6.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
typedef NS_ENUM(NSInteger,NullType){
    NullTypeNetError = 0,   //网络不给力
    NullTypeNoneLike    ,   //暂无点赞
    NullTypeNoneAudio   ,   //暂无购买音频
    NullTypeNoneListen  ,   //暂无收听
    NullTypeNoneShopCar ,   //购物车为空
    NullTypeNoneSerach  ,   //暂无搜索内容
    NullTypeNoneDown    ,   //暂无下载
    NullTypeNoneTopUp   ,   //暂无充值记录
    NullTypeNoneMessage ,   //暂无信息
};

@interface NullView : UIView

@property (nonatomic, strong) UIImageView * imgView;
@property (nonatomic, strong) UILabel * descLabel;
@property (nonatomic, assign) NullType nullType;
@property (nonatomic, strong) UIButton * reloadBtn;

- (instancetype)initWithFrame:(CGRect)frame andNullType:(NullType)type;
@end
