//
//  ShopCarFooter.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/30.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
#import "ShopCarHander.h"
@interface ShopCarFooter : UIView


@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UIButton * selectBtn;
@property (nonatomic, strong) UILabel * moneyLabel;
@property (nonatomic, strong) UIButton * buyBtn;

- (void)updateWithShopCarHnader:(ShopCarHander *)hander;
@end
