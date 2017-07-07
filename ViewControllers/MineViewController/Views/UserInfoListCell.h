//
//  UserInfoListCell.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/27.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
@interface UserInfoListCell : UITableViewCell

@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * descLabel;
@property (nonatomic, strong) UIView * bottonline;

- (void)updateWithName:(NSString *)name desc:(NSString *)desc;

@end
