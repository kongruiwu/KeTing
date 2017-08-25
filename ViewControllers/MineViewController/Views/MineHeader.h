//
//  MainHeader.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/26.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
@interface MineHeader : UIView

@property (nonatomic, strong) UIImageView * groundImg;
@property (nonatomic, strong) UIImageView * userIcon;
@property (nonatomic, strong) UILabel * userName;
@property (nonatomic, strong) UIButton * clearButton;

@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UILabel * bookLabel;
@property (nonatomic, strong) UILabel * dayLabel;
@property (nonatomic, strong) UILabel * timeValue;
@property (nonatomic, strong) UILabel * bookCount;
@property (nonatomic, strong) UILabel * dayTime;

//@property (nonatomic, strong) UIView * navView;
//@property (nonatomic, strong) UIButton * backBtn;
//@property (nonatomic, strong) UILabel * titleLabel;

- (void)updateDatas;
@end
