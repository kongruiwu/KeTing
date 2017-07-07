//
//  TopListBottomView.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/9.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTFactory.h"
#import "HomeTopModel.h"
@interface TopListBottomView : UIView

@property (nonatomic, strong) UIView * topLine;
@property (nonatomic, strong) UILabel * leftLabel;
@property (nonatomic, strong) UIButton * downLoadBtn;

- (void)updateWithArrays:(NSArray *)datas;

@end
