//
//  FindListCell.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/13.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
@interface FindListCell : UITableViewCell

@property (nonatomic, strong) UIImageView * leftImg;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UIImageView * nextIcon;
@property (nonatomic, strong) UIView * bottomLine;
- (void)updateWithTitle:(NSString *)title imgName:(NSString *)imgName;

@end
