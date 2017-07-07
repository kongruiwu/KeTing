//
//  ListenBookCollectionCell.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/5.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
#import "HomeListenModel.h"
@interface ListenBookCollectionCell : UIView

@property (nonatomic, strong) UIImageView * topImage;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * iconLabel;
@property (nonatomic, strong) UILabel * priceLabel;
@property (nonatomic, strong) UIButton * clickBtn;

- (void)updateWithListenModel:(HomeListenModel *)model;

@end
