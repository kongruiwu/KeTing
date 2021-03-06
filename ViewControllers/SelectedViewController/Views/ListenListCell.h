//
//  ListenListCell.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/12.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
#import "HomeListenModel.h"

@protocol ListenListDelegate <NSObject>

- (void)addToShopCar:(UIButton *)btn;
- (void)buyThisBook:(UIButton *)btn;
- (void)checkShopCar;

@end

@interface ListenListCell : UITableViewCell

@property (nonatomic, strong) UIImageView * leftImg;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * descLabel;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UILabel * priceLabel;
@property (nonatomic, strong) UILabel * saleStatus;
@property (nonatomic, strong) UIButton * shopCar;
@property (nonatomic, strong) UIButton * buybtn;
@property (nonatomic, strong) UIView * bottomLine;
@property (nonatomic, strong) UIImageView * sortImg;
@property (nonatomic, assign) id<ListenListDelegate> delegate;

- (void)updateWithListenModel:(HomeListenModel *)model;
- (void)updateWithNum:(NSInteger)num;

@end
