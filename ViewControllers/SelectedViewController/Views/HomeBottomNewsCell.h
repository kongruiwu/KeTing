//
//  HomeBottomNewsCell.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/6.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"

#import "HomeListenModel.h"

@interface HomeBottomNewsCell : UITableViewCell

@property (nonatomic, strong) UIImageView * leftImage;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * descLabel;
//限免标签
@property (nonatomic, strong) UILabel * iconLabel;
//价格标签
@property (nonatomic, strong) UILabel * priceLabel;


- (void)updateWithvoiceStockSecret:(HomeListenModel *)model;

@end
