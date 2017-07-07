//
//  SelectSectionHeader.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/5.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"

//首页 SectionHeadView
@interface SelectSectionHeader : UIView

@property (nonatomic, strong) UIView * leftView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * iconLabel;
@property (nonatomic, strong) UILabel * checkAll;
@property (nonatomic, strong) UIImageView * arrowImg;
@property (nonatomic, strong) UIButton * checkButton;


- (void)updateWithTitle:(NSString *)title andSection:(NSInteger)section;
@end
