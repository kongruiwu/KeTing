//
//  WI-FISettingCell.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/4.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
@interface WI_FISettingCell : UITableViewCell

@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * desclabel;
@property (nonatomic, strong) UISwitch * switchView;
@property (nonatomic, strong) UIView * lineView;

- (void)updateWithTitle:(NSString *)title desc:(NSString *)desc isOpen:(BOOL)rec;
@end
