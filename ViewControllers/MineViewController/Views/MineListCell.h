//
//  MineListCell.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/6.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
#import "MineListModel.h"
@interface MineListCell : UITableViewCell

@property (nonatomic, strong) UIImageView * leftImg;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * descLabel;
@property (nonatomic, strong) UIImageView * arrowIcon;
@property (nonatomic, strong) UIView * lineView;

- (void)updateWithListModel:(MineListModel *)model;
@end
