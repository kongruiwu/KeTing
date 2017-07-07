//
//  DatePickerSelectView.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/5.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
@interface DatePickerSelectView : UIView

@property (nonatomic, strong) UIButton * clearBtn;
@property (nonatomic, strong) UIView* showView;
@property (nonatomic, strong) UIView * headView;
@property (nonatomic, strong) UIButton * cannceBtn;
@property (nonatomic, strong) UIButton * sureBtn;
@property (nonatomic, strong) UIDatePicker * datePicker;
@property (nonatomic, strong) UIView * lineView;

- (void)show;
- (void)disMiss;

@end
