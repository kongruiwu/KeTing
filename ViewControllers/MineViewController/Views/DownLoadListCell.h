//
//  DownLoadListCell.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/3.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
#import "HomeTopModel.h"
@interface DownLoadListCell : UITableViewCell

@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UIImageView * downLoadImg;
@property (nonatomic, strong) UILabel * downStatus;
@property (nonatomic, strong) UILabel * tagLabel;
@property (nonatomic, strong) UILabel * playStatus;
@property (nonatomic, strong) UIView * line;

- (void)updateWithHistoryModel:(HomeTopModel *)model pausStatus:(BOOL)rec;
@end
