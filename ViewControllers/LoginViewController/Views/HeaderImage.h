//
//  HeaderImage.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/28.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
@interface HeaderImage : UIView

@property (nonatomic, strong) UIButton * clearBtn;
@property (nonatomic, strong) UIImageView * photo;
@property (nonatomic, strong) UIImageView * userIcon;

- (void)updateUserIcon;
@end
