//
//  VoiceUpdateListCell.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/13.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
@interface VoiceUpdateListCell : UITableViewCell

@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UILabel * descLabel;
@property (nonatomic, strong) UIView * bottomLine;
- (void)updateWithHomeListenModel:(HomeTopModel *)model;


@end
