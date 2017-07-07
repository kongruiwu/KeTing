//
//  TopHeaderView.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/7.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
@interface TopHeaderView : UIView

@property (nonatomic, strong) UIButton * cateBtn;
@property (nonatomic, strong) UIView * centerLine;
@property (nonatomic, strong) UIButton * downLoadBtn;


- (void)updateWithImages:(NSArray *)images titles:(NSArray *)titles;
@end
