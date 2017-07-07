//
//  MyShopedCollectionCell.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/30.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
#import "HomeListenModel.h"
@interface MyShopedCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView * imgView;
@property (nonatomic, strong) UILabel * nameLabel;
- (void)updateWithHomeListenModel:(HomeListenModel *)model;
@end
