//
//  PlayerMoreView.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/12.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTFactory.h"
@interface MoreButton : UIButton

@end


@interface PlayerMoreView : UIView


@property (nonatomic, strong) UIView * showView;
@property (nonatomic, strong) MoreButton * closedButton;
@property (nonatomic, strong) MoreButton * shareButton;
@property (nonatomic, strong) UIView * grayView;
@property (nonatomic, strong) UIButton * disbutton;
@property (nonatomic, strong) UIButton * cannceBtn;



- (void)show;
- (void)disMiss;

@end
