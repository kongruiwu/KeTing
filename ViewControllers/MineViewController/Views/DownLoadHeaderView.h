//
//  DownLoadHeaderView.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/20.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
@interface DownLoadHeaderView : UIView

@property (nonatomic, strong) UIButton * selectButton;
@property (nonatomic, strong) UIButton * statusButton;
@property (nonatomic, strong) UILabel * countLabel;
@property (nonatomic, strong) UIView * line;
- (void)updateWithCount:(NSArray *)dataArray;
- (void)statusButtonClick:(UIButton *)button;
@end
