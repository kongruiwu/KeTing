//
//  TopListDownCell.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/9.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
#import "HomeTopModel.h"
@interface TopListDownCell : UITableViewCell


@property (nonatomic, strong) UIButton * selctButton;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UILabel * tagLabel;
@property (nonatomic, strong) UILabel * playStutas;

@property (nonatomic, strong) UIView * bottomLine;
- (void)updateWithHomeTopModel:(HomeTopModel *)model;
- (void)updateTimeWithAddTime:(HomeTopModel *)model;
@end
