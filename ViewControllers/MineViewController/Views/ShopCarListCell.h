//
//  ShopCarListCell.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/30.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
#import "HomeListenModel.h"
@protocol ShopCarDelegate <NSObject>

- (void)selectBook:(UIButton *)btn;

@end

@interface ShopCarListCell : UITableViewCell

@property (nonatomic, strong) UIButton * selctButton;
@property (nonatomic, strong) UIImageView * leftImg;
@property (nonatomic, strong) UILabel * namelabel;
@property (nonatomic, strong) UILabel * descLabel;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UILabel * priceLabel;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UIButton * clearBtn;
@property (nonatomic, assign) id<ShopCarDelegate> delegate;


- (void)updateWithHomeListenModel:(HomeListenModel *)model;
@end
