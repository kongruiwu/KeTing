//
//  SettingListCell.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/4.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
@interface SettingListCell : UITableViewCell

@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * descLabel;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UIImageView * arrowIcon;
- (void)updateWithName:(NSString *)name desc:(NSString *)desc;
- (void)updateWithName:(NSString *)name desc:(NSString *)desc hiddenArrow:(BOOL)rec;
@end
