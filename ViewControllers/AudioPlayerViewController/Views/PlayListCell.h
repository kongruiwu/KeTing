//
//  PlayListCell.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/12.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
#import "AVQueenManager.h"
@interface PlayListCell : UITableViewCell

@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UIImageView * downLoadImg;
@property (nonatomic, strong) UILabel * dateLabel;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UILabel * sizeLabel;
@property (nonatomic, strong) UILabel * playStatusLabel;
@property (nonatomic, strong) UIView * topLine;
- (void)updateWithHomeTopModel:(HomeTopModel *)model;
@end
