//
//  RecommendView.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/14.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
#import "HomeListenModel.h"
@interface RecommendView : UIView

@property (nonatomic, strong) UIImageView * topImg;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * descLabel;
@property (nonatomic, strong) UILabel * priceLabel;
@property (nonatomic, strong) UIButton * coverBtn;
@property (nonatomic, strong) UILabel * iconLabel;
- (void)updateWithHomeListenModel:(HomeListenModel *)model;
@end
