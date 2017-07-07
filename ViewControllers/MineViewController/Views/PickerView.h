//
//  PickerView.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/6.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
@interface PickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) UIButton * clearBtn;
@property (nonatomic, strong) UIView* showView;
@property (nonatomic, strong) UIView * headView;
@property (nonatomic, strong) UIButton * cannceBtn;
@property (nonatomic, strong) UIButton * sureBtn;
@property (nonatomic, strong) UIPickerView * picker;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) NSArray * pickerDatas;

@property (nonatomic, assign) NSInteger selectRow;

- (void)show;
- (void)disMiss;
@end
