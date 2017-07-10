//
//  HistoryListCell.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/3.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
#import "HomeTopModel.h"
#import "HomeTopModel.h"
#import "HomeListenModel.h"
@interface HistoryListCell : UITableViewCell

@property (nonatomic, strong) UIImageView * leftImg;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * tagLabel;
@property (nonatomic, strong) UILabel * playStatus;
@property (nonatomic, strong) UIView * lineView;
- (void)updateWithHistoryModel:(HomeTopModel *)model;

@end
