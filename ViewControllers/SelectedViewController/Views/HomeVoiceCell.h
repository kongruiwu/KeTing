//
//  HomeVoiceCell.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/5.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
#import "HomeListenModel.h"

//首页通用cell
@interface HomeVoiceCell : UITableViewCell

@property (nonatomic, strong) UIImageView * leftImage;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * descLabel;
//限免标签
@property (nonatomic, strong) UILabel * iconLabel;
//价格标签
@property (nonatomic, strong) UILabel * priceLabel;

@property (nonatomic, strong) UIView * topLine;
@property (nonatomic, strong) UILabel * updateTime;

@property (nonatomic, strong) UIImageView * sortImg;

- (void)updateWithVoiceModel:(HomeListenModel *)model;
- (void)updateWithVoiceModel:(HomeListenModel *)model andSortNum:(NSInteger)num;
@end
