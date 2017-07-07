//
//  SubscribeListCell.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/14.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
@interface SubscribeListCell : UITableViewCell

@property (nonatomic, strong) UIImageView * leftImg;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UILabel * descLabel;
@property (nonatomic, strong) UIImageView * nextIcon;
@property (nonatomic, strong) UILabel * updateIcon;
@property (nonatomic, strong) UIView * lineView;
@end
